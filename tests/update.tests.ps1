$ErrorActionPreference='Stop'
$script=Join-Path (Split-Path -Parent $PSScriptRoot) 'scripts/manage-installation.ps1'
$root=Join-Path ([IO.Path]::GetTempPath()) ('odysseus-update-test-'+[guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $root | Out-Null
$source=Join-Path $root 'source'; $target=Join-Path $root 'skills'; $guidance=Join-Path $root 'AGENTS.md'; $backups=Join-Path $root 'backups'
$names=@('odysseus-plan-project','odysseus-plan-milestone','odysseus-review-plan')
function Check($condition,$message) { if (!$condition) { throw $message } }
function Expect-Failure($operation,$message) { $failed=$false;try { & $operation | Out-Null } catch { $failed=$true }; Check $failed $message }
foreach($name in $names) { New-Item -ItemType Directory -Force "$source/skills/$name" | Out-Null; Set-Content "$source/skills/$name/SKILL.md" "version one $name" }
Set-Content "$source/skills/$($names[0])/obsolete.md" 'old support file'
[IO.File]::WriteAllText($guidance,'personal guidance')
$args=@{SourceRoot=$source;SkillsTarget=$target;GuidanceTarget=$guidance;BackupBase=$backups}
$legacyScript=Join-Path $root 'legacy-installer.ps1'
$legacyText=[IO.File]::ReadAllText($script)
$legacyText=[regex]::Replace($legacyText,'(?m)^- During planning, resolve blocking product decisions.*\r?\n','')
$legacyText=[regex]::Replace($legacyText,'(?m)^- Carry forward decisions and authorization.*\r?\n','')
[IO.File]::WriteAllText($legacyScript,$legacyText)
$first=& $legacyScript @args
$oldGuidance=Get-Content $guidance -Raw
$oldFirst=Get-Content "$target/$($names[0])/SKILL.md" -Raw
# Simulate a new released skill set with a removed support file.
foreach($name in $names) { Set-Content "$source/skills/$name/SKILL.md" "version two $name" }
Remove-Item -LiteralPath "$source/skills/$($names[0])/obsolete.md"
Add-Content $guidance "`nlater personal guidance"
$beforeUpdate=Get-Content $guidance -Raw
Expect-Failure { & $script @args -Action Update } 'Update accepted missing previous backup'
Add-Content "$target/$($names[0])/SKILL.md" 'user customization'
Expect-Failure { & $script @args -Action Update -PreviousBackupPath $first.backup } 'Update overwrote customized skill'
[IO.File]::WriteAllText("$target/$($names[0])/SKILL.md",$oldFirst)
[IO.File]::WriteAllText($guidance,$beforeUpdate.Replace('The planner defines','The customized planner defines'))
Expect-Failure { & $script @args -Action Update -PreviousBackupPath $first.backup } 'Update overwrote customized managed guidance'
[IO.File]::WriteAllText($guidance,$beforeUpdate)
Expect-Failure { & $script @args -Action Update -PreviousBackupPath $first.backup -TestFailureAfter 1 } 'Injected update failure did not fail'
Check ((Get-Content "$target/$($names[0])/SKILL.md" -Raw) -ceq $oldFirst) 'Failed update did not restore old skill'
Check (Test-Path "$target/$($names[0])/obsolete.md") 'Failed update lost removed support file'
Check ((Get-Content $guidance -Raw) -ceq $beforeUpdate) 'Failed update changed guidance'
$updated=& $script @args -Action Update -PreviousBackupPath $first.backup
Check ($updated.status -eq 'updated') 'Update did not complete'
Check (!(Test-Path "$target/$($names[0])/obsolete.md")) 'Update retained obsolete source file'
Check ((Get-Content "$target/$($names[0])/SKILL.md" -Raw).Contains('version two')) 'Update missed new content'
Check ((Get-Content $guidance -Raw).Contains('later personal guidance')) 'Update lost personal guidance'
Check ((Get-Content $guidance -Raw).Contains('resolve blocking product decisions conversationally')) 'Update missed new managed guidance'
Check ((& $script @args -Action Update -PreviousBackupPath $updated.backup).status -eq 'already-installed') 'Repeated update not a no-op'
Add-Content $guidance "`nafter upgrade personal guidance"
& $script @args -Action Restore -BackupPath $updated.backup | Out-Null
Check ((Get-Content "$target/$($names[0])/SKILL.md" -Raw) -ceq $oldFirst) 'Restore did not restore previous release'
Check (Test-Path "$target/$($names[0])/obsolete.md") 'Restore missed old support file'
Check ((Get-Content $guidance -Raw).Contains('after upgrade personal guidance')) 'Restore lost later guidance'
Check (!(Get-Content $guidance -Raw).Contains('resolve blocking product decisions conversationally')) 'Restore did not restore old managed guidance'
& $script @args -Action Restore -BackupPath $first.backup | Out-Null
Check (!(Test-Path "$target/$($names[0])")) 'Original backup no longer restores original state'
Write-Output "Update scenarios passed. Synthetic fixtures retained at $root"
