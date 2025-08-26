build: 
  bluebuild build ./recipes/recipe.yml

iso:
  bluebuild generate-iso --iso-name spawn-os.iso recipe recipes/recipe.yml

podman-test: (build)
  ID=$(podman run -d --rm localhost/spawn-os:latest) &&\
  echo $ID &&\
  podman exec -it $ID bash &&\
  podman container stop $ID
