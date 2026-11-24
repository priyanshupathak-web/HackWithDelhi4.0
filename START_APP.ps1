# ===================================================================
# Kisan Sathi Full-Stack Application Launcher (PowerShell)
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
$jarPath = Join-Path $PSScriptRoot "fp\target\kisan-sathi-backend-1.0.0.jar"

Write-Host "===================================================================" -ForegroundColor Green
Write-Host "🌾 Starting Kisan Sathi Full-Stack Web Application" -ForegroundColor Green
Write-Host "===================================================================" -ForegroundColor Green

if (-not (Test-Path $jarPath)) {
    Write-Host "Building project JAR with Maven..." -ForegroundColor Yellow
    & "C:\Program Files\JetBrains\IntelliJ IDEA 2026.2.2\plugins\maven-plugin\lib\maven3\bin\mvn.cmd" -f "$PSScriptRoot\fp\pom.xml" package -DskipTests
}

Write-Host "🌐 Website URL:       http://localhost:8080/" -ForegroundColor Cyan
Write-Host "🌾 Advisory System:   http://localhost:8080/ksp/index.html" -ForegroundColor Cyan
Write-Host "📖 API Documentation: http://localhost:8080/swagger-ui.html" -ForegroundColor Cyan
Write-Host "🗄️ Database Console:  http://localhost:8080/h2-console" -ForegroundColor Cyan
Write-Host "===================================================================" -ForegroundColor Green

# Open default browser after 3 seconds in background job
Start-Job -ScriptBlock {
    Start-Sleep -Seconds 3
    Start-Process "http://localhost:8080/"
} | Out-Null

# Run Spring Boot Application
& $javaExe -jar $jarPath --spring.profiles.active=dev
