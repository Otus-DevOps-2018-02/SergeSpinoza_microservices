USER_NAME ?= username 

IMAGE_PATH ?=	./src/ui \
                ./src/comment \
                ./src/post-py \
                ./monitoring/prometheus \
                ./monitoring/alertmanager

all: build push 

.PHONY: build push

define docker_image_name
    ${USER_NAME}/`echo $1 | sed -e 's/\// /g' | awk '{ print $$NF }'`
endef

build:
	@$(foreach i, ${IMAGE_PATH}, echo 'Built image'; \
		cd ${i}; \
		if [ -f ./docker_build.sh ]; then \
            bash docker_build.sh; \
		else \
		    docker build -t $(call docker_image_name,${i}) . ; \
		fi; \
		cd - ; \
	)

push:
	@$(foreach i, $(IMAGE_PATH), \
		docker push $(call docker_image_name,${i}); \
	)

default: all
