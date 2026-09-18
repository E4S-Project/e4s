#!/bin/bash

E4S_VER=26.06

if [[ "$(arch)" == "x86_64" ]]; then
  arch=X86_64
elif [[ "$(arch)" == "aarch64" ]]; then
  arch=AARCH64
elif [[ "$(arch)" == "ppc64le" ]]; then
  arch=PPC64LE
fi

unset ${!UBUNTU*}
unset ${!ROCKY*}

. image-refs.env

CI_REG=registry.e4s.io/ci

declare -a img_vars
for var in $(compgen -A export | grep '.*'"$arch"'.*_IMAGE$'); do
  if [[ "${!var}" != "" ]]; then
    if [[ "${!var}" == "$REGISTRY/" ]]; then
      continue
    fi
    img_vars+=("${var}")
  fi
done

for img_var in "${img_vars[@]}"; do
 #echo "$img_var = ${!img_var}"
 new_img=${!img_var}
 name="${new_img#*/}"
 ci_img=${CI_REG}/${name}
 docker pull $ci_img
 docker tag $ci_img $new_img
 docker push $new_img
done
