#!/bin/bash
#
# This script builds the snippets docker image
# Runs the ansible parser script to generate ansible-data.json
# Runs the code snippets generator to generate codesnippets.json
# Outputs the ansible version to ansible_version.txt
#
# Check-in the ansible_version.txt along with the snippets when updating them
#

if [ ! -f parse_ansible.py ] || [ ! -f generate_codesnippets.ts ]; then
    echo "Cannot find parse_ansible.py or generate_codesnippets.ts!" 1>&2
    echo "Run this script in the 'scripts' folder!" 1>&2
    exit 1
fi

if [ ! -f ../docker/Dockerfile_snippets_latest ]; then
    echo "Cannot find '../docker/Dockerfile_snippets_latest'!" 1>&2
    exit 2
fi

parent_dir=$(dirname $PWD)
docker_image_name="ansible_snippet_generator"
docker_container_name="generate_ansible_snippet"

docker container rm -f $docker_container_name || true
docker build --tag $docker_image_name -f ../docker/Dockerfile_snippets_latest ../docker

docker run --rm --name $docker_container_name -i -v $parent_dir:/ansible -w /ansible/scripts $docker_image_name /bin/bash -s <<EOF
    python parse_ansible.py || exit 11
    ts-node generate_codesnippets.ts || exit 12

    version=\$(ansible --version 2>/dev/null)
    version=\$(echo \$version | sed 's/ansible \([0-9.]*\) .*/\1/')
    echo "Ansible version: \$version"
    echo \$version > ../snippets/ansible_version.txt
EOF