# build.sh - Windows Build Script
#!/bin/bash

echo "🚀 Building CAS Label Generator for Windows..."

# Schritt 1: Dependencies installieren
echo "📦 Installing dependencies..."
npm install

# Schritt 2: Assets vorbereiten
echo "🎨 Preparing assets..."
mkdir -p assets
mkdir -p build

# Schritt 3: Icon konvertieren (falls PNG vorhanden)
if [ -f "assets/icon.png" ]; then
    echo "🖼️  Converting icon to ICO format..."
    # Du kannst online converter verwenden oder imagemagick:
    # convert assets/icon.png -resize 256x256 assets/icon.ico
fi

# Schritt 4: Build für Windows
echo "🔨 Building for Windows x64..."
npm run build-win64

echo "🔨 Building for Windows x32..."
npm run build-win32

echo "📱 Building portable version..."
npx electron-builder --win --x64 --config.win.target=portable

echo "✅ Build complete! Check the 'dist' folder."

# Schritt 5: Test-Build starten (optional)
echo "🧪 Starting test build..."
npm start

#######################################################
# PowerShell Version für Windows
#######################################################

# build.ps1
Write-Host "🚀 Building CAS Label Generator for Windows..." -ForegroundColor Green

# Dependencies installieren
Write-Host "📦 Installing dependencies..." -ForegroundColor Yellow
npm install

# Assets erstellen
Write-Host "🎨 Preparing assets..." -ForegroundColor Yellow
New-Item -ItemType Directory -Path "assets" -Force
New-Item -ItemType Directory -Path "build" -Force

# Icon kopieren (falls vorhanden)
if (Test-Path "icon.png") {
    Copy-Item "icon.png" "assets/icon.ico"
}

# Build für Windows
Write-Host "🔨 Building for Windows..." -ForegroundColor Yellow
npm run build-win

Write-Host "✅ Build complete! Check the 'dist' folder." -ForegroundColor Green

# Optional: Installer testen
Write-Host "🧪 Testing installer..." -ForegroundColor Yellow
$installer = Get-ChildItem -Path "dist" -Filter "*.exe" | Select-Object -First 1
if ($installer) {
    Write-Host "Installer found: $($installer.Name)"
    Write-Host "You can now install and test the application."
}

#######################################################
# package-scripts.json - Erweiterte NPM Scripts
#######################################################

# Füge diese Scripts zu deiner package.json hinzu:
{
  "scripts": {
    "start": "electron .",
    "dev": "electron . --dev",
    "build": "electron-builder",
    "build-win": "electron-builder --win",
    "build-win32": "electron-builder --win --ia32",
    "build-win64": "electron-builder --win --x64",
    "build-portable": "electron-builder --win --x64 --config.win.target=portable",
    "build-all": "npm run build-win32 && npm run build-win64 && npm run build-portable",
    "clean": "rimraf dist node_modules",
    "rebuild": "npm run clean && npm install && npm run build",
    "test": "echo \"No tests specified\" && exit 0",
    "lint": "echo \"No linting configured\" && exit 0",
    "postinstall": "electron-builder install-app-deps",
    "pack": "electron-builder --dir",
    "dist": "electron-builder --publish=never"
  }
}

#######################################################
# Installer Konfiguration (build/installer.nsh)
#######################################################

# Erstelle Ordner: build/installer.nsh
!macro preInit
    SetRegView 64
    WriteRegExpandStr HKLM "${INSTALL_REGISTRY_KEY}" InstallLocation "$INSTDIR"
    WriteRegExpandStr HKCU "${INSTALL_REGISTRY_KEY}" InstallLocation "$INSTDIR"
    SetRegView 32
    WriteRegExpandStr HKLM "${INSTALL_REGISTRY_KEY}" InstallLocation "$INSTDIR"
    WriteRegExpandStr HKCU "${INSTALL_REGISTRY_KEY}" InstallLocation "$INSTDIR"
!macroend

# Surface Tablet Optimierungen
!macro customInstall
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Run" "CASLabelGenerator" "$INSTDIR\CAS Label Generator.exe --startup"
!macroend

#######################################################
# Deployment Checklist
#######################################################

echo "📋 Windows Deployment Checklist:"
echo ""
echo "✅ Prerequisites:"
echo "   - Node.js 18+ installiert"
echo "   - Git installiert"
echo "   - Visual Studio Build Tools (für native modules)"
echo ""
echo "📁 Dateien die benötigt werden:"
echo "   - package.json (✓ erstellt)"
echo "   - main.js (✓ erstellt)"
echo "   - index.html (✓ vorhanden)"
echo "   - assets/icon.ico (erstelle aus PNG)"
echo ""
echo "🔧 Build Commands:"
echo "   npm install          # Dependencies installieren"
echo "   npm run build-win    # Windows Build erstellen"
echo "   npm run build-portable # Portable Version"
echo ""
echo "📱 Surface Tablet Setup:"
echo "   - Touch-optimierte UI (✓ implementiert)"
echo "   - Große Buttons (✓ CSS angepasst)"
echo "   - Windows 10/11 kompatibel (✓)"
echo ""
echo "🖨️ Drucker Integration:"
echo "   - Automatische Erkennung (✓)"
echo "   - ESC/POS Support (✓)"
echo "   - Brother QL Support (✓)"
echo "   - DYMO Support (✓)"
echo ""
echo "🚀 Nächste Schritte:"
echo "   1. npm install"
echo "   2. npm run build-win"
echo "   3. Teste dist/CAS Label Generator Setup.exe"
echo "   4. Installiere auf Surface Tablet"
echo "   5. Teste Labeldrucker"