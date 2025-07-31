# Docker Todo App

A full-stack todo application built with FastAPI backend, vanilla JavaScript frontend, and PostgreSQL database, all containerized with Docker.

## Features

- ✅ Create, read, update, and delete todo items
- 📅 Due date support for todos
- 🎨 Modern, responsive UI
- 📊 Real-time system monitoring
- 🗄️ Database structure inspection
- 🔍 Comprehensive logging system
- 🐳 Fully containerized with Docker

## Quick Start

### Prerequisites

- Docker
- Docker Compose

### Environment Setup

1. **Copy the environment template:**
   ```bash
   cp env.example .env
   ```

2. **Edit the `.env` file** (optional - defaults are provided):
   ```bash
   # Database Configuration
   DB_HOST=db
   DB_PORT=5432
   DB_NAME=tododb
   DB_USER=todouser
   DB_PASSWORD=your_secure_password_here
   
   # PostgreSQL Configuration
   POSTGRES_USER=todouser
   POSTGRES_PASSWORD=your_secure_password_here
   POSTGRES_DB=tododb
   
   # Application Configuration
   PORT=5000
   TZ=Asia/Seoul
   ```

### Running the Application

1. **Start all services:**
   ```bash
   docker-compose up -d
   ```

2. **Access the application:**
   - Frontend: http://localhost:8080
   - Backend API: http://localhost:5000
   - API Documentation: http://localhost:5000/docs

3. **Stop the application:**
   ```bash
   docker-compose down
   ```

## Project Structure

```
docker_session/
├── frontend/          # Vanilla JavaScript frontend
├── backend/           # FastAPI backend
├── docker-compose.yml # Multi-container orchestration
├── .env              # Environment variables (create from env.example)
├── env.example       # Environment variables template
└── README.md         # This file
```

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `DB_HOST` | `db` | Database host |
| `DB_PORT` | `5432` | Database port |
| `DB_NAME` | `tododb` | Database name |
| `DB_USER` | `todouser` | Database user |
| `DB_PASSWORD` | `todopass` | Database password |
| `POSTGRES_USER` | `todouser` | PostgreSQL user |
| `POSTGRES_PASSWORD` | `todopass` | PostgreSQL password |
| `POSTGRES_DB` | `tododb` | PostgreSQL database |
| `PORT` | `5000` | Backend API port |
| `TZ` | `Asia/Seoul` | Timezone |

## Security Notes

- The `.env` file is excluded from version control
- Default passwords are for development only
- For production, use strong, unique passwords
- Consider using Docker secrets for sensitive data

## Development

### Backend Development

The backend is built with FastAPI and provides:
- RESTful API endpoints
- PostgreSQL database integration
- Comprehensive logging
- Health checks
- CORS support

### Frontend Development

The frontend is built with vanilla JavaScript and provides:
- Modern, responsive UI
- Real-time todo management
- System monitoring panels
- Local storage for logs

## Monitoring

The application includes built-in monitoring features:
- **System Logs**: View HTTP request logs
- **Database Info**: Inspect database structure and data
- **Statistics**: Todo completion statistics

Access monitoring panels from the frontend interface.

## Troubleshooting

### Common Issues

1. **Port conflicts**: Ensure ports 8080, 5000, and 5432 are available
2. **Database connection**: Wait for the database to be healthy before accessing the app
3. **Environment variables**: Make sure `.env` file exists and is properly configured

### Logs

View application logs:
```bash
# All services
docker-compose logs

# Specific service
docker-compose logs backend
docker-compose logs frontend
docker-compose logs db
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is open source and available under the MIT License.