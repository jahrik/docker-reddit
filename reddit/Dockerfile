FROM ubuntu:14.04
ENV DEBIAN_FRONTEND noninteractive

# copy over the reddit source and our config files
COPY reddit-source /reddit
COPY myreddit.update /reddit/r2/myreddit.update
COPY reddit-source/install/install.cfg /bin/install.cfg

# install dependencies not covered from install_apt.sh
RUN apt-get update
RUN apt-get install -y \
  sudo \
  wget \
  software-properties-common \
  python-software-properties

# Use script as defined in reddit source
RUN adduser root sudo
RUN /bin/bash -c "source /reddit/install/install_apt.sh"

# create our reddit user
RUN useradd --system --shell /bin/nologin reddit
RUN chown -R reddit:reddit /reddit

# from here to the end we run a bunch of reddit scripts... to ya know, set it up
WORKDIR /reddit/r2

RUN make ini

USER reddit
RUN python setup.py build

USER root
RUN python setup.py develop

USER reddit
RUN make

RUN make ini

WORKDIR /reddit/r2
EXPOSE 8081
ENTRYPOINT paster serve --reload myreddit.ini http_port=8081
