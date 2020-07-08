FROM postgres:10.13 

EXPOSE 22
# Timezone, based on your Country/expectation:
ENV TZ=Europe/Budapest

RUN apt-get update&&apt-get install -y openssh-server openssh-client&&apt-get clean&&apt-get autoremove -y&&rm -rf /var/lib/{apt,dpkg,cache,log}
RUN mkdir /var/run/sshd
RUN sed -i 's|^PermitRootLogin.*|PermitRootLogin yes|g' /etc/ssh/sshd_config&&sed -i 's|^#PermitRootLogin.*|PermitRootLogin yes|g' /etc/ssh/sshd_config

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata

RUN cat /dev/null > /root/.bash_history

COPY ./prep4-master.sh /docker-entrypoint-initdb.d/prep4-master.sh
RUN chmod +x /docker-entrypoint-initdb.d/prep4-master.sh
