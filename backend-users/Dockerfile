FROM php:8.2-apache

# Instalar depend?ncias do sistema
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip

# Limpar cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Instalar extens?es PHP
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Configurar diret?rio de trabalho
WORKDIR /var/www/html

# Copiar arquivos da aplica??o
COPY . /var/www/html

# Instalar depend?ncias do Composer
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Configurar permiss?es
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/storage \
    && chmod -R 755 /var/www/html/bootstrap/cache

# Copiar arquivo de ambiente
RUN cp .env.example .env

# Configurar Apache
RUN a2enmod rewrite
COPY docker-vhost.conf /etc/apache2/sites-available/000-default.conf

# Expor porta
EXPOSE 80

# Comando de inicializa??o
CMD ["apache2-foreground"]
