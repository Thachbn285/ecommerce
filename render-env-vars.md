# Render Environment Variables Configuration

## Required Environment Variables for Production Deployment

### Database Configuration
```
DATABASE_URL=jdbc:postgresql://dpg-d2g5kjggjchc73anedq0-a.singapore-postgres.render.com:5432/ecommerce_db_s7e1?sslmode=require
DATABASE_USERNAME=ecommerce_db_s7e1_user
DATABASE_PASSWORD=vvj4QlC8PQN2iUw6FiqP9E35TEl8EuQI
```

### Application Configuration
```
SPRING_PROFILES_ACTIVE=production
PORT=8080
```

### JWT Configuration
```
JWT_SECRET=mySecretKeymySecretKeymySecretKeymySecretKeymySecretKey
```

### File Upload Configuration
```
FILE_UPLOAD_DIR=/app/uploads/
```

### Java Configuration
```
JAVA_OPTS=-Xmx1g -Xms512m -Dspring.profiles.active=production
```

## How to Set Environment Variables in Render

1. Go to your Render Dashboard
2. Select your Web Service
3. Go to "Environment" tab
4. Add each variable above as Key-Value pairs
5. Click "Save Changes"

## Alternative: Using Render Blueprint (render.yaml)

Create a `render.yaml` file in your repository root:

```yaml
services:
  - type: web
    name: ecommerce-api
    env: docker
    dockerfilePath: ./Dockerfile
    envVars:
      - key: SPRING_PROFILES_ACTIVE
        value: production
      - key: DATABASE_URL
        value: jdbc:postgresql://dpg-d2g5kjggjchc73anedq0-a.singapore-postgres.render.com:5432/ecommerce_db_s7e1?sslmode=require
      - key: DATABASE_USERNAME
        value: ecommerce_db_s7e1_user
      - key: DATABASE_PASSWORD
        value: vvj4QlC8PQN2iUw6FiqP9E35TEl8EuQI
      - key: JWT_SECRET
        value: mySecretKeymySecretKeymySecretKeymySecretKeymySecretKey
      - key: FILE_UPLOAD_DIR
        value: /app/uploads/
      - key: JAVA_OPTS
        value: -Xmx1g -Xms512m -Dspring.profiles.active=production
```

## Verification

After deployment, check:
1. Application logs show: "The following profiles are active: production"
2. Health check endpoint: `https://your-app.onrender.com/actuator/health`
3. Database connection successful
4. APIs working correctly
