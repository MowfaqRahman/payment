# LoanPay - Payment Collection App

A premium Flutter & Python (FastAPI) application for managing personal loan payments with automated CI/CD deployment to AWS EC2.

## Tech Stack
- **Frontend**: Flutter (Mobile/Web support)
- **Backend**: Python (FastAPI)
- **Database**: SQLite (development) / PostgreSQL (production)
- **Deployment**: AWS EC2
- **CI/CD**: GitHub Actions

---

## 🚀 Local Setup

### Backend (Python FastAPI)
1. **Navigate to backend folder**:
   ```bash
   cd backend
   ```
2. **Install dependencies**:
   ```bash
   pip install -r requirements.txt
   ```
3. **Run the server**:
   ```bash
   uvicorn main:app --reload --host 0.0.0.0 --port 8000
   ```
   *The API will be available at `http://localhost:8000`.*
   *API documentation: `http://localhost:8000/docs`*
   *Note: On first run, call `POST /seed` to populate sample data.*

### Frontend (Flutter)
1. **Navigate to frontend folder**:
   ```bash
   cd frontend
   ```
2. **Install dependencies**:
   ```bash
   flutter pub get
   ```
3. **Run the app**:
   ```bash
   # For web (Chrome)
   flutter run -d chrome --dart-define=API_URL=http://localhost:8000
   
   # For web (Edge)
   flutter run -d edge --dart-define=API_URL=http://localhost:8000
   ```
   *Replace chrome/edge with your device id for mobile.*

---

## 🏗️ Database Schema

### Customers Table
- `id` (PK)
- `account_number` (String, Unique)
- `issue_date` (Date)
- `interest_rate` (Float)
- `tenure` (Integer)
- `emi_due` (Float)

### Payments Table
- `id` (PK)
- `customer_id` (FK)
- `payment_date` (DateTime)
- `amount` (Float)
- `status` (String)

---

## 🔗 API Endpoints
- `GET /` - Root endpoint
- `GET /health` - Health check
- `GET /customers` - Retrieve all loan details
- `POST /payments` - Submit an EMI payment
- `GET /payments/{account_number}` - Get history for a specific account
- `POST /seed` - Seed sample data

---

## ☁️ CI/CD & Deployment

This project is configured for automated deployment to AWS EC2 using GitHub Actions.

### 📚 Documentation

- **[Complete Deployment Guide](DEPLOYMENT_GUIDE.md)** - Step-by-step instructions for setting up everything
- **[Quick Reference](QUICK_REFERENCE.md)** - Essential commands and configurations
- **[Backend README](backend/README.md)** - Backend-specific setup and deployment
- **[Frontend README](frontend/README.md)** - Frontend-specific setup and deployment

### 🔄 Automated CI/CD Pipeline

Both frontend and backend have separate GitHub Actions workflows that automatically:

**Backend Pipeline** (`.github/workflows/deploy.yml`):
- ✅ Build and test Python application
- ✅ Deploy to EC2 via SSH
- ✅ Restart systemd service
- ✅ Health check verification

**Frontend Pipeline** (`.github/workflows/deploy.yml`):
- ✅ Build Flutter web app with environment variables
- ✅ Deploy to EC2 nginx
- ✅ Configure proper caching and compression
- ✅ Verify deployment

### 📦 Repository Structure

This project should be split into **two separate GitHub repositories**:

1. **Backend Repository** (`payment-app-backend`)
   - Contains: `backend/` folder contents
   - Deploys to: EC2 systemd service (port 8000)

2. **Frontend Repository** (`payment-app-frontend`)
   - Contains: `frontend/` folder contents
   - Deploys to: EC2 nginx (port 80/443)

### 🔐 Required GitHub Secrets

#### Backend Repository Secrets:
- `EC2_HOST` - Your EC2 public IP or domain
- `EC2_USERNAME` - SSH username (ec2-user or ubuntu)
- `EC2_SSH_KEY` - Private SSH key for authentication
- `EC2_PORT` - SSH port (default: 22)

