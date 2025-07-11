@echo off
REM Eduverse Docker Setup Script for Windows
REM This script helps set up the Docker environment for the Eduverse project

echo 🚀 Eduverse Docker Setup Script
echo ================================

REM Check if Docker is installed
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker is not installed. Please install Docker Desktop first.
    pause
    exit /b 1
)

REM Check if Docker Compose is installed
docker-compose --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker Compose is not installed. Please install Docker Compose first.
    pause
    exit /b 1
)

echo ✅ Docker and Docker Compose are installed

REM Check if .env file exists
if not exist .env (
    echo 📝 Creating .env file from template...
    if exist env.example (
        copy env.example .env >nul
        echo ✅ .env file created. Please edit it with your configuration.
        echo    You can use: notepad .env
    ) else (
        echo ❌ env.example file not found. Please create .env file manually.
        pause
        exit /b 1
    )
) else (
    echo ✅ .env file already exists
)

REM Create necessary directories
echo 📁 Creating necessary directories...
if not exist Backend\uploads mkdir Backend\uploads
if not exist nginx\ssl mkdir nginx\ssl
echo ✅ Directories created

REM Check if user wants to build and run
set /p choice="🤔 Do you want to build and start the services now? (y/n): "
if /i "%choice%"=="y" (
    echo 🔨 Building Docker images...
    docker-compose build
    
    echo 🚀 Starting services...
    docker-compose up -d
    
    echo ⏳ Waiting for services to start...
    timeout /t 10 /nobreak >nul
    
    echo 📊 Checking service status...
    docker-compose ps
    
    echo.
    echo 🎉 Setup complete! Your services are running:
    echo    • Login Page: http://localhost:3004
    echo    • Student Platform: http://localhost:3001
    echo    • Professor Dashboard: http://localhost:3002
    echo    • Admin Dashboard: http://localhost:3003
    echo    • Backend API: http://localhost:3000
    echo    • API Documentation: http://localhost:3000/api-docs
    echo.
    echo 📋 Useful commands:
    echo    • View logs: docker-compose logs -f
    echo    • Stop services: docker-compose down
    echo    • Restart services: docker-compose restart
    echo    • Check health: docker-compose ps
) else (
    echo 📋 Manual setup instructions:
    echo    1. Edit .env file with your configuration
    echo    2. Run: docker-compose build
    echo    3. Run: docker-compose up -d
    echo    4. Check status: docker-compose ps
)

echo.
echo 📖 For more information, see DOCKER_README.md
pause 