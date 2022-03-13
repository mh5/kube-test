docker run -it \
    -v $PWD:/opt/app \
    rails-toolbox rails new --skip-bundle drkiq

rm -rf drkiq/.git
