# Dockerfile for Spring Boot Ecommerce Application
FROM openjdk:17-jdk-slim

# Set working directory
WORKDIR /app

# Install Maven and curl
RUN apt-get update && \
    apt-get install -y maven curl && \
    rm -rf /var/lib/apt/lists/*

# Copy project files
COPY . .

# Build the application
RUN mvn clean package -DskipTests

# Move the JAR file to app directory
RUN mv target/*.jar app.jar

# Create logs directory
RUN mkdir -p logs

# Expose port
EXPOSE 8080

# Environment variables
ENV SPRING_PROFILES_ACTIVE=production
ENV JAVA_OPTS="-Xmx1g -Xms512m"

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:8080/actuator/health || exit 1

# Run the application
CMD ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]