build: 
  bluebuild build ./recipes/recipe.yml

podman-test: (build)
  ID=$(podman run -d --rm localhost/spawn-os:latest) &&\
  echo $ID &&\
  podman exec -it $ID bash &&\
  podman container stop $ID
