build: 
  bluebuild build ./recipes/recipe.yml

iso:
  bluebuild generate-iso --iso-name spawn-os.iso recipe recipes/recipe.yml

vm: (iso)
  qemu-kvm -m 2048 -cpu host -nic user,model=virtio,hostfwd=tcp::2222-:22 \
  -enable-kvm -cdrom ./spawn-os.iso

podman-test: (build)
  ID=$(podman run -d --rm localhost/spawn-os:latest) &&\
  echo $ID &&\
  podman exec -it $ID bash &&\
  podman container stop $ID
