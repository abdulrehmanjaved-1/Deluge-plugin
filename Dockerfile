
FROM python:2

COPY build.sh /build.sh

RUN bash /build.sh

ENTRYPOINT deluged && deluge-web --fork && bash
