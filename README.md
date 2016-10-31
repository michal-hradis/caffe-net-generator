# caffe-net-generator
Very simple bash scripts that generate caffe net prototxt files from concise text files.
It uses pure text substitution on prototxt templates.

## Basics
Networks definitions are in ./definitions/.
Running buildAll.sh creates prototxt file for each definition file in ./NETS/.
Net building block templates (layers) are in ./L/.
The scripts do not check for correctness or any compatibility with caffe.
Nets can be debugged by reading them in caffe.

## Definition files
Net definitions are simple text files where each line can specify one network layer.

The exhaustive list of rules are:
* If line starts with \#, ignore it as a comment. Empty lines are ignored as well.
* First word on a line has to correspond to a layer template file in ./L/
* The rest of the line can contain key-value pairs separated by whitespace.
* Locations in the template matching \_\_KEY\_\_ are replaced with value.
* If a key-value par is not specified, default value from the template is used (\_\_KEY\_\_:value). If no default value is specified, the \_\_KEY\_\_ is just removed.

Example of dropout layer template.
```
layer {
  name:  "__TOP___drop"
  type: "Dropout"
  bottom: "__TOP__"
  top: "__TOP__"
  dropout_param {
    dropout_ratio: __RATIO:0.5__
  }
}
```


This should create net similar to standard Cafe net:
```
# this should create a net equivalent to the exemplar caffe net for imagenet
DATA TOP data    DIM1 32 DIM2 3 DIM3 227 DIM4 227
DATA TOP labels  DIM1 32 DIM2 1 DIM3 1 DIM4 1
CONV TOP conv1 IN data   K_SIZE 11 CHANNELS 96 STRIDE 4 B_LR 2
RELU TOP conv1
POOL TOP pool1 IN conv1
LRN  TOP norm1 IN pool1

CONV TOP conv2 IN norm1   K_SIZE 5 CHANNELS 256 PAD 2 GROUP 2 B_LR 2
RELU TOP conv2
POOL TOP pool2 IN conv2
LRN  TOP norm2 in pool2

CONV TOP conv3 IN norm2   K_SIZE 3 CHANNELS 384 PAD 1 B_LR 2
RELU TOP conv3
CONV TOP conv4 IN conv3   K_SIZE 3 CHANNELS 384 PAD 1 GROUP 2 B_LR 2
RELU TOP conv4
CONV TOP conv5 IN conv4   K_SIZE 3 CHANNELS 256 PAD 1 GROUP 2 B_LR 2
RELU TOP conv5
POOL TOP pool5 IN conv5

PROD TOP fc6   IN pool5   CHANNELS 4096
RELU TOP fc6
DROP TOP fc6
PROD TOP fc7   IN fc6     CHANNELS 4096
RELU TOP fc7
DROP TOP fc7
PROD TOP fc8   IN fc7     CHANNELS 1000

ACCURACY TOP acc IN1 fc8 IN2 labels
SOFTMAXLOSS TOP loss IN1 fc8 IN2 labels
```


