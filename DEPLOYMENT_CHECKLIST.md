# Pre-Deployment Checklist

Use this checklist to ensure everything is ready before deploying.

## ☁️ AWS Setup

### EC2 Instance
- [ ] EC2 instance launched (t2.small or larger)
- [ ] AMI: Amazon Linux 2023 or Ubuntu 22.04
- [ ] Instance is running
- [ ] Public IP address noted: `_________________`
- [ ] SSH key pair downloaded and saved securely
- [ ] SSH key permissions set (chmod 400 on Linux/Mac)

### Security Group Configuration
- [ ] Port 22 (SSH) - Allow from your IP
- [ ] Port 80 (HTTP) - Allow from 0.0.0.0/0
- [ ] Port 443 (HTTPS) - Allow from 0.0.0.0/0
- [ ] Port 8000 (API) - Allow from 0.0.0.0/0

### EC2 Connection
- [ ] Can SSH into EC2: `ssh -i your-key.pem ec2-user@YOUR_EC2_IP`
- [ ] EC2 instance has internet access
- [ ] Sufficient disk space (20GB minimum)

---

## 🐙 GitHub Setup

### Backend Repository
- [ ] Repository created: `payment-app-backend`
- [ ] Repository URL: `_________________`
- [ ] Repository is private/public (your choice)
- [ ] You have admin access

### Frontend Repository
- [ ] Repository created: `payment-app-frontend`
- [ ] Repository URL: `_________________`
- [ ] Repository is private/public (your choice)
- [ ] You have admin access

---

## 🔐 GitHub Secrets Configuration

### Backend Repository Secrets
Navigate to: `Settings → Secrets and variables → Actions`

- [ ] `EC2_HOST` = `_________________`
- [ ] `EC2_USERNAME` = `ec2-user` or `ubuntu`
- [ ] `EC2_SSH_KEY` = (full private key pasted)
- [ ] `EC2_PORT` = `22`

### Frontend Repository Secrets
Navigate to: `Settings → Secrets and variables → Actions`

- [ ] `EC2_HOST` = `_________________`
- [ ] `EC2_USERNAME` = `ec2-user` or `ubuntu`
- [ ] `EC2_SSH_KEY` = (full private key pasted)
- [ ] `EC2_PORT` = `22`
- [ ] `API_URL` = `http://YOUR_EC2_IP:8000`

---

## 🖥️ EC2 Setup Scripts

### Backend Setup
- [ ] Copied `setup-ec2.sh` to EC2
- [ ] Made script executable: `chmod +x setup-ec2.sh`
- [ ] Ran setup script: `./setup-ec2.sh`
- [ ] Entered backend repository URL when prompted
- [ ] Edited `.env` file with correct values
- [ ] Backend service is running: `sudo systemctl status payment-backend`
- [ ] Health check works: `curl http://localhost:8000/health`

### Frontend Setup
- [ ] Copied `setup-ec2.sh` to EC2
- [ ] Made script executable: `chmod +x setup-ec2.sh`
- [ ] Ran setup script: `./setup-ec2.sh`
- [ ] Nginx is running: `sudo systemctl status nginx`
- [ ] Can access nginx: `curl http://localhost`

---

## 📦 Code Repository Setup

### Backend Code
- [ ] Navigated to backend directory
- [ ] Initialized git: `git init`
- [ ] Added all files: `git add .`
- [ ] Committed: `git commit -m "Initial commit"`
- [ ] Added remote: `git remote add origin <backend-repo-url>`
- [ ] Pushed to main: `git push -u origin main`
- [ ] GitHub Actions workflow triggered
- [ ] Workflow completed successfully (check Actions tab)

### Frontend Code
- [ ] Navigated to frontend directory
- [ ] Initialized git: `git init`
- [ ] Added all files: `git add .`
- [ ] Committed: `git commit -m "Initial commit"`
- [ ] Added remote: `git remote add origin <frontend-repo-url>`
- [ ] Pushed to main: `git push -u origin main`
- [ ] GitHub Actions workflow triggered
- [ ] Workflow completed successfully (check Actions tab)

