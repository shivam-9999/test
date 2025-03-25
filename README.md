# Django REST API Deployment on Azure

This project demonstrates the deployment of a Django REST API application to Azure App Service.

## Project Structure
```
demoproject/
├── manage.py
├── requirements.txt
├── demoproject/
│   ├── settings.py
│   ├── urls.py
│   └── wsgi.py
├── api/
│   ├── models.py
│   ├── views.py
│   ├── urls.py
│   └── serializers.py
├── startup.sh
├── gunicorn.conf.py
├── .gitignore
└── .github/
    └── workflows/
        └── azure-deploy.yml
```

## Local Development Setup

1. Create and activate virtual environment:
```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

2. Install dependencies:
```bash
pip install -r requirements.txt
```

3. Run migrations:
```bash
python manage.py migrate
```

4. Create superuser:
```bash
python manage.py createsuperuser
```

5. Run development server:
```bash
python manage.py runserver
```

## Deployment Options

### Option 1: Manual Deployment
Follow the manual deployment process using Azure CLI commands.

### Option 2: GitHub Actions (Recommended)
Automated deployment using GitHub Actions workflow.

#### Setup GitHub Actions:

1. Get your Azure publish profile:
   - Go to Azure Portal
   - Navigate to your Web App
   - Click on "Get publish profile"
   - Download the file

2. Add the publish profile to GitHub Secrets:
   - Go to your GitHub repository
   - Navigate to Settings > Secrets and variables > Actions
   - Click "New repository secret"
   - Name: `AZURE_WEBAPP_PUBLISH_PROFILE`
   - Value: Paste the content of your publish profile file

3. Push your code to GitHub:
```bash
git add .
git commit -m "Add GitHub Actions workflow"
git push origin main
```

The workflow will automatically:
- Build your application
- Run tests
- Collect static files
- Apply database migrations
- Deploy to Azure

## Azure Deployment Workflow

### 1. Azure Setup
- Create Resource Group
- Create App Service Plan
- Create Web App
- Configure Python version
- Set environment variables

### 2. Environment Variables in Azure
Required environment variables:
```
- DJANGO_SECRET_KEY
- DJANGO_DEBUG
- DJANGO_ALLOWED_HOSTS
- WEBSITES_PORT
```

### 3. Deployment Process
1. Create ZIP file of project
2. Exclude unnecessary files (venv, .git, etc.)
3. Deploy to Azure using ZIP deployment
4. Azure builds the application
5. Application starts using startup.sh

### 4. Startup Process
When the application starts on Azure:
1. Azure reads startup.sh
2. Creates virtual environment
3. Installs requirements
4. Collects static files
5. Applies database migrations
6. Starts Gunicorn server

### 5. Database Handling
- Using SQLite for development
- For production:
  - Set up Azure Database for PostgreSQL
  - Update DATABASES setting in settings.py
  - Add database credentials to Azure environment variables

### 6. Static Files
- Collected using `python manage.py collectstatic`
- Served by WhiteNoise in production
- Configured in settings.py

### 7. Security Considerations
- DEBUG = False in production
- Secret key in environment variables
- Allowed hosts configured
- CORS settings if needed

### 8. Monitoring and Logging
- Azure App Service logs
- Django logging configuration
- Application insights (optional)

### 9. Scaling Considerations
- App Service Plan tier
- Number of instances
- Database scaling
- Static file serving

### 10. Maintenance
- Regular updates to requirements.txt
- Database backups
- Log rotation
- Monitoring application health

### 11. Deployment Best Practices
- Use environment variables for sensitive data
- Keep dependencies updated
- Regular security updates
- Proper error handling
- Monitoring and alerting

### 12. Troubleshooting
- Check Azure logs
- Monitor application logs
- Test locally before deployment
- Verify environment variables
- Check database connections

## API Endpoints

The API provides the following endpoints:

1. Root API endpoint: `/api/`
2. Notes endpoints:
   - List/Create: `/api/notes/`
   - Detail/Update/Delete: `/api/notes/{id}/`
3. Hello World endpoint: `/api/hello/`

## Manual Deployment Commands

1. Create deployment package:
```bash
zip -r app.zip . -x "venv/*" "*.git*" "LogFiles/*" "deployments/*" "azure_logs.zip"
```

2. Deploy to Azure:
```bash
az webapp deploy --resource-group demoproject-rg --name demo-azure-app-2024 --src-path app.zip --restart true
```

3. Check deployment logs:
```bash
az webapp log deployment show --resource-group demoproject-rg --name demo-azure-app-2024
```

4. View application logs:
```bash
az webapp log tail --resource-group demoproject-rg --name demo-azure-app-2024
```

## Environment Variables

Add these environment variables in Azure App Service:

```bash
az webapp config appsettings set --resource-group demoproject-rg --name demo-azure-app-2024 --settings DJANGO_SECRET_KEY="your-secret-key" DJANGO_DEBUG="False" DJANGO_ALLOWED_HOSTS=".azurewebsites.net"
```

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.