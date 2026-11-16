$ErrorActionPreference='Stop'
$script=Join-Path (Split-Path -Parent $PSScriptRoot) 'scripts/manage-installation.ps1'
$root=Join-Path ([IO.Path]::GetTempPath()) ('odysseus-test-'+[guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $root | Out-Null
$source=Join-Path $root 'source'; $target=Join-Path $root 'skills'; $guidance=Join-Path $root 'AGENTS.md'; $backups=Join-Path $root 'backups'
$old=@('bootstrap-project','onboard-project','plan-milestone','deliver-issue','check-context-health')
$new=@('odysseus-plan-project','odysseus-plan-milestone','odysseus-review-plan')
function Check($condition,$message) { if (!$condition) { throw $message } }
foreach($name in $new) { New-Item -ItemType Directory -Force "$source/skills/$name" | Out-Null; Set-Content "$source/skills/$name/SKILL.md" "source $name" }
foreach($name in ($old+@('unrelated'))) { New-Item -ItemType Directory -Force "$target/$name" | Out-Null; Set-Content "$target/$name/SKILL.md" "old $name" }
$original="personal before`n<!-- codex-project-os:start -->`nold rules`n<!-- codex-project-os:end -->`npersonal after"
[IO.File]::WriteAllText($guidance,$original)
$args=@{SourceRoot=$source;SkillsTarget=$target;GuidanceTarget=$guidance;BackupBase=$backups}
$failed=$false;try { & $script @args -TestFailureAfter 1 | Out-Null } catch { $failed=$true }
Check $failed 'Failure injection did not fail'
Check ((Get-Content $guidance -Raw) -ceq $original) 'Failure changed guidance'
foreach($name in $old) { Check (Test-Path "$target/$name/SKILL.md") 'Failure lost old skill' }
foreach($name in $new) { Check (!(Test-Path "$target/$name")) 'Failure retained partial skill' }
$installed=& $script @args
Check ($installed.status -eq 'installed') 'Install failed'
foreach($name in $old) { Check (!(Test-Path "$target/$name")) 'Old skill still discoverable' }
foreach($name in $new) { Check (Test-Path "$target/$name/SKILL.md") 'New skill absent' }
Check (Test-Path "$target/unrelated/SKILL.md") 'Unrelated skill removed'
Check ((& $script @args).status -eq 'already-installed') 'Repeat install not idempotent'
Add-Content $guidance "`nlater personal guidance"
Add-Content "$target/unrelated/SKILL.md" 'later personal change'
Add-Content "$target/$($new[0])/SKILL.md" 'user edit'
$blocked=$false;try { & $script @args -Action Restore -BackupPath $installed.backup | Out-Null } catch { $blocked=$true }
Check $blocked 'Restore overwrote changed managed skill'
Check (Test-Path "$target/$($new[1])/SKILL.md") 'Blocked restore mutated skills'
Copy-Item "$source/skills/$($new[0])/SKILL.md" "$target/$($new[0])/SKILL.md" -Force
& $script @args -Action Restore -BackupPath $installed.backup | Out-Null
Check ((Get-Content $guidance -Raw).Contains('later personal guidance')) 'Restore lost later personal guidance'
Check ((Get-Content $guidance -Raw).Contains($original)) 'Restore failed original block'
Check ((Get-Content "$target/unrelated/SKILL.md" -Raw).Contains('later personal change')) 'Restore lost unrelated skill edits'
foreach($name in $old) { Check (Test-Path "$target/$name/SKILL.md") 'Restore lost old skill' }
foreach($name in $new) { Check (!(Test-Path "$target/$name")) 'Restore retained new skill' }
$second=& $script @args
Add-Content (Join-Path $second.backup "skills/$($old[0])/SKILL.md") 'backup tamper'
$blocked=$false;try { & $script @args -Action Restore -BackupPath $second.backup | Out-Null } catch { $blocked=$true }
Check $blocked 'Restore accepted modified backup'
Check (Test-Path "$target/$($new[0])/SKILL.md") 'Backup refusal changed installed state'
$before=Get-Content $guidance -Raw
[IO.File]::WriteAllText($guidance,$before + "`n<!-- codex-project-os:start -->")
$blocked=$false;try { & $script @args | Out-Null } catch { $blocked=$true }
Check $blocked 'Install accepted malformed guidance'
Check (Test-Path "$target/$($new[0])/SKILL.md") 'Malformed guidance refusal changed skills'
$cleanArgs=@{SourceRoot=$source;SkillsTarget=(Join-Path $root 'clean-skills');GuidanceTarget=(Join-Path $root 'clean-AGENTS.md');BackupBase=(Join-Path $root 'clean-backups')}
$clean=& $script @cleanArgs
& $script @cleanArgs -Action Restore -BackupPath $clean.backup | Out-Null
Check (!(Test-Path $cleanArgs.GuidanceTarget)) 'Clean restore left a formerly absent guidance file'
$clean=& $script @cleanArgs
Add-Content $cleanArgs.GuidanceTarget "`nlater personal guidance"
& $script @cleanArgs -Action Restore -BackupPath $clean.backup | Out-Null
Check ((Get-Content $cleanArgs.GuidanceTarget -Raw).Contains('later personal guidance')) 'Clean restore removed later guidance'
Write-Output "Installation scenarios passed. Synthetic fixtures retained at $root"
