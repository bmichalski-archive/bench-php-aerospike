#!/bin/bash
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

docker run \
--link aerospike:aerospike \
-v $DIR/src:/root/bench-aerospike/src \
-it \
bmichalski/bench-aerospike \
bash #-c "su - r"
