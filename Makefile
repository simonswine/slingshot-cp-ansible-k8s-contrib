TYPE=cp
NAME=ansible-k8s-contrib

build:
	docker build -t simonswine/slingshot-${TYPE}-${NAME} .
	docker build -t slingshot/${TYPE}-${NAME} .

