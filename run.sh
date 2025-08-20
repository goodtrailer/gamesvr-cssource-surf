#!/bin/bash

shopt -s globstar

image="ghcr.io/goodtrailer/gamesvr-cssource-surf:2025.708.0"

sudo docker pull "${image}"

for file in private/*; do
    [ -e "${file}" ] || continue
    sudo chmod -R 0777 "${file}"
done

file_mounts=""
cd private

for file in ./addons/**; do
    [ -e "${file}" ] || continue
    if test -d "${file}"; then
        continue
    fi
    file_mounts="${file_mounts} --mount type=bind,src=./private/${file},dst=/app/cstrike/${file} \\
    "
done

for file in ./cfg/**; do
    [ -e "${file}" ] || continue
    if test -d "${file}"; then
        continue
    fi
    file_mounts="${file_mounts} --mount type=bind,src=./private/${file},dst=/app/cstrike/${file} \\
    "
done

for file in ./materials/**; do
    [ -e "${file}" ] || continue
    if test -d "${file}"; then
        continue
    fi
    file_mounts="${file_mounts} --mount type=bind,src=./private/${file},dst=/app/cstrike/${file} \\
    "
done

for file in ./models/**; do
    [ -e "${file}" ] || continue
    if test -d "${file}"; then
        continue
    fi
    file_mounts="${file_mounts} --mount type=bind,src=./private/${file},dst=/app/cstrike/${file} \\
    "
done

for file in ./sound/**; do
    [ -e "${file}" ] || continue
    if test -d "${file}"; then
        continue
    fi
    file_mounts="${file_mounts} --mount type=bind,src=./private/${file},dst=/app/cstrike/${file} \\
    "
done

cd ..

cmd="
sudo docker run -it --rm --net=host \\
    ${file_mounts} \\
    --mount type=bind,src=./private/data,dst=/app/cstrike/addons/sourcemod/data \\
    --mount type=bind,src=./private/maps,dst=/app/cstrike/maps \\
    ${image} \\
    ./srcds_run -console -game cstrike -tickrate 66 +maxplayers 8 +map de_dust
"

echo "${cmd}"
eval "${cmd}"
