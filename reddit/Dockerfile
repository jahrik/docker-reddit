FROM ubuntu:14.04
ENV DEBIAN_FRONTEND noninteractive

# https://github.com/reddit/reddit/wiki/Install-guide
# https://github.com/reddit/reddit/wiki/Dependencies

# Base deps
RUN apt-get update
RUN apt-get install -y \
  sudo \
  wget \
  software-properties-common \
  python-software-properties \
  postgresql \
  postgresql-client \
  python-pip \
  python-setuptools \
  python-dev \
  libmemcached-dev \
  libpq-dev \
  libxml2-dev \
  libxslt1-dev \
  python-imaging \
  git-core \
  gcc \
  optipng \
  jpegoptim \
  make \
  gettext

# Reddit ppa deps
RUN add-apt-repository ppa:reddit/ppa
RUN apt-get update
RUN apt-get install -y \
  nodejs \
  node-less \
  node-uglify

# Node deps
# Attempt at fixing:
# Error: Cannot find module 'less'
# Error: Cannot find module 'uglify-js'
RUN npm install less uglify-js

# get the reddit source and put the install config and the correct spot
COPY reddit-source /reddit

# Use script as defined in reddit source
COPY reddit-source/install/install.cfg /bin/install.cfg
RUN adduser root sudo
RUN /bin/bash -c "source /reddit/install/install_apt.sh"

# create our reddit user
RUN useradd --system --shell /bin/nologin reddit
RUN chown -R reddit:reddit /reddit

# from here to the end we run a bunch of reddit scripts... to ya know, set it up
WORKDIR /reddit/r2

# override the example config with our updated config
COPY myreddit.update /reddit/r2/myreddit.update
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

USER root
COPY ./initialize.sh /bin/initialize.sh
ENTRYPOINT ["/bin/initialize.sh"]
