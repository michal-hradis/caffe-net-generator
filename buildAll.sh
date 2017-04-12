# Creates configuration files for caffe
DEF_DIR=./definitions/

for DEF in `ls "$DEF_DIR"`
do
    NET_DIR="./NETS/"
    mkdir -p "$NET_DIR"

    ./buildNetwork.sh <"$DEF_DIR/$DEF" >$NET_DIR/${DEF}.prototxt

    #cp -n net_solver.prototxt "$NET_DIR"
done
