shopt -s globstar

image="ghcr.io/goodtrailer/gamesvr-cssource-surf:2025.630.0"

sudo docker pull "${image}"

for file in private/*; do
    [ -e "${file}" ] || continue
    sudo chmod -R 0777 "${file}"
done

file_mounts=""

for file in private/cfg/**; do
    [ -e "${file}" ] || continue
    file_mounts="${file_mounts} --mount type=bind,src=./${file},dst=/app/cstrike/cfg/$(basename -- ${file}) \\
    "
done

for file in private/configs/**; do
    [ -e "${file}" ] || continue
    file_mounts="${file_mounts} --mount type=bind,src=./${file},dst=/app/cstrike/addons/sourcemod/configs/$(basename -- ${file}) \\
    "
done

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