#### Frontend Repository Secrets:
- `EC2_HOST` - Your EC2 public IP or domain
- `EC2_USERNAME` - SSH username (ec2-user or ubuntu)
- `EC2_SSH_KEY` - Private SSH key for authentication
- `EC2_PORT` - SSH port (default: 22)
- `API_URL` - Backend API URL (e.g., http://your-ec2-ip:8000)

### 🚀 Quick Start Deployment

1. **Set up AWS EC2 instance** (see [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md))
2. **Run setup scripts** on EC2:
   ```bash
   # Backend setup
   ./backend/setup-ec2.sh
   
   # Frontend setup
   ./frontend/setup-ec2.sh
   ```
3. **Create GitHub repositories** and configure secrets
4. **Push code** to trigger automatic deployment:
   ```bash
   git push origin main
   ```

### 🔍 Verify Deployment

**Backend**:
- API: `http://your-ec2-ip:8000`
- Health: `http://your-ec2-ip:8000/health`
- Docs: `http://your-ec2-ip:8000/docs`

**Frontend**:
- App: `http://your-ec2-ip`

### 🛠️ Service Management

```bash
# Backend
sudo systemctl status payment-backend
sudo journalctl -u payment-backend -f

# Frontend
sudo systemctl status nginx
sudo tail -f /var/log/nginx/error.log
```

---

## ✨ Features
- **Premium UI**: Modern Material 3 design with Google Fonts typography
- **Micro-animations**: Smooth transitions and hover effects
- **Validation**: Strict input validation for account numbers and amounts
- **History Tracking**: View full payment history for any account
- **Automated Deployment**: CI/CD pipeline with GitHub Actions
- **Environment Configuration**: API URL configured via environment variables
- **Health Monitoring**: Built-in health check endpoints
- **Scalable Architecture**: Separate frontend and backend deployments

---

## 📁 Project Structure

```
APP/
├── backend/                    # Python FastAPI backend
│   ├── .github/
│   │   └── workflows/
│   │       └── deploy.yml     # Backend CI/CD pipeline
│   ├── database.py            # Database configuration
│   ├── main.py                # FastAPI application
│   ├── models.py              # SQLAlchemy models
│   ├── schemas.py             # Pydantic schemas
│   ├── requirements.txt       # Python dependencies
│   ├── Dockerfile             # Backend Docker config
│   ├── setup-ec2.sh          # EC2 setup script
│   ├── .env.example          # Environment variables template
│   └── README.md             # Backend documentation
│
├── frontend/                  # Flutter frontend
│   ├── .github/
│   │   └── workflows/
│   │       └── deploy.yml    # Frontend CI/CD pipeline
│   ├── lib/
│   │   ├── models/           # Data models
│   │   ├── screens/          # UI screens
│   │   └── widgets/          # Reusable widgets
│   ├── pubspec.yaml          # Flutter dependencies
│   ├── Dockerfile            # Frontend Docker config
│   ├── setup-ec2.sh         # EC2 setup script
│   └── README.md            # Frontend documentation
│
├── DEPLOYMENT_GUIDE.md       # Complete deployment guide
├── QUICK_REFERENCE.md        # Quick reference for commands
└── README.md                 # This file
```

---

## 🔒 Security Considerations

- Store sensitive data in environment variables
- Use HTTPS in production (configure SSL with Let's Encrypt)
- Implement proper authentication and authorization
- Configure CORS properly for your domain
- Use strong SSH keys for EC2 access
- Keep dependencies updated

---

## 🚦 Production Recommendations

1. **Database**: Switch from SQLite to PostgreSQL for production
2. **SSL/HTTPS**: Set up SSL certificate using Let's Encrypt
3. **Monitoring**: Configure CloudWatch for logs and metrics
4. **Backups**: Implement automated database backups
5. **Scaling**: Use Application Load Balancer for multiple instances
6. **CDN**: Consider CloudFront for faster global delivery
7. **Rate Limiting**: Implement API rate limiting
8. **Logging**: Set up centralized logging

---

## 📝 License

[Your License]

## 👥 Contributors

[Your Name]

---

## 🆘 Support

For issues and questions:
1. Check the [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md) troubleshooting section
2. Review GitHub Actions logs
3. Check EC2 service logs
4. Verify all secrets are configured correctly

---

**Happy Deploying! 🚀**
