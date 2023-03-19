#!/bin/bash
docker run --rm -it \
	-v $(pwd):/src \
  -u `id -u`:`id -g` \
  -v /etc/passwd:/etc/passwd:ro \
  -v /etc/group:/etc/group:ro \
	-p 1313:1313 \
	klakegg/hugo:0.101.0-ubuntu \
	shell
