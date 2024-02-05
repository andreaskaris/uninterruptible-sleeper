#!/bin/bash -e
# Taken verbatim from: https://chrisdown.name/2024/02/05/reliably-creating-d-state-processes-on-demand.html

src=$(mktemp)
dest=$(mktemp -d)

if (( EUID != 0 )); then
    echo 'You need to be root.' >&2
    exit 1
fi

# fsfreeze needs a supported filesystem. ext4 is
# one, but you can use others, see FILESYSTEM
# SUPPORT in `man 8 fsfreeze'.
fallocate -l 8M -- "$src"
mkfs.ext4 -q -- "$src"

mount -o loop -- "$src" "$dest"

fsfreeze -f -- "$dest"

unfreeze() {
    fsfreeze -u -- "$dest"
    umount -- "$dest"
    rm "$src"
}

noop() {
    echo "noop"
}

trap unfreeze EXIT
trap noop SIGINT
trap noop SIGTERM

mkdir "$dest"/dir &
d_pid=$!

i=0
while true; do
    read -r _ _ state _ < /proc/"$d_pid"/stat
    if [[ $state == D ]]; then
        break
    fi
    if (( ++i % 1000 == 0 )); then
        printf 'Waiting for %d to enter D state...\n' \
            "$d_pid" >&2
    fi
done

printf 'PID %d is now in D state. ' "$d_pid"
# printf 'Press <Enter> to unfreeze and clean up.'
# read
sleep infinity
