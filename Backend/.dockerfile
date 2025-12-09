# Stage 1: Build the Spring Boot application
FROM maven:3.9.3-eclipse-temurin-17 AS build

# Set working directory
WORKDIR /app

# Copy only pom.xml first to leverage Docker cache for dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy all source code
COPY . .

# Build the project and skip tests for faster build
RUN mvn clean package -DskipTests

# Stage 2: Create runtime image
FROM eclipse-temurin:17-jre

# Set working directory
WORKDIR /app

# Copy the jar from build stage
COPY --from=build /app/target/*.jar app.jar

# Expose port (Render will provide PORT via environment variable)
EXPOSE 8080

# Dynamic port environment variable
ENV PORT=8080

# Run the Spring Boot app
ENTRYPOINT ["java","-jar","/app/app.jar"]
