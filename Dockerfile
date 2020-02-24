FROM nginx:alpine
ARG server_name=localhost
ARG host_port=10443
ARG cert_file=cert

COPY nginx-default.conf.tmpl /etc/nginx/conf.d/default.conf
RUN sed -i -e "s/\${nginx_server_name}/$server_name/g" /etc/nginx/conf.d/default.conf
RUN sed -i -e "s/\${nginx_host_port}/$host_port/g" /etc/nginx/conf.d/default.conf
COPY $cert_file.crt /etc/nginx/cert.crt
COPY $cert_file.key /etc/nginx/cert.key
