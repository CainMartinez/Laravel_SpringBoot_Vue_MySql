# Etapa 1: Construcción de la aplicación con Gradle
FROM eclipse-temurin:21-jdk-alpine AS builder

# Instalar Gradle
RUN apk add --no-cache gradle

# Establecer el directorio de trabajo
WORKDIR /build

# Copiar los archivos Gradle y descargar dependencias (cachear dependencias)
COPY build.gradle.kts settings.gradle.kts gradlew ./
COPY gradle ./gradle

# Asignar permisos de ejecución al script Gradle Wrapper
RUN chmod +x gradlew

# Descargar dependencias y cachear (sin ejecutar tests)
RUN ./gradlew dependencies --no-daemon

# Copiar el código fuente
COPY src ./src

# Compilar y empaquetar la aplicación
RUN ./gradlew bootJar --no-daemon

# Etapa 2: Crear la imagen final
FROM eclipse-temurin:21-jdk-alpine

# Configurar el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copiar el archivo JAR de la aplicación desde la etapa de construcción
COPY --from=builder /build/build/libs/*.jar app.jar

# Configurar el puerto de la aplicación
EXPOSE 9090

# Ejecutar la aplicación en el puerto 9090
ENTRYPOINT ["sh", "-c", "sleep 10 && java -jar app.jar --server.port=9090"]