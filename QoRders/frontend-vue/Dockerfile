# Etapa de construcción
FROM node:20-alpine
WORKDIR /app

# Configurar un registro de npm confiable
RUN npm config set registry http://registry.npmjs.org/

# Limpiar la caché de npm para evitar problemas
RUN npm cache clean --force

# Copiar archivos necesarios para instalar dependencias
COPY package*.json ./

# Copiar el resto del proyecto
COPY . .

# Exponer el puerto 8085
EXPOSE 8085

# Comando para iniciar la aplicación en el puerto especificado
CMD ["npm", "run", "dev"]