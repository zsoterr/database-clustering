FROM debian:9.12

EXPOSE 22
# ENV TZ=Europe/Budapest

RUN apt-get update&&apt-get install -y openssh-server openssh-client&&apt-get clean&&apt-get autoremove -y&&rm -rf /var/lib/{apt,dpkg,cache,log}
RUN mkdir /var/run/sshd
RUN sed -i 's|^PermitRootLogin.*|PermitRootLogin yes|g' /etc/ssh/sshd_config&&sed -i 's|^#PermitRootLogin.*|PermitRootLogin yes|g' /etc/ssh/sshd_config
RUN cat /dev/null > /root/.bash_history

# THIS PART WILL BE REPLACED IF YOU PASS SOME OTHER COMMAND TO docker RUN
# CMD while true; do echo "default arg" && sleep 1; done
CMD ["/usr/sbin/sshd", "-D"]
