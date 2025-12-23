# Quick Reference: GitHub Secrets Setup

## Backend Repository Secrets

Navigate to: `https://github.com/YOUR_USERNAME/payment-app-backend/settings/secrets/actions`

Click "New repository secret" for each:

```
Name: EC2_HOST
Value: 54.123.45.67 (your EC2 public IP)

Name: EC2_USERNAME
Value: ec2-user (or ubuntu)

Name: EC2_SSH_KEY
Value: -----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEA...
(paste entire private key)
...
-----END RSA PRIVATE KEY-----

Name: EC2_PORT
Value: 22
```

## Frontend Repository Secrets

Navigate to: `https://github.com/YOUR_USERNAME/payment-app-frontend/settings/secrets/actions`

Click "New repository secret" for each:

```
Name: EC2_HOST
Value: 54.123.45.67 (your EC2 public IP)

Name: EC2_USERNAME
Value: ec2-user (or ubuntu)

Name: EC2_SSH_KEY
Value: -----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEA...
(paste entire private key)
...
-----END RSA PRIVATE KEY-----

Name: EC2_PORT
Value: 22

Name: API_URL
Value: http://54.123.45.67:8000 (your backend URL)
```

## Quick Commands

### Generate SSH Key on EC2
```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/github_actions_key -N ""
cat ~/.ssh/github_actions_key.pub >> ~/.ssh/authorized_keys
cat ~/.ssh/github_actions_key  # Copy this for GitHub secrets
```

### Push to GitHub
```bash
# Backend
cd d:\Projects\APP\backend
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/YOUR_USERNAME/payment-app-backend.git
git branch -M main
git push -u origin main

# Frontend
cd d:\Projects\APP\frontend
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/YOUR_USERNAME/payment-app-frontend.git
git branch -M main
git push -u origin main
```

### Check Deployment Status
```bash
# Backend service
ssh -i your-key.pem ec2-user@YOUR_EC2_IP
sudo systemctl status payment-backend
sudo journalctl -u payment-backend -f

# Frontend nginx
sudo systemctl status nginx
sudo tail -f /var/log/nginx/error.log

# Test endpoints
curl http://YOUR_EC2_IP:8000/health
curl http://YOUR_EC2_IP
```

## EC2 Security Group Rules

| Type | Protocol | Port | Source |
|------|----------|------|--------|
| SSH | TCP | 22 | Your IP |
| HTTP | TCP | 80 | 0.0.0.0/0 |
| HTTPS | TCP | 443 | 0.0.0.0/0 |
| Custom TCP | TCP | 8000 | 0.0.0.0/0 |

## Troubleshooting Checklist

- [ ] GitHub secrets are configured correctly
- [ ] EC2 security group allows required ports
- [ ] SSH key has correct permissions (chmod 400)
- [ ] Backend service is running (systemctl status payment-backend)
- [ ] Nginx is running (systemctl status nginx)
- [ ] API_URL in frontend matches backend URL
- [ ] CORS is configured in backend
- [ ] GitHub Actions workflow completed successfully

## URLs to Remember

- Backend API: `http://YOUR_EC2_IP:8000`
- API Docs: `http://YOUR_EC2_IP:8000/docs`
- Frontend: `http://YOUR_EC2_IP`
- Backend Repo: `https://github.com/YOUR_USERNAME/payment-app-backend`
- Frontend Repo: `https://github.com/YOUR_USERNAME/payment-app-frontend`
