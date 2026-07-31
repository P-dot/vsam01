# Publicación del repositorio `vsam01`

## Ubicación local

El repositorio quedará directamente en:

```text
C:\Carrera_Ciberseguridad\06_Portfolio_GitHub\vsam01
```

No se copia dentro de `zos-adcd-hercules-engineering-lab`.

## 1. Descomprimir y preparar la carpeta

Se presupone que el ZIP está en Descargas:

```powershell
$Base = "C:\Carrera_Ciberseguridad\06_Portfolio_GitHub"
$Zip  = "$env:USERPROFILE\Downloads\vsam01.zip"
$Repo = Join-Path $Base "vsam01"
$Tmp  = "$env:TEMP\vsam01-import"

Remove-Item $Tmp -Recurse -Force -ErrorAction SilentlyContinue
Expand-Archive -Path $Zip -DestinationPath $Tmp -Force

if (Test-Path $Repo) {
    throw "La carpeta ya existe: $Repo"
}

Copy-Item `
  -Path (Join-Path $Tmp "vsam01") `
  -Destination $Base `
  -Recurse

Set-Location $Repo
Get-ChildItem
```

## 2. Inicializar Git

```powershell
Set-Location "C:\Carrera_Ciberseguridad\06_Portfolio_GitHub\vsam01"

git init
git branch -M main
git add .
git status --short
git commit -m "Create VSAM01 foundations lab"
```

## 3A. Crear y subir con GitHub CLI

Este método crea automáticamente el repositorio público `P-dot/vsam01`:

```powershell
gh auth status
gh repo create P-dot/vsam01 --public --source . --remote origin --push
```

## 3B. Alternativa si el repositorio ya se creó en GitHub

Después de crear manualmente un repositorio vacío llamado `vsam01` en la cuenta `P-dot`:

```powershell
git remote add origin https://github.com/P-dot/vsam01.git
git push -u origin main
```

## 4. Verificación

```powershell
git status
git remote -v
git log -1 --oneline
```

Resultado esperado:

```text
On branch main
Your branch is up to date with 'origin/main'.
nothing to commit, working tree clean
```
