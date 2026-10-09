# 1. Базовый образ
FROM nginx:alpine

# 2. Копируем конфиг nginx, чтобы он корректно обрабатывал пути (опционально)
# Копируем наш HTML файл в директорию nginx
COPY src/index.html /usr/share/nginx/html/index.html

# 3. Экспонируем порт
EXPOSE 80

# 4. Команда запуска
CMD ["nginx", "-g", "daemon off;"]