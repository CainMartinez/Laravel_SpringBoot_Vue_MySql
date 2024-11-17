# Usar una imagen base de OpenJDK para ejecutar Spring Boot
FROM openjdk:21-jdk-slim

# Configurar el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copiar el archivo JAR de la aplicación en el contenedor
COPY target/QoRders-SB-0.0.1-SNAPSHOT.jar app.jar

# Exponer el puerto que usará la aplicación (debe coincidir con el que configuraste)
EXPOSE 8081

# Ejecutar la aplicación
ENTRYPOINT ["java", "-jar", "app.jar"]