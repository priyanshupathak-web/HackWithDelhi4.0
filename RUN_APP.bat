@echo off
title Kisan Sathi AgriTech - Full Stack Application
echo ===================================================================
echo 🌾 Starting Kisan Sathi Full-Stack Web Application
echo ===================================================================

:: 1. Set JDK 26 path explicitly to prevent Java 8 conflict
set "JDK_PATH=C:\Users\priyanshu\.jdks\openjdk-26.0.2.1"

if exist "%JDK_PATH%\bin\java.exe" (
    set "JAVA_EXE=%JDK_PATH%\bin\java.exe"
    set "JAVA_HOME=%JDK_PATH%"
    set "PATH=%JDK_PATH%\bin;%PATH%"
) else (
    set "JAVA_EXE=java"
)

:: 2. Determine directory paths
cd /d "%~dp0"
set "JAR_PATH=%~dp0fp\target\kisan-sathi-backend-1.0.0.jar"

if not exist "%JAR_PATH%" (
    echo [INFO] Building backend JAR...
    call "C:\Program Files\JetBrains\IntelliJ IDEA 2026.2.2\plugins\maven-plugin\lib\maven3\bin\mvn.cmd" -f "%~dp0fp\pom.xml" package -DskipTests
)

echo.
echo [INFO] Starting Spring Boot Server on Port 8080...
echo [INFO] Serving Full Frontend + REST APIs + Database
echo.
echo ===================================================================
echo 🌐 Website URL:       http://localhost:8080/
echo 🌾 Advisory System:   http://localhost:8080/ksp/index.html
echo 📖 API Documentation: http://localhost:8080/swagger-ui.html
echo 🗄️ Database Console:  http://localhost:8080/h2-console
echo ===================================================================
echo.
echo Opening browser in 4 seconds...
start "" timeout /t 4 /nobreak >nul & start http://localhost:8080/

"%JAVA_EXE%" -jar "%JAR_PATH%" --spring.profiles.active=dev

pause
