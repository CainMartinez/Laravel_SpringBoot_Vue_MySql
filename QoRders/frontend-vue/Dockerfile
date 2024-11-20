# Etapa de construcción
FROM node:20-alpine
WORKDIR /app

# Copiar archivos necesarios para instalar dependencias
COPY package*.json ./

# Instalar dependencias
RUN npm install

# Copiar el resto del proyecto
COPY . .

# Exponer el puerto 8085
EXPOSE 8085

# Comando para iniciar la aplicación en el puerto especificado
CMD ["npm", "run", "dev"]