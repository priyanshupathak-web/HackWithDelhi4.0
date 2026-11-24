# ===================================================================
# Kisan Sathi Backend PowerShell Launcher
# ===================================================================

$jdkPath = "C:\Users\priyanshu\.jdks\openjdk-26.0.2.1"
if (Test-Path "$jdkPath\bin\java.exe") {
    $env:JAVA_HOME = $jdkPath
    $env:PATH = "$jdkPath\bin;$env:PATH"
    $javaExe = "$jdkPath\bin\java.exe"
} else {
    $javaExe = "java"
}

Set-Location $PSScriptRoot

Write-Host "🌾 Starting Kisan Sathi Spring Boot Backend (Port 8080)..." -ForegroundColor Green
Write-Host "🌐 Website URL:           http://localhost:8080/" -ForegroundColor Cyan
Write-Host "📖 Swagger Documentation: http://localhost:8080/swagger-ui.html" -ForegroundColor Cyan
Write-Host "🗄️ Database Console:      http://localhost:8080/h2-console" -ForegroundColor Cyan
Write-Host "============================================================"

if (-not (Test-Path "target\kisan-sathi-backend-1.0.0.jar")) {
    Write-Host "Building JAR file..." -ForegroundColor Yellow
    & "C:\Program Files\JetBrains\IntelliJ IDEA 2026.2.2\plugins\maven-plugin\lib\maven3\bin\mvn.cmd" package -DskipTests
}

if ($env:DB_PASSWORD) {
    Write-Host "Connecting to MySQL database 'kisan_sathi_db' with user '$($env:DB_USERNAME)'..." -ForegroundColor Green
    & $javaExe -jar target\kisan-sathi-backend-1.0.0.jar
} else {
    Write-Host "Running with 'dev' persistent profile (MySQL-compatible mode)..." -ForegroundColor Yellow
    & $javaExe -jar target\kisan-sathi-backend-1.0.0.jar --spring.profiles.active=dev
}
