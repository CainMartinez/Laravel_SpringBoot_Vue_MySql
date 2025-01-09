# Etapa de construcción
FROM node:20-alpine

# Establece el directorio de trabajo en el contenedor
WORKDIR /app

# Configurar un registro de npm confiable
RUN npm config set registry http://registry.npmjs.org/

# Copiar los archivos package.json y package-lock.json
COPY package*.json ./

# Instalar las dependencias
RUN npm install

# Copiar el resto del proyecto al contenedor
COPY . .

# Exponer el puerto que usa Vite
EXPOSE 8085

# Comando para iniciar la aplicación
CMD ["npm", "run", "dev"]