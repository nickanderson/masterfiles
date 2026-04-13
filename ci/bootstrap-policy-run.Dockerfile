ARG CFENGINE_VERSION="master"
FROM debian
COPY core /core
COPY masterfiles /masterfiles
RUN apt update && apt upgrade -y
RUN apt install -y pipx sudo make automake autoconf git
RUN pipx install cf-remote
RUN PATH=/root/.local/bin:$PATH cf-remote --version "$CFENGINE_VERSION" install --clients localhost
