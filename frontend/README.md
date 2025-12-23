# Payment App Frontend

Flutter web application for the Payment Collection Application.

## Technology Stack

- **Framework**: Flutter
- **Language**: Dart
- **UI**: Material Design
- **State Management**: Provider
- **HTTP Client**: http package

## Local Development

### Prerequisites

- Flutter SDK 3.16.0 or higher
- Dart SDK 3.0.0 or higher
- Chrome or Edge browser (for web development)

### Setup

1. Clone the repository:
```bash
git clone <your-frontend-repo-url>
cd payment-app-frontend
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the development server:
```bash
# For web (Chrome)
flutter run -d chrome --dart-define=API_URL=http://localhost:8000

# For web (Edge)
flutter run -d edge --dart-define=API_URL=http://localhost:8000
```

The app will be available at `http://localhost:xxxx` (port assigned by Flutter)

### Build for Production

```bash
flutter build web --release --dart-define=API_URL=https://your-api-domain.com
```

## Project Structure

```
lib/
├── models/          # Data models
├── screens/         # UI screens
├── widgets/         # Reusable widgets
├── services/        # API services
└── main.dart        # Entry point
```

## Environment Configuration

The app uses compile-time environment variables:

- `API_URL`: Backend API URL (required)

Example:
```bash
flutter run -d chrome --dart-define=API_URL=http://localhost:8000
```

## Deployment to AWS EC2

### Initial Setup

1. **Use the same EC2 instance** as the backend (or create a new one):
   - AMI: Amazon Linux 2 or Ubuntu 20.04+
   - Instance type: t2.micro (or larger)
   - Security group: Allow inbound traffic on ports 22 (SSH), 80 (HTTP), and 443 (HTTPS)

2. **SSH into your EC2 instance**:
```bash
ssh -i your-key.pem ec2-user@your-ec2-ip
```

3. **Run the setup script**:
```bash
# Copy the setup script to EC2
scp -i your-key.pem setup-ec2.sh ec2-user@your-ec2-ip:~

# SSH into EC2 and run the script
ssh -i your-key.pem ec2-user@your-ec2-ip
chmod +x setup-ec2.sh
./setup-ec2.sh
```

### GitHub Repository Setup

1. **Create a new GitHub repository** for the frontend

2. **Add GitHub Secrets** (Settings → Secrets and variables → Actions):
   - `EC2_HOST`: Your EC2 instance public IP or domain
   - `EC2_USERNAME`: SSH username (usually `ec2-user` for Amazon Linux)
   - `EC2_SSH_KEY`: Your private SSH key content
   - `EC2_PORT`: SSH port (default: 22)
   - `API_URL`: Your backend API URL (e.g., `http://your-ec2-ip:8000`)

3. **Push your code**:
```bash
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin <your-frontend-repo-url>
git push -u origin main
```

### CI/CD Pipeline

The GitHub Actions workflow (`.github/workflows/deploy.yml`) will automatically:

1. ✅ Checkout code
2. ✅ Set up Flutter environment
3. ✅ Install dependencies
4. ✅ Run Flutter analyzer
5. ✅ Run tests
6. ✅ Build web app with API_URL
7. ✅ Deploy to EC2 nginx
8. ✅ Verify deployment

Every push to the `main` branch triggers automatic deployment.

## Nginx Configuration on EC2

The setup script configures nginx with:

- Web root: `/var/www/payment-app`
- Gzip compression enabled
- Static asset caching (1 year)
- Security headers
- SPA routing support

### Manage Nginx

```bash
# Check nginx status
sudo systemctl status nginx

# View logs
sudo tail -f /var/log/nginx/error.log
sudo tail -f /var/log/nginx/access.log

# Restart nginx
sudo systemctl restart nginx

# Reload configuration
sudo systemctl reload nginx

# Test configuration
sudo nginx -t
```

## SSL/HTTPS Setup (Recommended)

### Using Let's Encrypt (Free)

1. **Install Certbot**:
```bash
sudo yum install certbot python3-certbot-nginx -y
```

2. **Obtain certificate**:
```bash
sudo certbot --nginx -d your-domain.com
```

3. **Auto-renewal** (already configured by certbot):
```bash
sudo certbot renew --dry-run
```

## API Integration

The frontend communicates with the backend API using the `API_URL` environment variable.

Example API service:
```dart
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiUrl = String.fromEnvironment('API_URL');
  
  Future<List<Customer>> getCustomers() async {
    final response = await http.get(Uri.parse('$apiUrl/customers'));
    // Handle response
  }
}
```

## Production Recommendations

1. **Domain Setup**:
   - Register a domain name
   - Point DNS to your EC2 instance
   - Set up SSL certificate

2. **Performance**:
   - Enable CloudFront CDN for faster global delivery
   - Use S3 for static hosting (alternative to EC2)
   - Implement lazy loading for images

3. **Security**:
   - Enable HTTPS only
   - Set up proper CORS headers
   - Implement CSP (Content Security Policy)

4. **Monitoring**:
   - Set up CloudWatch for nginx logs
   - Monitor page load times
   - Track error rates

## Troubleshooting

### Build fails
```bash
# Clean build cache
flutter clean
flutter pub get
flutter build web --release
```

### API connection issues
- Verify API_URL is correct
- Check CORS configuration on backend
- Ensure EC2 security group allows traffic

### Nginx 404 errors
```bash
# Check if files exist
ls -la /var/www/payment-app

# Check nginx configuration
sudo nginx -t

# Check nginx error logs
sudo tail -f /var/log/nginx/error.log
```

### Deployment fails
- Verify GitHub secrets are set correctly
- Check EC2 SSH key permissions
- Review GitHub Actions logs

## Alternative Deployment Options

### Option 1: AWS S3 + CloudFront
- Lower cost for static hosting
- Better global performance
- Automatic scaling

### Option 2: Netlify/Vercel
- Easiest deployment
- Free tier available
- Automatic HTTPS

### Option 3: Docker Container
- Use the included Dockerfile
- Deploy to ECS or EKS
- Better for microservices architecture

## Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/widget_test.dart
```

## License

[Your License]

## Contributors

[Your Name]
