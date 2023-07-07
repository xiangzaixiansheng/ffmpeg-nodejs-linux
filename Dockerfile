FROM docker.io/mannymu/ffcreator

RUN cp /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime

CMD ["/bin/bash"]