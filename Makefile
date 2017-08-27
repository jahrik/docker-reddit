VERSION = "0.o.1"

all: build

local: build
	@docker-compose up -d

build: reddit-source
	@docker-compose build

reddit-source:
	@rm -rf reddit/reddit-source
	@git clone https://github.com/reddit/reddit.git reddit/reddit-source
	@cp reddit/reddit-source/r2/example.ini reddit/myreddit.update

.PHONY: all local build
