FROM nginx
RUN rm /etc/nginx/nginx.conf /etc/nginx/conf.d/default.conf
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./webserver.conf /etc/nginx/sites-available/icebear.se
COPY ./webserver.conf /etc/nginx/sites-enabled/icebear.se
RUN ln -sf /etc/nginx/sites-available/icebear.se /etc/nginx/sites-enabled/