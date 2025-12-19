# A1 — Docker: “Собери и запусти” (nginx)

## 1) Создать директорию
```
mkdir test-project && cd test-project
```

## 2) Dockerfile (nginx:alpine) + index.html

## 3) Собрать образ
```
docker build -t my-web-app:latest .
```

## 4) Запустить контейнер (8080 -> 80)
```
docker run --rm --name my-web-app -p 8080:80 my-web-app:latest
```

## 5) Проверка в браузере: http://localhost:8080
CLI
```
curl -i http://localhost:8080
HTTP/1.1 200 OK
Server: nginx/1.29.4
Date: Fri, 19 Dec 2025 08:15:54 GMT
Content-Type: text/html
Content-Length: 128
Last-Modified: Fri, 19 Dec 2025 08:03:02 GMT
Connection: keep-alive
ETag: "694506b6-80"
Accept-Ranges: bytes

<!doctype html>
<html>
  <head><meta charset="utf-8"><title>Test</title></head>
  <body><h1>Hello from Dima</h1></body>
</html>
```

## 6) docker-compose.yml
`docker-compose.yml`:
```
services:
  web:
    build: .
    image: my-web-app:latest
    ports:
      - "8080:80"
```

Запуск:
```
docker compose up --build
```

## 7) Вопрос для размышления
Доставлять `index.html` без пересборки можно через bind mount (volume): 
примонтировать файл/папку с хоста в `/usr/share/nginx/html` (в Docker/Compose), 
тогда обновления на хосте сразу видны в контейнере.