# Est?gio de build
FROM node:20-alpine AS builder

WORKDIR /app

# Copiar arquivos de depend?ncias
COPY package*.json ./

# Instalar depend?ncias
RUN npm ci

# Copiar c?digo fonte
COPY . .

# Build da aplica??o
RUN npm run build

# Est?gio de produ??o
FROM nginx:alpine

# Copiar arquivos buildados
COPY --from=builder /app/dist/kubernetes-demo /usr/share/nginx/html

# Copiar configura??o customizada do nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expor porta
EXPOSE 80

# Comando de inicializa??o
CMD ["nginx", "-g", "daemon off;"]
