# Eduverse Docker Setup

This document provides instructions for running the Eduverse e-learning platform using Docker and Docker Compose.

## 🏗️ Architecture

The application consists of the following services:

- **MongoDB**: Database server
- **Backend**: Node.js/Express.js API server
- **Student Platform**: React frontend for students
- **Professor Dashboard**: React frontend for professors
- **Admin Dashboard**: React frontend for administrators
- **Login Page**: React frontend for authentication
- **Nginx Proxy**: Reverse proxy for production (optional)

## 📋 Prerequisites

- Docker (version 20.10 or higher)
- Docker Compose (version 2.0 or higher)
- At least 4GB of available RAM
- At least 10GB of available disk space

## 🚀 Quick Start

### 1. Clone and Setup

```bash
# Clone the repository
git clone <your-repo-url>
cd Eduverse

# Copy environment file
cp env.example .env

# Edit environment variables
nano .env
```

### 2. Configure Environment Variables

Edit the `.env` file with your configuration:

```bash
# MongoDB Configuration
MONGO_ROOT_USERNAME=admin
MONGO_ROOT_PASSWORD=your-secure-password
MONGO_DATABASE=eduverse

# JWT Configuration
JWT_SECRET=your-super-secret-jwt-key-change-this-in-production

# Cloudinary Configuration (for file uploads)
CLOUDINARY_CLOUD_NAME=your-cloudinary-cloud-name
CLOUDINARY_API_KEY=your-cloudinary-api-key
CLOUDINARY_API_SECRET=your-cloudinary-api-secret

# Stripe Configuration (for payments)
STRIPE_SECRET_KEY=your-stripe-secret-key
STRIPE_WEBHOOK_SECRET=your-stripe-webhook-secret

# Server Configuration
SERVER_PORT=3000
NODE_ENV=production

# Frontend API URLs
REACT_APP_API_URL=http://localhost:3000/api
```

### 3. Build and Run

```bash
# Build all services
docker-compose build

# Start all services
docker-compose up -d

# View logs
docker-compose logs -f
```

### 4. Access Applications

Once all services are running, you can access:

- **Login Page**: http://localhost:3004
- **Student Platform**: http://localhost:3001
- **Professor Dashboard**: http://localhost:3002
- **Admin Dashboard**: http://localhost:3003
- **Backend API**: http://localhost:3000
- **API Documentation**: http://localhost:3000/api-docs
- **MongoDB**: localhost:27017

## 🔧 Development Mode

For development, you can run services individually:

```bash
# Run only backend for development
docker-compose up backend mongodb

# Run specific frontend for development
docker-compose up student-platform backend mongodb
```

## 🏭 Production Setup

### 1. Enable Nginx Proxy

```bash
# Start with nginx proxy
docker-compose --profile production up -d
```

### 2. SSL Configuration

For HTTPS in production:

1. Place your SSL certificates in `./nginx/ssl/`:
   - `cert.pem` - SSL certificate
   - `key.pem` - Private key

2. The nginx proxy will automatically serve HTTPS on port 443

### 3. Production URLs

With nginx proxy enabled:

- **Login Page**: http://localhost/ (or https://localhost/)
- **Student Platform**: http://localhost/student/
- **Professor Dashboard**: http://localhost/professor/
- **Admin Dashboard**: http://localhost/admin/
- **API**: http://localhost/api/

## 📊 Monitoring and Logs

### View Service Logs

```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f backend
docker-compose logs -f student-platform
```

### Health Checks

```bash
# Check service health
docker-compose ps

# Health check endpoint
curl http://localhost/health
```

### Database Access

```bash
# Access MongoDB shell
docker-compose exec mongodb mongosh -u admin -p your-password

# Backup database
docker-compose exec mongodb mongodump --out /backup
```

## 🛠️ Maintenance

### Update Services

```bash
# Pull latest images and rebuild
docker-compose pull
docker-compose build --no-cache
docker-compose up -d
```

### Backup and Restore

```bash
# Backup MongoDB
docker-compose exec mongodb mongodump --out /backup/$(date +%Y%m%d)

# Restore MongoDB
docker-compose exec mongodb mongorestore /backup/20231201/
```

### Clean Up

```bash
# Stop and remove containers
docker-compose down

# Remove volumes (WARNING: This will delete all data)
docker-compose down -v

# Remove images
docker-compose down --rmi all
```

## 🔍 Troubleshooting

### Common Issues

1. **Port Already in Use**
   ```bash
   # Check what's using the port
   netstat -tulpn | grep :3000
   
   # Kill the process or change ports in docker-compose.yml
   ```

2. **MongoDB Connection Issues**
   ```bash
   # Check MongoDB logs
   docker-compose logs mongodb
   
   # Restart MongoDB
   docker-compose restart mongodb
   ```

3. **Frontend Build Failures**
   ```bash
   # Rebuild specific service
   docker-compose build --no-cache student-platform
   ```

4. **Permission Issues**
   ```bash
   # Fix file permissions
   sudo chown -R $USER:$USER .
   ```

### Performance Optimization

1. **Increase Docker Resources**
   - Allocate more RAM and CPU in Docker Desktop settings

2. **Database Optimization**
   ```bash
   # Create indexes (already done in init script)
   docker-compose exec mongodb mongosh eduverse --eval "db.users.createIndex({email: 1})"
   ```

3. **Caching**
   - Nginx is configured with static asset caching
   - Consider adding Redis for session storage

## 📁 File Structure

```
Eduverse/
├── docker-compose.yml          # Main orchestration file
├── env.example                 # Environment variables template
├── .env                        # Environment variables (create this)
├── DOCKER_README.md           # This file
├── Backend/
│   ├── Dockerfile             # Backend container configuration
│   ├── data/
│   │   └── init-mongo.js      # MongoDB initialization script
│   └── ...
├── Frontend/
│   ├── Student-platform/
│   │   ├── Dockerfile         # Student platform container
│   │   ├── nginx.conf         # Nginx configuration
│   │   └── ...
│   ├── Professor-Dashboard/
│   │   ├── Dockerfile         # Professor dashboard container
│   │   ├── nginx.conf         # Nginx configuration
│   │   └── ...
│   ├── Admin_dashboard/
│   │   ├── Dockerfile         # Admin dashboard container
│   │   ├── nginx.conf         # Nginx configuration
│   │   └── ...
│   └── Login Page/
│       ├── Dockerfile         # Login page container
│       ├── nginx.conf         # Nginx configuration
│       └── ...
└── nginx/
    └── nginx.conf             # Main nginx proxy configuration
```

## 🔐 Security Considerations

1. **Environment Variables**: Never commit `.env` files to version control
2. **Database Passwords**: Use strong, unique passwords
3. **JWT Secrets**: Generate cryptographically secure secrets
4. **SSL/TLS**: Always use HTTPS in production
5. **Firewall**: Configure firewall rules appropriately
6. **Updates**: Keep Docker images and dependencies updated

## 📞 Support

For issues and questions:

1. Check the troubleshooting section above
2. Review Docker and service logs
3. Ensure all prerequisites are met
4. Verify environment variables are correctly set

## 🚀 Next Steps

After successful deployment:

1. Set up monitoring and alerting
2. Configure automated backups
3. Set up CI/CD pipelines
4. Implement load balancing for high availability
5. Configure CDN for static assets
6. Set up logging aggregation 