---

## ✅ Verification

### Backend Verification
- [ ] Service status: `sudo systemctl status payment-backend` shows "active (running)"
- [ ] Health check: `curl http://YOUR_EC2_IP:8000/health` returns `{"status":"healthy"}`
- [ ] API root: `curl http://YOUR_EC2_IP:8000/` returns success
- [ ] API docs accessible: `http://YOUR_EC2_IP:8000/docs`
- [ ] Can view logs: `sudo journalctl -u payment-backend -f`

### Frontend Verification
- [ ] Nginx status: `sudo systemctl status nginx` shows "active (running)"
- [ ] Web app accessible: `http://YOUR_EC2_IP` loads in browser
- [ ] Frontend can connect to backend API
- [ ] No console errors in browser
- [ ] Can view nginx logs: `sudo tail -f /var/log/nginx/error.log`

### GitHub Actions Verification
- [ ] Backend workflow shows green checkmark ✅
- [ ] Frontend workflow shows green checkmark ✅
- [ ] No failed steps in workflow logs
- [ ] Deployment completed successfully

---

## 🔄 Test Deployment

### Make a Test Change

**Backend**:
```bash
cd d:\Projects\APP\backend
# Make a small change to main.py (e.g., update a message)
git add .
git commit -m "Test deployment"
git push origin main
# Watch GitHub Actions deploy automatically
```

**Frontend**:
```bash
cd d:\Projects\APP\frontend
# Make a small change to a screen
git add .
git commit -m "Test deployment"
git push origin main
# Watch GitHub Actions deploy automatically
```

- [ ] Backend test deployment successful
- [ ] Frontend test deployment successful
- [ ] Changes reflected on EC2

---

## 🎯 Post-Deployment Tasks

### Optional but Recommended
- [ ] Set up domain name
- [ ] Configure SSL/HTTPS with Let's Encrypt
- [ ] Switch to PostgreSQL database
- [ ] Set up CloudWatch monitoring
- [ ] Configure automated backups
- [ ] Set up staging environment
- [ ] Implement rate limiting
- [ ] Add authentication/authorization

---

## 📝 Important Information

**Record these for future reference:**

- EC2 Public IP: `_________________`
- Backend Repository: `_________________`
- Frontend Repository: `_________________`
- Backend URL: `http://YOUR_EC2_IP:8000`
- Frontend URL: `http://YOUR_EC2_IP`
- API Docs: `http://YOUR_EC2_IP:8000/docs`
- SSH Command: `ssh -i your-key.pem ec2-user@YOUR_EC2_IP`

---

## 🆘 Troubleshooting

If something doesn't work:

1. **Check GitHub Actions logs** - Look for red X marks
2. **Check EC2 service status** - `sudo systemctl status payment-backend`
3. **Check logs** - `sudo journalctl -u payment-backend -f`
4. **Verify secrets** - Ensure all GitHub secrets are set correctly
5. **Check security group** - Ensure all required ports are open
6. **Review documentation** - See DEPLOYMENT_GUIDE.md

---

## ✨ Success Criteria

You're successfully deployed when:

- ✅ Both GitHub repositories are created and code is pushed
- ✅ EC2 instance is running and accessible
- ✅ Backend service is running on port 8000
- ✅ Frontend is served by nginx on port 80
- ✅ GitHub Actions workflows complete successfully
- ✅ Health checks pass
- ✅ You can access the app in your browser
- ✅ Frontend can communicate with backend API

---

**Once all items are checked, you're ready to go! 🚀**

For detailed instructions, see:
- `DEPLOYMENT_GUIDE.md` - Complete guide
- `QUICK_REFERENCE.md` - Quick commands
- `SETUP_SUMMARY.md` - Overview of all files
