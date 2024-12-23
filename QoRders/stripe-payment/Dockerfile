# Imagen base
FROM node:18

# Directorio de trabajo dentro del contenedor
WORKDIR /app

# Copiar los archivos del proyecto
COPY package*.json ./

# Instalar dependencias
RUN npm install

# Copiar el código fuente
COPY . .

# Exponer el puerto del microservicio
EXPOSE 3000

# Comando para iniciar el servidor
CMD ["npm", "start"]