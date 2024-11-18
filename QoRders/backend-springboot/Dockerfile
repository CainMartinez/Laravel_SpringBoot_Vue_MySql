# Etapa 1: Construcción de la aplicación con Maven
FROM eclipse-temurin:21-jdk-alpine AS builder

# Instalar Maven
RUN apk add --no-cache maven

# Establecer el directorio de trabajo
WORKDIR /build

# Copiar el archivo pom.xml y descargar dependencias (cachear dependencias)
COPY pom.xml ./
RUN mvn dependency:go-offline

# Copiar el código fuente
COPY src ./src

# Compilar y empaquetar la aplicación
RUN mvn package -DskipTests

# Etapa 2: Crear la imagen final
FROM eclipse-temurin:21-jdk-alpine

# Configurar el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copiar el archivo JAR de la aplicación desde la etapa de construcción
COPY --from=builder /build/target/QoRders-SB-0.0.1-SNAPSHOT.jar app.jar

# Exponer el puerto que usará la aplicación (debe coincidir con el que configuraste)
EXPOSE 8081

# Ejecutar la aplicación
ENTRYPOINT ["java", "-jar", "app.jar"]