FROM postgres:10.13 

EXPOSE 22
#Timezone, based on your Country/expectation:
ENV TZ=Europe/Budapest

RUN apt-get update&&apt-get install -y openssh-server openssh-client iputils-ping net-tools gosu&&apt-get clean&&apt-get autoremove -y&&rm -rf /var/lib/{apt,dpkg,cache,log}
RUN mkdir /var/run/sshd
RUN sed -i 's|^PermitRootLogin.*|PermitRootLogin yes|g' /etc/ssh/sshd_config&&sed -i 's|^#PermitRootLogin.*|PermitRootLogin yes|g' /etc/ssh/sshd_config

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata

RUN cat /dev/null > /root/.bash_history

COPY ./prep4-slave.sh /usr/local/bin/prep4-slave.sh
RUN chmod +x /usr/local/bin/prep4-slave.sh

ENTRYPOINT ["/usr/local/bin/prep4-slave.sh"]
CMD ["gosu","postgres","postgres"]
