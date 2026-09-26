# Enlaza cada skill de este repo en las carpetas que leen Codex y Claude Code (Windows).
# Usa "junctions", que no necesitan permisos de administrador. Idempotente.
# Uso:  powershell -ExecutionPolicy Bypass -File .\install.ps1
$ErrorActionPreference = "Stop"
$Repo = $PSScriptRoot
$Targets = @("$HOME\.agents\skills", "$HOME\.claude\skills")

foreach ($t in $Targets) {
  New-Item -ItemType Directory -Force -Path $t | Out-Null
  # Quita junctions rotas que apuntaban a este repo
  Get-ChildItem $t -Force | Where-Object { $_.LinkType -eq "Junction" } | ForEach-Object {
    $target = @($_.Target)[0]
    if ($target -like "$Repo*" -and -not (Test-Path $target)) { cmd /c rmdir "$($_.FullName)" | Out-Null }
  }
  foreach ($s in Get-ChildItem "$Repo\skills" -Directory) {
    $dest = Join-Path $t $s.Name
    if (Test-Path $dest) {
      $item = Get-Item $dest -Force
      if ($item.LinkType -ne "Junction") { Write-Host "AVISO: $dest ya existe y no es un enlace, lo dejo como esta"; continue }
      cmd /c rmdir "$dest" | Out-Null
    }
    New-Item -ItemType Junction -Path $dest -Target $s.FullName | Out-Null
  }
  Write-Host "ok  $((Get-ChildItem "$Repo\skills" -Directory).Count) skills enlazadas en $t"
}

Write-Host ""
Write-Host "Hermes: anade esto a ~/.hermes/config.yaml (una sola vez):"
Write-Host ""
Write-Host "  skills:"
Write-Host "    external_dirs:"
Write-Host "      - ~/.agents/skills"
Write-Host ""
Write-Host "Reinicia Claude Code / Codex / Hermes para que carguen las skills nuevas."
