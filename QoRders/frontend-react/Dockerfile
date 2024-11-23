# 1. Utilizar una imagen base
FROM node:18-alpine

# 2. Crear y configurar el directorio de trabajo
WORKDIR /app

# 3. Copiar los archivos de configuración y dependencias
COPY package.json package-lock.json ./

# 4. Cambiar permisos y propietario para el directorio de trabajo
RUN chown -R node:node /app

# 5. Cambiar al usuario 'node'
USER node

# 6. Instalar las dependencias de npm (como usuario 'node')
RUN npm install

# 7. Copiar el resto del código de la aplicación al contenedor (ya bajo usuario 'node')
COPY --chown=node:node . .

# 8. Exponer el puerto donde correrá la aplicación
EXPOSE 8086

# 9. Comando por defecto para iniciar la aplicación en modo desarrollo
CMD ["npm", "run", "start-docker"]
