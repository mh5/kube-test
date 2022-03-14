
This repo kubernetizes [this tutorial](https://semaphoreci.com/community/tutorials/dockerizing-a-ruby-on-rails-application).

### Prerequesites

The steps documented here were tested against a local, single-node minikube
cluster backed by Docker.

### Walkthrough

	# do this step every time you open a new terminal
	# it makes sure raw docker commands are using the same docker socket as minikube
	eval "$(minikube docker-env)"

	# build the drkiq image. this is the only custom image we need in the project
	cd kube-test/rails-app
	docker build --tag drkiq:latest .
	cd ../

	# load the image into the local registry of the minikube cluster
	# in a real deployment, we would need to push the image into a proper registry
	minikube image load drkiq:latest

	# to create the required kubernetes secrets, customize the secrets-example.yml file and apply it
	cp secrets-example.yml secrets.yml
	kubectl apply -f secrets.yml

	# to create the required kubernetes configuration, customize the config-example.yml file and apply it
	cp config-example.yml config.yml
	kubectl apply -f config.yml

	# apply the remaining yaml files
	kubectl apply -f volumes.yml

	kubectl apply -f postgres.yml
	# sanity check: ssh into minikube and ensure that you're able to telnet on pg-service:5432

	kubectl apply -f redis.yml
	# sanity check: ssh into minikube and ensure that you're able to telnet on redis-service:6379

	kubectl apply -f drkiq.yml
	# sanity check 1: bash into the pod and curl localhost:8010, you should see an error about the domain not being whitelisted
	# sanity check 2: make sure you can telnet into pg-service and the redis-service from the pod
	# sanity check 3: check the pod logs and ensure that they are error free

	kubectl apply -f sidekiq.yml
	# sanity check: the pod logs should show the output of a recurring scheduled task

	kubectl apply -f reverse-proxy.yml
	# sanity check: bash into the pod and curl drkiq:8010, you should see some HTML with the header "Pages#home"

	# expose the nginx service outside the minikube cluster
	minikube service nginx

	# get the nginx service URL and open it in a browser. if things go fine, you
	# should see a "Pages#home" body and the content should be 
	minikube service nginx --url

