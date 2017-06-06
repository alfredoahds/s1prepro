#!/usr/bin/env bash
#
# Preprocess Sentinel 1 scenes using gpt
#

for scene in "$@"
do
    echo "$scene"
    DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
    GPT=$DIR/gpt # symlinked to bin/gpt of local SNAP install

    scene=$scene
    #mkdir ${scene%.*}
    radiometriconly=${scene%.*}/temp.dim # temporary intermediate
    output="${scene%.*}/$(basename ${scene%.*}).dim"

    $GPT $DIR/graph.xml -e -Sscene=$scene -t $radiometriconly -c 8192M -q 120
    echo Finished radiometric corrections, starting terrain correction...
    $GPT $DIR/graph_tc.xml -e -Sscene=$radiometriconly -t $output -c 8192M -q 120

    rm -rf ${scene%.*}/temp*
done
