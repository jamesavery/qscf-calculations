#!/bin/bash

inittemplate=$1
allfiles=$*

echo $inittemplate
echo $allfiles

sed -e "s/write_mesh\s*=\s*false/write_mesh = true/" $inittemplate | sed -e "s/endpoints/none/" | \
sed -e "s/output_directory\s*=\s*\".*\"/output_directory = \"init\"/" > init.in

for f in $allfiles; do
    sed -e "s/refinement_strategy\s*=\s*.*/refinement_strategy = none\n    mesh_restart = \"init\/refined-mesh.flags\"/" $f \
    > /tmp/smoer.`basename $f` && mv /tmp/smoer.`basename $f` $f
done