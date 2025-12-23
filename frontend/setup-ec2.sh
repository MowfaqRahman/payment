#!/bin/bash

# EC2 Setup Script for Payment App Frontend
# Run this script on your EC2 instance to set up the frontend

set -e

echo "=== Payment App Frontend Setup ==="

# Update system packages
echo "Updating system packages..."
sudo yum update -y

# Install nginx
echo "Installing nginx..."
sudo amazon-linux-extras install nginx1 -y || sudo yum install nginx -y

# Start and enable nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# Create web directory
echo "Creating web directory..."
sudo mkdir -p /var/www/payment-app

# Configure nginx
echo "Configuring nginx..."
sudo tee /etc/nginx/conf.d/payment-app.conf > /dev/null << 'EOF'
server {
    listen 80;
    server_name _;
    
    root /var/www/payment-app;
    index index.html;
    
    # Enable gzip compression
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types text/plain text/css text/xml text/javascript application/x-javascript application/xml+rss application/json;
    
    location / {
        try_files $uri $uri/ /index.html;
        
        # Cache static assets
        location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
            expires 1y;
            add_header Cache-Control "public, immutable";
        }
    }
    
    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
}
EOF

# Test nginx configuration
echo "Testing nginx configuration..."
sudo nginx -t

# Reload nginx
echo "Reloading nginx..."
sudo systemctl reload nginx

# Configure firewall
echo "Configuring firewall..."
sudo firewall-cmd --permanent --add-service=http || true
sudo firewall-cmd --permanent --add-service=https || true
sudo firewall-cmd --reload || true

# Set proper permissions
sudo chown -R nginx:nginx /var/www/payment-app
sudo chmod -R 755 /var/www/payment-app

echo ""
echo "=== Frontend Setup Complete! ==="
echo "Nginx is running and configured"
echo "Web root: /var/www/payment-app"
echo "Nginx status: sudo systemctl status nginx"
echo "View logs: sudo tail -f /var/log/nginx/error.log"
echo ""
echo "Next steps:"
echo "1. Configure your EC2 security group to allow inbound HTTP (port 80) and HTTPS (port 443)"
echo "2. Set up GitHub secrets for CI/CD"
echo "3. Push code to trigger deployment"
echo "4. (Optional) Set up SSL certificate using Let's Encrypt"
