FROM python:3.6

LABEL maintainer="jakezp <jakezp@gmail.com>"

ENV DEBIAN_FRONTEND noninteractive

# create directories
RUN mkdir -p /etc/pai && mkdir -p /opt/pai && mkdir -p /opt/log

# clone pai (dev)
RUN git clone https://github.com/jpbarraca/pai.git /opt/pai_tmp && git checkout dev && cp -R /opt/pai_tmp /opt/pai && rm -rf /opt/pai_tmp

# install python library
RUN pip install -r requirements.txt

# add user paradox to image
RUN groupadd -r paradox && useradd -r -g paradox paradox && chown -R paradox /opt/pai && chown -R paradox /opt/log && chown -R paradox /etc/pai

# Add config files
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD run.sh /run.sh

# Set permissions
RUN chmod +x /run.sh

# process run as paradox user
USER paradox

# conf file from host
VOLUME ["/etc/pai/pai.conf", "/opt/log/"]

WORKDIR /opt/pai
CMD ["/run.sh"]
