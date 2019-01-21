FROM python:3.6.6-alpine3.8

RUN apk -U add ca-certificates python python-dev py-pip build-base && \
pip install locustio pyzmq && \
apk del python-dev && \
rm -r /var/cache/apk/* && \
mkdir /locust

WORKDIR /locust

ADD . /locust
RUN test -f requirements.txt && pip install -r requirements.txt; exit 0
RUN ["chmod", "+x", "docker_start.sh"]

EXPOSE 8089 5557 5558

CMD ["./docker_start.sh"]
