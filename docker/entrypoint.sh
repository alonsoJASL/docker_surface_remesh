#!/bin/bash --login
set -e
export TERM=xterm

echo "[Cemrg-Surf-Remesh]: Initialising... "
conda activate pylat

echo "[Cemrg-Surf-Remesh]: Initialising... done"

if [ -z "$1" ]
  then
echo "[Cemrg-Surf-Remesh]: No argument supplied. "
    echo "to run, try"
    echo ""
    echo "docker run --rm --volume=/path/to/data:/data cemrg/match-pts:latest msh1 msh2"
    echo "      msh{1,2} names of meshes to match"
    exit 1
fi

echo "python /code/qulati_downsample_pair.py /data $1 $2 -vtk -v"
python /code/qulati_downsample_pair.py /data $1 $2 -vtk -v
