# Creates configuration files for caffe
DEF_DIR=./definitions/

for DEF in `ls "$DEF_DIR"`
do
    NET_DIR="./NETS/$DEF"
    mkdir -p "$NET_DIR"

    ./buildNetwork.sh <"$DEF_DIR/$DEF" >$NET_DIR/net_train_val.prototxt
    echo $DEF DONE

    cp net_solver.prototxt "$NET_DIR"
done
