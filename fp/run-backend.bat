@echo off
title Kisan Sathi AgriTech Backend
echo ===================================================================
echo 🌾 Starting Kisan Sathi Spring Boot Backend (Port 8080)
echo ===================================================================

set "JDK_PATH=C:\Users\priyanshu\.jdks\openjdk-26.0.2.1"
if exist "%JDK_PATH%\bin\java.exe" (
    set "JAVA_EXE=%JDK_PATH%\bin\java.exe"
    set "JAVA_HOME=%JDK_PATH%"
    set "PATH=%JDK_PATH%\bin;%PATH%"
) else (
    set "JAVA_EXE=java"
)

cd /d "%~dp0"

if not exist "target\kisan-sathi-backend-1.0.0.jar" (
    echo Building project with Maven...
    call "C:\Program Files\JetBrains\IntelliJ IDEA 2026.2.2\plugins\maven-plugin\lib\maven3\bin\mvn.cmd" package -DskipTests
)

echo [INFO] Launching Spring Boot Backend...
echo 🌐 Website:           http://localhost:8080/
echo 📖 Swagger UI:        http://localhost:8080/swagger-ui.html
echo 🗄️ Database Console:  http://localhost:8080/h2-console
echo.

"%JAVA_EXE%" -jar target\kisan-sathi-backend-1.0.0.jar --spring.profiles.active=dev

pause
