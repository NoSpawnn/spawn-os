IGNITION_DIR := "./ignition"
OUT_DIR := "./build"

build: 
  bluebuild build ./recipes/recipe.yml

build-iso:
  mkdir -p {{ OUT_DIR }}/iso
  bluebuild generate-iso --iso-name spawn-os.iso -o {{ OUT_DIR }}/iso recipe recipes/recipe.yml

download-coreos:
  mkdir -p {{ OUT_DIR }}/iso
  podman run --security-opt label=disable --pull=always --rm -v ./build/iso:/data -w /data \
    quay.io/coreos/coreos-installer:release download -s stable -p metal -f iso

validate:
  bluebuild validate recipes/recipe.yml

ignite: # Badass right?
  mkdir -p {{ OUT_DIR }}
  podman run --interactive --rm --security-opt label=disable \
    --volume "{{ IGNITION_DIR }}:/pwd" --workdir /pwd quay.io/coreos/butane:release \
    --pretty --strict --files-dir . ignition.yml > {{ OUT_DIR }}/ignition.ign

serve-ignition port="8080": (ignite)
  podman run --rm -it --name ignition-server -p {{ port }}:80 -v "./build":/usr/local/apache2/htdocs/ httpd:2.4

vm disk_size="128G":
  mkdir -p {{ OUT_DIR }}/vm

  # if [ ! -f {{ OUT_DIR }}/vm/disk.qcow2 ]; then qemu-img create -f qcow2 {{ OUT_DIR }}/vm/disk.qcow2 {{ disk_size }} fi

  qemu-kvm -m 2048 -nic user,model=virtio,hostfwd=tcp::2222-:22 \
    -cdrom ./build/iso/coreos.iso -drive file=build/vm/disk.qcow2,media=disk,if=virtio
