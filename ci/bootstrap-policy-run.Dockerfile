FROM alpine
RUN apk add bash
COPY core /core
COPY masterfiles /masterfiles
RUN /core/ci/install.sh
