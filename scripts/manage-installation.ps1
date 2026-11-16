[CmdletBinding()]
param(
    [ValidateSet('Install','Update','Restore')][string]$Action = 'Install',
    [string]$SourceRoot = '',
    [string]$SkillsTarget = (Join-Path $HOME '.agents/skills'),
    [string]$GuidanceTarget = (Join-Path $HOME '.codex/AGENTS.md'),
    [string]$BackupBase = (Join-Path $HOME '.codex/backups/odysseuslight'),
    [string]$BackupPath,
    [string]$PreviousBackupPath,
    [int]$TestFailureAfter = 0
)
$ErrorActionPreference = 'Stop'
if ([string]::IsNullOrWhiteSpace($SourceRoot)) { $SourceRoot = Split-Path -Parent $PSScriptRoot }
$old = @('bootstrap-project','onboard-project','plan-milestone','deliver-issue','check-context-health')
$new = @('odysseus-plan-project','odysseus-plan-milestone','odysseus-review-plan')
$names = $old + $new
$utf8 = New-Object System.Text.UTF8Encoding($false)
function Write-Text($path,$text) {
    New-Item -ItemType Directory -Force (Split-Path -Parent $path) | Out-Null
    [IO.File]::WriteAllText($path,$text,$utf8)
}
function Assert-PlainPath($path) {
    $full = [IO.Path]::GetFullPath($path)
    $cursor = $full
    while ($cursor) {
        if (Test-Path -LiteralPath $cursor) {
            if ((Get-Item -LiteralPath $cursor -Force).Attributes -band [IO.FileAttributes]::ReparsePoint) { throw "Linked paths are unsupported: $cursor" }
        }
        $parent = Split-Path -Parent $cursor
        if ($parent -eq $cursor) { break }; $cursor = $parent
    }
    if (Test-Path -LiteralPath $full -PathType Container) {
        if (Get-ChildItem -LiteralPath $full -Force -Recurse | Where-Object { $_.Attributes -band [IO.FileAttributes]::ReparsePoint }) { throw "Linked content is unsupported: $full" }
    }
    return $full
}
function Tree-Id($path) {
    if (!(Test-Path -LiteralPath $path)) { return 'absent' }
    $rows = @(Get-ChildItem -LiteralPath $path -Recurse -Force -File | Sort-Object FullName | ForEach-Object { $_.FullName.Substring($path.Length) + ':' + (Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash })
    $sha = [Security.Cryptography.SHA256]::Create()
    try { return [BitConverter]::ToString($sha.ComputeHash([Text.Encoding]::UTF8.GetBytes(($rows -join "`n")))).Replace('-','') } finally { $sha.Dispose() }
}
function Remove-Owned($path,$root) {
    $resolved = [IO.Path]::GetFullPath($path)
    if (!(($resolved + [IO.Path]::DirectorySeparatorChar).StartsWith($root.TrimEnd('\','/') + [IO.Path]::DirectorySeparatorChar,[StringComparison]::OrdinalIgnoreCase)) -or $resolved -eq $root) { throw 'Unsafe removal target' }
    Assert-PlainPath $resolved | Out-Null
    if (Test-Path -LiteralPath $resolved) { Remove-Item -LiteralPath $resolved -Recurse -Force }
}
function Read-Guidance($path) { if (Test-Path -LiteralPath $path) { return [IO.File]::ReadAllText($path) }; return '' }
$SkillsTarget = Assert-PlainPath $SkillsTarget
$GuidanceTarget = Assert-PlainPath $GuidanceTarget
$BackupBase = Assert-PlainPath $BackupBase
foreach ($name in $names) {
    $owned = Join-Path $SkillsTarget $name
    foreach ($candidate in @($BackupBase,$SourceRoot,$GuidanceTarget)) {
        $fullCandidate = [IO.Path]::GetFullPath($candidate)
        if ($fullCandidate -eq $owned -or $fullCandidate.StartsWith($owned + [IO.Path]::DirectorySeparatorChar,[StringComparison]::OrdinalIgnoreCase)) { throw 'Source, backup, and guidance must be outside managed skill directories.' }
    }
}
$pattern = '(?s)<!-- (?:codex-project-os|odysseuslight):start -->.*?<!-- (?:codex-project-os|odysseuslight):end -->'
if ($Action -eq 'Restore') {
    if (!$BackupPath) { throw 'Restore requires -BackupPath from the installation result.' }
    $BackupPath = Assert-PlainPath $BackupPath
    $receipt = Get-Content -LiteralPath (Join-Path $BackupPath 'installation.json') -Raw | ConvertFrom-Json
    if ($receipt.skillsTarget -ne $SkillsTarget -or $receipt.guidanceTarget -ne $GuidanceTarget) { throw 'Restore targets must match the installation receipt.' }
    foreach ($name in $names) {
        if ((Tree-Id (Join-Path $SkillsTarget $name)) -ne $receipt.installed.$name) { throw "Managed skill changed since installation: $name. Preserve it before restoring." }
        if ((Tree-Id (Join-Path $BackupPath "skills/$name")) -ne $receipt.originalSkills.$name) { throw "Backup missing or modified: $name" }
    }
    $current = Read-Guidance $GuidanceTarget
    if ([regex]::Matches($current,$pattern).Count -ne 1 -or [regex]::Match($current,$pattern).Value -cne $receipt.installedBlock) { throw 'Managed guidance changed; restore stopped without writes.' }
    $safety = Join-Path $BackupPath ('restore-safety-' + [guid]::NewGuid().ToString('N'))
    New-Item -ItemType Directory -Path $safety | Out-Null
    foreach ($name in $names) { $p=Join-Path $SkillsTarget $name; if (Test-Path -LiteralPath $p) { Copy-Item -LiteralPath $p -Destination (Join-Path $safety $name) -Recurse } }
    try { foreach ($name in $names) {
        Remove-Owned (Join-Path $SkillsTarget $name) $SkillsTarget
        $saved = Join-Path $BackupPath "skills/$name"
        if (Test-Path -LiteralPath $saved) { Copy-Item -LiteralPath $saved -Destination (Join-Path $SkillsTarget $name) -Recurse }
    }
    $restored = $current.Replace($receipt.installedBlock,[string]$receipt.originalBlock)
    if (!$receipt.guidanceExisted -and [string]::IsNullOrWhiteSpace($restored)) {
        Remove-Item -LiteralPath $GuidanceTarget
    } else { Write-Text $GuidanceTarget $restored }
    } catch {
        foreach ($name in $names) {
            Remove-Owned (Join-Path $SkillsTarget $name) $SkillsTarget
            $saved=Join-Path $safety $name; if (Test-Path -LiteralPath $saved) { Copy-Item -LiteralPath $saved -Destination (Join-Path $SkillsTarget $name) -Recurse }
        }
        Write-Text $GuidanceTarget $current
        throw
    }
    [pscustomobject]@{ status='restored'; backup=$BackupPath }; return
}
$SourceRoot = Assert-PlainPath $SourceRoot
foreach ($name in $new) { if (!(Test-Path -LiteralPath (Join-Path $SourceRoot "skills/$name/SKILL.md"))) { throw "Missing source skill: $name" } }
$block = @'
<!-- odysseuslight:start -->
# OdysseusLight planning guidance

- Use OdysseusLight for product and milestone planning when relevant to the request. Planning documents remain readable by any implementation system.
- The planner defines milestone outcomes and boundaries. The implementer chooses technical steps and execution splits after inspecting the repository.
- During planning, resolve blocking product decisions conversationally before marking a milestone ready for implementation. Continue independent planning while a decision is pending; keep ordinary technical choices with the implementer.
- Carry forward decisions and authorization already given. Do not request duplicate approvals for unchanged scope or turn routine discoveries into new permission procedures.
- Preserve intended outcomes and meaningful constraints while adapting routine implementation details to evidence. Raise material product, cost, or consequential-risk changes with the owner.
- Preserve unrelated work and personal guidance. Distinguish observed behavior, desired behavior, assumptions, and unresolved decisions. Never claim unverified work is complete.
- Do not automatically publish issues, impose execution envelopes, or migrate existing project instructions. Identify conflicting legacy guidance and propose scoped adoption when requested.
<!-- odysseuslight:end -->
'@
$original = Read-Guidance $GuidanceTarget
$matches = [regex]::Matches($original,$pattern)
if ($matches.Count -gt 1) { throw 'Multiple managed guidance blocks; resolve ambiguity before installation.' }
foreach ($marker in @('codex-project-os','odysseuslight')) {
    $starts = [regex]::Matches($original,"<!-- ${marker}:start -->").Count
    $ends = [regex]::Matches($original,"<!-- ${marker}:end -->").Count
    if ($starts -ne $ends -or $starts -gt 1) { throw 'Malformed guidance markers; no changes made.' }
}
$originalBlock = if ($matches.Count) { $matches[0].Value } else { '' }
$updated = if ($matches.Count) { $original.Replace($originalBlock,$block) } else { $original + "`n" + $block }
$same = $originalBlock -ceq $block
foreach ($name in $old) { if (Test-Path -LiteralPath (Join-Path $SkillsTarget $name)) { $same=$false } }
foreach ($name in $new) { if ((Tree-Id (Join-Path $SkillsTarget $name)) -ne (Tree-Id (Join-Path $SourceRoot "skills/$name"))) { $same=$false } }
if ($same) { [pscustomobject]@{status='already-installed'; backupBase=$BackupBase}; return }
if ($Action -eq 'Update') {
    if (!$PreviousBackupPath) { throw 'Update requires -PreviousBackupPath from the installed version.' }
    $PreviousBackupPath = Assert-PlainPath $PreviousBackupPath
    $previous = Get-Content -LiteralPath (Join-Path $PreviousBackupPath 'installation.json') -Raw | ConvertFrom-Json
    if ($previous.skillsTarget -ne $SkillsTarget -or $previous.guidanceTarget -ne $GuidanceTarget) { throw 'Update targets must match the previous installation.' }
    foreach ($name in $names) {
        if ((Tree-Id (Join-Path $SkillsTarget $name)) -ne $previous.installed.$name) { throw "Managed skill changed since installation: $name. Preserve it before updating." }
    }
    if ($originalBlock -cne $previous.installedBlock) { throw 'Managed guidance changed; update stopped without writes.' }
} else {
    foreach ($name in $new) { if (Test-Path -LiteralPath (Join-Path $SkillsTarget $name)) { throw "Existing OdysseusLight skill differs: $name. Use Update with the previous backup, or preserve it before replacing." } }
}
$BackupPath = Join-Path $BackupBase ((Get-Date -Format 'yyyyMMdd-HHmmss') + '-' + [guid]::NewGuid().ToString('N').Substring(0,8))
New-Item -ItemType Directory -Force (Join-Path $BackupPath 'skills'),$SkillsTarget | Out-Null
foreach ($name in $names) { $p=Join-Path $SkillsTarget $name; if (Test-Path -LiteralPath $p) { Copy-Item -LiteralPath $p -Destination (Join-Path $BackupPath "skills/$name") -Recurse } }
$originalSkills=@{}; foreach ($name in $names) {
    $originalSkills[$name]=Tree-Id (Join-Path $SkillsTarget $name)
    if ($originalSkills[$name] -ne (Tree-Id (Join-Path $BackupPath "skills/$name"))) { throw "Backup verification failed: $name" }
}
Write-Text (Join-Path $BackupPath 'AGENTS.original.md') $original
$guidanceExisted = Test-Path -LiteralPath $GuidanceTarget
$count=0
try {
    foreach ($name in $old) { Remove-Owned (Join-Path $SkillsTarget $name) $SkillsTarget }
    foreach ($name in $new) {
        if ($Action -eq 'Update') { Remove-Owned (Join-Path $SkillsTarget $name) $SkillsTarget }
        Copy-Item -LiteralPath (Join-Path $SourceRoot "skills/$name") -Destination (Join-Path $SkillsTarget $name) -Recurse
        $count++; if ($TestFailureAfter -gt 0 -and $count -eq $TestFailureAfter) { throw 'Synthetic installation failure' }
    }
    Write-Text $GuidanceTarget $updated
    $installed=@{}; foreach ($name in $names) { $installed[$name]=Tree-Id (Join-Path $SkillsTarget $name) }
    $receipt=@{skillsTarget=$SkillsTarget;guidanceTarget=$GuidanceTarget;installed=$installed;installedBlock=$block;originalBlock=$originalBlock;originalSkills=$originalSkills;guidanceExisted=$guidanceExisted}
    Write-Text (Join-Path $BackupPath 'installation.json') ($receipt | ConvertTo-Json -Depth 6)
} catch {
    foreach ($name in $names) {
        Remove-Owned (Join-Path $SkillsTarget $name) $SkillsTarget
        $saved=Join-Path $BackupPath "skills/$name"; if (Test-Path -LiteralPath $saved) { Copy-Item -LiteralPath $saved -Destination (Join-Path $SkillsTarget $name) -Recurse }
    }
    if ($guidanceExisted) { Write-Text $GuidanceTarget $original } elseif (Test-Path -LiteralPath $GuidanceTarget) { Remove-Item -LiteralPath $GuidanceTarget }
    throw
}
$resultStatus = if ($Action -eq 'Update') { 'updated' } else { 'installed' }
[pscustomobject]@{status=$resultStatus;backup=$BackupPath;skills=$new;restart='Start a new chat to refresh skill discovery.'}
