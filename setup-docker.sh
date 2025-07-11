#!/bin/bash

# Eduverse Docker Setup Script
# This script helps set up the Docker environment for the Eduverse project

set -e

echo "🚀 Eduverse Docker Setup Script"
echo "================================"

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

echo "✅ Docker and Docker Compose are installed"

# Check if .env file exists
if [ ! -f .env ]; then
    echo "📝 Creating .env file from template..."
    if [ -f env.example ]; then
        cp env.example .env
        echo "✅ .env file created. Please edit it with your configuration."
        echo "   You can use: nano .env"
    else
        echo "❌ env.example file not found. Please create .env file manually."
        exit 1
    fi
else
    echo "✅ .env file already exists"
fi

# Create necessary directories
echo "📁 Creating necessary directories..."
mkdir -p Backend/uploads
mkdir -p nginx/ssl
echo "✅ Directories created"

# Check if user wants to build and run
read -p "🤔 Do you want to build and start the services now? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🔨 Building Docker images..."
    docker-compose build
    
    echo "🚀 Starting services..."
    docker-compose up -d
    
    echo "⏳ Waiting for services to start..."
    sleep 10
    
    echo "📊 Checking service status..."
    docker-compose ps
    
    echo ""
    echo "🎉 Setup complete! Your services are running:"
    echo "   • Login Page: http://localhost:3004"
    echo "   • Student Platform: http://localhost:3001"
    echo "   • Professor Dashboard: http://localhost:3002"
    echo "   • Admin Dashboard: http://localhost:3003"
    echo "   • Backend API: http://localhost:3000"
    echo "   • API Documentation: http://localhost:3000/api-docs"
    echo ""
    echo "📋 Useful commands:"
    echo "   • View logs: docker-compose logs -f"
    echo "   • Stop services: docker-compose down"
    echo "   • Restart services: docker-compose restart"
    echo "   • Check health: docker-compose ps"
else
    echo "📋 Manual setup instructions:"
    echo "   1. Edit .env file with your configuration"
    echo "   2. Run: docker-compose build"
    echo "   3. Run: docker-compose up -d"
    echo "   4. Check status: docker-compose ps"
fi

echo ""
echo "📖 For more information, see DOCKER_README.md" 