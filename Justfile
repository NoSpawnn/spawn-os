build: 
  bluebuild build ./recipes/recipe.yml

iso:
  bluebuild generate-iso --iso-name spawn-os.iso recipe recipes/recipe.yml

validate:
  bluebuild validate recipes/recipe.yml

vm: (iso)
  qemu-kvm -m 2048 -cpu host -nic user,model=virtio,hostfwd=tcp::2222-:22 \
  -enable-kvm -cdrom ./spawn-os.iso


IGNITION_DIR := "./ignition"
ignite: # Badass right?
  podman run --interactive --rm --security-opt label=disable \
    --volume "{{ IGNITION_DIR }}:/pwd" --workdir /pwd quay.io/coreos/butane:release \
    --pretty --strict --files-dir . ignition.yml > {{ IGNITION_DIR }}/ignition.ign

podman-test: (build)
  ID=$(podman run -d --rm localhost/spawn-os:latest) &&\
  echo $ID &&\
  podman exec -it $ID bash &&\
  podman container stop $ID
