# CI/CD and AWS EC2 Deployment Guide

This guide will walk you through setting up CI/CD pipelines and deploying your Payment Collection App to AWS EC2.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [GitHub Repository Setup](#github-repository-setup)
3. [AWS EC2 Setup](#aws-ec2-setup)
4. [GitHub Actions Configuration](#github-actions-configuration)
5. [Deployment Process](#deployment-process)
6. [Verification](#verification)
7. [Troubleshooting](#troubleshooting)

## Prerequisites

### Required Accounts
- ✅ GitHub account
- ✅ AWS account with EC2 access
- ✅ Domain name (optional but recommended)

### Local Tools
- ✅ Git
- ✅ SSH client
- ✅ AWS CLI (optional)

## GitHub Repository Setup

### Step 1: Create Two Separate Repositories

#### Backend Repository

1. Go to [GitHub](https://github.com) and click "New repository"
2. Name: `payment-app-backend`
3. Description: "Python FastAPI backend for Payment Collection App"
4. Visibility: Private (recommended) or Public
5. Click "Create repository"

#### Frontend Repository

1. Create another new repository
2. Name: `payment-app-frontend`
3. Description: "Flutter web frontend for Payment Collection App"
4. Visibility: Private (recommended) or Public
5. Click "Create repository"

### Step 2: Push Code to Repositories

#### Push Backend Code

```bash
# Navigate to backend directory
cd d:\Projects\APP\backend

# Initialize git (if not already done)
git init

# Add all files
git add .

# Commit
git commit -m "Initial commit: FastAPI backend with CI/CD"

# Add remote (replace with your actual repo URL)
git remote add origin https://github.com/YOUR_USERNAME/payment-app-backend.git

# Push to main branch
git branch -M main
git push -u origin main
```

#### Push Frontend Code

```bash
# Navigate to frontend directory
cd d:\Projects\APP\frontend

# Initialize git (if not already done)
git init

# Add all files
git add .

# Commit
git commit -m "Initial commit: Flutter frontend with CI/CD"

# Add remote (replace with your actual repo URL)
git remote add origin https://github.com/YOUR_USERNAME/payment-app-frontend.git

# Push to main branch
git branch -M main
git push -u origin main
```

## AWS EC2 Setup

### Step 1: Launch EC2 Instance

1. **Sign in to AWS Console** → Navigate to EC2

2. **Click "Launch Instance"**

3. **Configure Instance**:
   - **Name**: `payment-app-server`
   - **AMI**: Amazon Linux 2023 or Ubuntu 22.04 LTS
   - **Instance Type**: `t2.small` (minimum) or `t2.medium` (recommended)
   - **Key Pair**: Create new or select existing
     - Download and save the `.pem` file securely
   - **Network Settings**:
     - Allow SSH (port 22) from your IP
     - Allow HTTP (port 80) from anywhere
     - Allow HTTPS (port 443) from anywhere
     - Allow Custom TCP (port 8000) from anywhere (for API)

4. **Storage**: 20 GB gp3 (minimum)

5. **Click "Launch Instance"**

### Step 2: Connect to EC2 Instance

```bash
# Set proper permissions for key file (Linux/Mac)
chmod 400 your-key.pem

# Connect via SSH
ssh -i your-key.pem ec2-user@YOUR_EC2_PUBLIC_IP

# For Ubuntu, use:
ssh -i your-key.pem ubuntu@YOUR_EC2_PUBLIC_IP
```

### Step 3: Setup Backend on EC2

```bash
# Copy setup script to EC2
scp -i your-key.pem d:\Projects\APP\backend\setup-ec2.sh ec2-user@YOUR_EC2_PUBLIC_IP:~

# SSH into EC2
ssh -i your-key.pem ec2-user@YOUR_EC2_PUBLIC_IP

# Make script executable
chmod +x setup-ec2.sh

# Run setup script
./setup-ec2.sh
```

When prompted, enter your backend repository URL:
```
https://github.com/YOUR_USERNAME/payment-app-backend.git
```

### Step 4: Setup Frontend on EC2

```bash
# Copy setup script to EC2
scp -i your-key.pem d:\Projects\APP\frontend\setup-ec2.sh ec2-user@YOUR_EC2_PUBLIC_IP:~

# SSH into EC2
ssh -i your-key.pem ec2-user@YOUR_EC2_PUBLIC_IP

# Make script executable
chmod +x setup-ec2.sh

# Run setup script
./setup-ec2.sh
```

## GitHub Actions Configuration

### Step 1: Generate SSH Key for GitHub Actions

On your EC2 instance:

```bash
# Generate a new SSH key for GitHub Actions
ssh-keygen -t rsa -b 4096 -f ~/.ssh/github_actions_key -N ""

# Add public key to authorized_keys
cat ~/.ssh/github_actions_key.pub >> ~/.ssh/authorized_keys

# Display private key (copy this for GitHub Secrets)
cat ~/.ssh/github_actions_key
```

**Copy the entire private key output** (including `-----BEGIN RSA PRIVATE KEY-----` and `-----END RSA PRIVATE KEY-----`)

### Step 2: Configure Backend Repository Secrets

1. Go to your **backend repository** on GitHub
2. Navigate to: **Settings** → **Secrets and variables** → **Actions**
3. Click **"New repository secret"** and add the following:

| Secret Name | Value | Example |
|------------|-------|---------|
| `EC2_HOST` | Your EC2 public IP or domain | `54.123.45.67` |
| `EC2_USERNAME` | SSH username | `ec2-user` (Amazon Linux) or `ubuntu` |
| `EC2_SSH_KEY` | Private key from previous step | `-----BEGIN RSA PRIVATE KEY-----...` |
| `EC2_PORT` | SSH port (optional) | `22` |

### Step 3: Configure Frontend Repository Secrets

1. Go to your **frontend repository** on GitHub
2. Navigate to: **Settings** → **Secrets and variables** → **Actions**
3. Click **"New repository secret"** and add the following:

| Secret Name | Value | Example |
|------------|-------|---------|
| `EC2_HOST` | Your EC2 public IP or domain | `54.123.45.67` |
| `EC2_USERNAME` | SSH username | `ec2-user` or `ubuntu` |
| `EC2_SSH_KEY` | Private key from previous step | `-----BEGIN RSA PRIVATE KEY-----...` |
| `EC2_PORT` | SSH port (optional) | `22` |
| `API_URL` | Backend API URL | `http://54.123.45.67:8000` |

## Deployment Process

### Automatic Deployment

Every time you push to the `main` branch, GitHub Actions will automatically:

**Backend Pipeline**:
1. ✅ Checkout code
2. ✅ Set up Python environment
3. ✅ Install dependencies
4. ✅ Run tests
5. ✅ Deploy to EC2
6. ✅ Restart backend service
7. ✅ Perform health check

**Frontend Pipeline**:
1. ✅ Checkout code
2. ✅ Set up Flutter environment
3. ✅ Install dependencies
4. ✅ Run analyzer and tests
5. ✅ Build web app with API_URL
6. ✅ Deploy to EC2 nginx
7. ✅ Verify deployment

### Manual Deployment

You can also trigger deployment manually:

1. Go to repository on GitHub
2. Click **Actions** tab
3. Select the workflow
4. Click **"Run workflow"** → **"Run workflow"**

### Local Testing Before Push

**Backend**:
```bash
cd d:\Projects\APP\backend
python -m uvicorn main:app --reload
# Test at http://localhost:8000
```

**Frontend**:
```bash
cd d:\Projects\APP\frontend
flutter run -d edge --dart-define=API_URL=http://localhost:8000
```

## Verification

### Verify Backend Deployment

1. **Check service status** on EC2:
```bash
ssh -i your-key.pem ec2-user@YOUR_EC2_IP
sudo systemctl status payment-backend
```

2. **Test API endpoints**:
```bash
# Health check
curl http://YOUR_EC2_IP:8000/health

# Root endpoint
curl http://YOUR_EC2_IP:8000/

# API docs
# Visit: http://YOUR_EC2_IP:8000/docs
```

3. **View logs**:
```bash
sudo journalctl -u payment-backend -f
```

### Verify Frontend Deployment

1. **Check nginx status** on EC2:
```bash
ssh -i your-key.pem ec2-user@YOUR_EC2_IP
sudo systemctl status nginx
```

2. **Test web app**:
   - Open browser: `http://YOUR_EC2_IP`
   - Should see your Flutter app

3. **View nginx logs**:
```bash
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log
```

### Verify GitHub Actions

1. Go to repository → **Actions** tab
2. Check latest workflow run
3. All steps should have green checkmarks ✅
4. Review logs if any step fails

## Environment Variables

### Backend Environment Variables

On EC2, edit `/home/ec2-user/payment-app-backend/.env`:

```env
DATABASE_URL=sqlite:///./sql_app.db
API_HOST=0.0.0.0
API_PORT=8000
CORS_ORIGINS=http://YOUR_EC2_IP,https://your-domain.com
ENVIRONMENT=production
```

After editing, restart the service:
```bash
sudo systemctl restart payment-backend
```

### Frontend API URL

The API URL is set during build via GitHub Actions secret `API_URL`.

To change it:
1. Update the secret in GitHub repository settings
2. Push a new commit to trigger rebuild

## Troubleshooting

### Backend Issues

**Service won't start**:
```bash
# Check logs
sudo journalctl -u payment-backend -n 50 --no-pager

# Check if port is in use
sudo netstat -tulpn | grep 8000

# Manually test
cd ~/payment-app-backend
source venv/bin/activate
uvicorn main:app --host 0.0.0.0 --port 8000
```

**Database errors**:
```bash
# Check database file permissions
ls -la ~/payment-app-backend/sql_app.db

# Reset database (WARNING: deletes all data)
rm ~/payment-app-backend/sql_app.db
sudo systemctl restart payment-backend
```

### Frontend Issues

**Nginx 404 errors**:
```bash
# Check if files exist
ls -la /var/www/payment-app/

# Check nginx config
sudo nginx -t

# Reload nginx
sudo systemctl reload nginx
```

**API connection errors**:
- Verify `API_URL` secret is correct
- Check EC2 security group allows port 8000
- Test API directly: `curl http://YOUR_EC2_IP:8000/health`

### GitHub Actions Issues

**SSH connection fails**:
- Verify `EC2_SSH_KEY` secret contains full private key
- Check EC2 security group allows SSH from GitHub IPs
- Verify `EC2_HOST` and `EC2_USERNAME` are correct

**Build fails**:
- Check workflow logs in Actions tab
- Verify all dependencies are in requirements.txt/pubspec.yaml
- Test build locally before pushing

### Security Group Issues

If you can't access the app:

1. Go to EC2 Console → Security Groups
2. Find your instance's security group
3. Edit Inbound Rules:
   - HTTP (80): 0.0.0.0/0
   - HTTPS (443): 0.0.0.0/0
   - Custom TCP (8000): 0.0.0.0/0
   - SSH (22): Your IP

## Production Best Practices

### 1. Use HTTPS

Install SSL certificate using Let's Encrypt:

```bash
sudo yum install certbot python3-certbot-nginx -y
sudo certbot --nginx -d your-domain.com
```

### 2. Use PostgreSQL Instead of SQLite

```bash
# Install PostgreSQL
sudo yum install postgresql postgresql-server -y
sudo postgresql-setup initdb
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Update DATABASE_URL in .env
DATABASE_URL=postgresql://user:password@localhost/payment_db
```

### 3. Set Up Monitoring

- Enable CloudWatch logs
- Set up health check alarms
- Monitor disk space and CPU usage

### 4. Regular Backups

```bash
# Backup database
cp ~/payment-app-backend/sql_app.db ~/backups/sql_app_$(date +%Y%m%d).db

# Automate with cron
crontab -e
# Add: 0 2 * * * cp ~/payment-app-backend/sql_app.db ~/backups/sql_app_$(date +\%Y\%m\%d).db
```

### 5. Use Environment-Specific Branches

- `main` → Production
- `staging` → Staging environment
- `develop` → Development

Update workflows to deploy different branches to different environments.

## Next Steps

1. ✅ Set up domain name and SSL
2. ✅ Configure database backups
3. ✅ Set up monitoring and alerts
4. ✅ Implement authentication
5. ✅ Add rate limiting
6. ✅ Set up staging environment
7. ✅ Configure CDN (CloudFront)
8. ✅ Implement logging and analytics

## Support

If you encounter issues:

1. Check the troubleshooting section above
2. Review GitHub Actions logs
3. Check EC2 service logs
4. Verify all secrets are configured correctly

## Summary

You now have:

- ✅ Two separate GitHub repositories (frontend & backend)
- ✅ Automated CI/CD pipelines with GitHub Actions
- ✅ Backend deployed on AWS EC2 with systemd service
- ✅ Frontend deployed on AWS EC2 with nginx
- ✅ Environment variable configuration for API URL
- ✅ Health checks and monitoring
- ✅ Automatic deployment on every push to main

Happy deploying! 🚀
