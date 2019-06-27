PROJECT = lambda-delivery
VIRTUAL_ENV = venv
FUNCTION_NAME = delivery
AWS_REGION = eu-west-2
FUNCTION_HANDLER = lambda_handler
LAMBDA_ROLE = <your lambda arn role>
LAMBDA_RUNTIME = python3.6
LAMBDA_TIMEOUT = 3
LAMBDA_MEMORY_SIZE = 3000

# Default commands
install: virtual install_libs
activate: source_env
docker_build: clean_package build_package_tmp copy_lambda docker_install_libs zip
deploy: lambda_update

virtual:
	@echo
		if test ! -d "$(VIRTUAL_ENV)"; then \
			pip3 install virtualenv; \
			virtualenv $(VIRTUAL_ENV) -p /usr/local/bin/python3; \
		fi
	@echo

source_env:
	. ./venv/bin/activate

install_libs:
	pip install -r requirements.txt

docker_install_libs:
	pip install --no-cache-dir --target ./package/tmp/ -r requirements.txt

clean_package:
	rm -rf ./package/*

build_package_tmp:
	mkdir -p ./package/tmp/lib

copy_lambda:
	cp -a ./function/*.py ./package/tmp

zip:
	cd ./package/tmp && zip -r ../../$(PROJECT).zip .

lambda_delete:
	aws lambda delete-function \
		--function_name $(FUNCTION_NAME)

lambda_update:
	aws lambda update-function-code \
		--region $(AWS_REGION) \
		--function-name $(FUNCTION_NAME) \
		--zip-file fileb://$(PROJECT).zip \
		--publish

lambda_update_dry:
	aws lambda update-function-code \
		--region $(AWS_REGION) \
		--function-name $(FUNCTION_NAME) \
		--zip-file fileb://$(PROJECT).zip \
		--dry-run

lambda_create:
	aws lambda create-function \
		--region $(AWS_REGION) \
		--function-name $(FUNCTION_NAME) \
		--zip-file fileb://$(PROJECT).zip \
		--role $(LAMBDA_ROLE) \
		--handler $(PROJECT).$(FUNCTION_HANDLER) \
		--runtime $(LAMBDA_RUNTIME) \
		--timeout $(LAMBDA_TIMEOUT) \
		--memory-size $(LAMBDA_MEMORY_SIZE)