IGNITION_DIR := "./ignition"
OUT_DIR := "./build"

build: 
  bluebuild build ./recipes/recipe.yml

build-iso:
  bluebuild generate-iso --iso-name spawn-os.iso -o {{ OUT_DIR }}/iso recipe recipes/recipe.yml

download-coreos:
  podman run --security-opt label=disable --pull=always --rm -v .:/data -w /data \
    quay.io/coreos/coreos-installer:release download -s stable -p metal -f iso

validate:
  bluebuild validate recipes/recipe.yml

ignite: # Badass right?
  podman run --interactive --rm --security-opt label=disable \
    --volume "{{ IGNITION_DIR }}:/pwd" --workdir /pwd quay.io/coreos/butane:release \
    --pretty --strict --files-dir . ignition.yml > {{ OUT_DIR }}/ignition.ign
