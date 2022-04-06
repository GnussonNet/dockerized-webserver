FROM nginx:1.21.6-alpine

RUN set -ex && \
# Install packages necessary during the build phase (for all architectures).
    apk add --no-cache \
        bash \
        cargo \
        curl \
        findutils \
        libffi \
        libffi-dev \
        libressl \
        libressl-dev \
        ncurses \
        procps \
        python3 \
        python3-dev \
        sed \
    && \
# Install the latest version of PIP, Setuptools and Wheel.
    curl -L 'https://bootstrap.pypa.io/get-pip.py' | python3 && \
# Install certbot.
    pip3 install certbot certbot-nginx && \
# Remove everything that is no longer necessary.
    apk del \
        cargo \
        curl \
        libffi-dev \
        libressl-dev \
        python3-dev \
    && \
    rm -rf /root/.cache && \
    rm -rf /root/.cargo && \
# Create new directories and set correct permissions.
    mkdir -p /var/www/letsencrypt && \
    chown 82:82 -R /var/www \
    && \
# Make sure there are no surprise config files inside the config folder.
    rm -f /etc/nginx/conf.d/* && \
    rm -f /etc/nginx/nginx.conf

COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./webserver.conf /etc/nginx/sites-available/icebear.se
COPY ./webserver.conf /etc/nginx/sites-enabled/icebear.se
RUN ln -sf /etc/nginx/sites-available/icebear.se /etc/nginx/sites-enabled/