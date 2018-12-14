FROM ubuntu:16.04

WORKDIR /app

# Install required packages and remove the apt packages cache when done.

RUN apt-get update && apt-get install -y \
	gcc \
	libc-dev \
	# linux-headers \
	git \
	mc \
	python \
	python-dev \
	python-setuptools \
	nginx \
	supervisor \
	# sqlite3 \
  && rm -rf /var/lib/apt/lists/*

# add (the rest of) our code
COPY . /app

RUN easy_install pip

# # install uwsgi now because it takes a little while
RUN pip install uwsgi

# COPY app/requirements.txt /app/app/
# RUN pip install -r /app/requirements.txt

# setup log files
# RUN ln -sf /dev/stdout /var/log/nginx/access.log \
#     && ln -sf /dev/stderr /var/log/nginx/error.log

# setup and copy config files
RUN echo "Test message;" >> test
COPY ./test /etc/nginx/conf.d/
COPY ./nginx.conf /etc/nginx/conf.d/
COPY ./uwsgi.ini /etc/uwsgi/
COPY ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# set ENV variables and expose ports
# ENV UWSGI_INI /app/uwsgi.ini
# Enable unlimited filesize uploads (restore nginx default by setting to 1m)
# ENV NGINX_MAX_UPLOAD 0
# Enable changing default Nginx port
# ENV LISTEN_PORT 80
EXPOSE 80

# CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
CMD ["supervisord", "-n"]