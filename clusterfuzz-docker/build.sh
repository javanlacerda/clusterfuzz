#!/bin/bash -ex
# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


function docker_push {
  docker push $image
  docker push $image:$stamp
}

if [ -z "$1" ]; then
  GIT_HASH=`git rev-parse HEAD | head -c7`
else
  GIT_HASH=$1
fi

echo $IMAGES

read -ra image_array -d $'\n' <<< "$IMAGES"

stamp=$GIT_HASH-$(date -u +%Y%m%d%H%M)
for image_and_path in "${image_array[@]}"; do
  IFS=: read -r image path <<< $image_and_path
  docker build -t $image $path
  docker tag $image $image:$stamp
  docker_push
done

echo Built and pushed images successfully with stamp $stamp
