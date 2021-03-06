#!/usr/bin/env bash

if [ $# -lt 1 ]; then
    echo "You must provide the name of the config as the first argument"
    echo "Usage: ./new-config.sh <job-name>"
    echo "Example: ./new-config.sh mnist"
    exit 1
elif [ -f "examples/local/$1.json" ]; then
    echo "A config with the given name '$1' already exists. Choose a different name"
    exit 1
fi

CONFIG_NAME=$1

mkdir examples/local 2>/dev/null

cat > examples/local/${CONFIG_NAME}.json <<'EOF'
{
  "service": {
    "name": "{{NAME}}",
    "job_url": "{{JOB_URL}}",
    "job_path": "",
    "job_name": "{{JOB_NAME}}",
    "job_context": "",
    "shared_filesystem": "",
    "gcs_key": false,
    "use_tensorboard": false,
    "user": "root",
    "tf_image": "mesosphere/dcos-tensorflow:v1.3",
    "gpu_tf_image": "mesosphere/dcos-tensorflow:v1.3-gpu",
    "virtual_network": false
  },
  "gpu_worker": {
    "count": 0,
    "gpus": 1,
    "cpus": 1,
    "mem": 4096,
    "disk": 4096,
    "disk_type": "ROOT"
  },
  "worker": {
    "count": 1,
    "port": 2222,
    "cpus": 1,
    "mem": 4096,
    "disk": 4096,
    "disk_type": "ROOT"
  },
  "ps": {
    "count": 1,
    "port": 2223,
    "cpus": 1,
    "mem": 4096,
    "disk": 4096,
    "disk_type": "ROOT"
  },
  "tensorboard": {
    "port": 6006,
    "cpus": 1,
    "mem": 4096
  }
}
EOF

sed -i.bak "s/{{NAME}}/${CONFIG_NAME}/g" examples/local/${CONFIG_NAME}.json
rm -f "examples/local/${CONFIG_NAME}.json.bak"
