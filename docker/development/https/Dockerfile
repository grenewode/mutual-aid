FROM nginx:alpine
COPY https/nginx.conf /etc/nginx/nginx.conf
COPY ssl/*.key /etc/ssl/private/
COPY ssl/*.crt /etc/ssl/certs/
COPY ssl/*.pem /etc/ssl/certs/

