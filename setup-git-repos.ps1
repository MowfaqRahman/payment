# Git Repository Initialization Script
# This script helps you push your code to separate GitHub repositories

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Payment App - Git Repository Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Get repository URLs
Write-Host "Please enter your GitHub repository URLs:" -ForegroundColor Yellow
Write-Host ""
$backendRepo = Read-Host "Backend repository URL (e.g., https://github.com/username/payment-app-backend.git)"
$frontendRepo = Read-Host "Frontend repository URL (e.g., https://github.com/username/payment-app-frontend.git)"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Setting up Backend Repository" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# Backend setup
Set-Location "d:\Projects\APP\backend"

# Check if git is already initialized
if (Test-Path ".git") {
    Write-Host "Git already initialized in backend directory" -ForegroundColor Yellow
    $reinit = Read-Host "Do you want to reinitialize? (y/n)"
    if ($reinit -eq "y") {
        Remove-Item -Recurse -Force ".git"
        git init
    }
} else {
    git init
}

# Add all files
Write-Host "Adding files..." -ForegroundColor Green
git add .

# Commit
Write-Host "Creating initial commit..." -ForegroundColor Green
git commit -m "Initial commit: FastAPI backend with CI/CD"

# Add remote
Write-Host "Adding remote repository..." -ForegroundColor Green
git remote remove origin 2>$null  # Remove if exists
git remote add origin $backendRepo

# Create main branch and push
Write-Host "Pushing to GitHub..." -ForegroundColor Green
git branch -M main
git push -u origin main

Write-Host ""
Write-Host "✅ Backend repository setup complete!" -ForegroundColor Green
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Setting up Frontend Repository" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# Frontend setup
Set-Location "d:\Projects\APP\frontend"

# Check if git is already initialized
if (Test-Path ".git") {
    Write-Host "Git already initialized in frontend directory" -ForegroundColor Yellow
    $reinit = Read-Host "Do you want to reinitialize? (y/n)"
    if ($reinit -eq "y") {
        Remove-Item -Recurse -Force ".git"
        git init
    }
} else {
    git init
}

# Add all files
Write-Host "Adding files..." -ForegroundColor Green
git add .

# Commit
Write-Host "Creating initial commit..." -ForegroundColor Green
git commit -m "Initial commit: Flutter frontend with CI/CD"

# Add remote
Write-Host "Adding remote repository..." -ForegroundColor Green
git remote remove origin 2>$null  # Remove if exists
git remote add origin $frontendRepo

# Create main branch and push
Write-Host "Pushing to GitHub..." -ForegroundColor Green
git branch -M main
git push -u origin main

Write-Host ""
Write-Host "✅ Frontend repository setup complete!" -ForegroundColor Green
Write-Host ""

# Return to root directory
Set-Location "d:\Projects\APP"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Setup Complete!" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "1. Go to your GitHub repositories and check the Actions tab" -ForegroundColor White
Write-Host "2. Configure GitHub Secrets (see QUICK_REFERENCE.md)" -ForegroundColor White
Write-Host "3. Set up your AWS EC2 instance (see DEPLOYMENT_GUIDE.md)" -ForegroundColor White
Write-Host "4. Run the setup scripts on EC2" -ForegroundColor White
Write-Host ""
Write-Host "Backend Repository: $backendRepo" -ForegroundColor Cyan
Write-Host "Frontend Repository: $frontendRepo" -ForegroundColor Cyan
Write-Host ""
Write-Host "For detailed instructions, see:" -ForegroundColor Yellow
Write-Host "- DEPLOYMENT_GUIDE.md" -ForegroundColor White
Write-Host "- DEPLOYMENT_CHECKLIST.md" -ForegroundColor White
Write-Host "- QUICK_REFERENCE.md" -ForegroundColor White
Write-Host ""
