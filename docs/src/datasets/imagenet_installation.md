# Installing ImageNet
The ImageNet 2012 Classification Dataset (ILSVRC 2012-2017) can be downloaded at
[image-net.org](https://image-net.org/) after signing up and accepting the terms of access.
It is therefore required that you download this dataset manually.

## Existing installation
The dataset structure is assumed to look as follows:
```
ImageNet
├── train
├── val
│   ├── n01440764
│   │   ├── ILSVRC2012_val_00000293.JPEG
│   │   ├── ILSVRC2012_val_00002138.JPEG
│   │   └── ...
│   ├── n01443537
│   └── ...
├── test
└── devkit
    ├── data
    │   ├── meta.mat
    │   └── ...
    └── ...
```
If your existing copy of the ImageNet dataset uses another file structure,
we recommend to create symbolic links, e.g. using `ln` on Unix-like operating
systems:
```bash
cd ~/.julia/datadeps
mkdir -p ImageNet/val
ln -s my/path/to/imagenet/val ImageNet/val
mkdir -p ImageNet/devkit/data
ln -s my/path/to/imagenet/devkit/data ImageNet/devkit/data
```

## New installation
Download the following files from the [ImageNet website](https://image-net.org/):
* `ILSVRC2012_devkit_t12`
* `ILSVRC2012_img_train.tar`, only required for `:train` split
* `ILSVRC2012_img_val.tar`, only required for `:val` split

After downloading the data, move and extract the training and validation images to
labeled subfolders running the following shell script:
```bash
# Extract the training data:
mkdir -p ImageNet/train && tar -xvf ILSVRC2012_img_train.tar -C ImageNet/train
# Unpack all 1000 compressed tar-files, one for each category:
cd ImageNet/train
find . -name "*.tar" | while read NAME ; do mkdir -p "\${NAME%.tar}"; tar -xvf "\${NAME}" -C "\${NAME%.tar}"; rm -f "\${NAME}"; done

# Extract the validation data:
cd ../..
mkdir -p ImageNet/val && tar -xvf ILSVRC2012_img_val.tar -C ImageNet/val

# Run script from soumith to create all class directories and moves images into corresponding directories:
cd ImageNet/val
wget -qO- https://raw.githubusercontent.com/soumith/imagenetloader.torch/master/valprep.sh | bash

# Extract metadata from the devkit:
cd ../..
mkdir -p ImageNet/devkit && tar -xvf ILSVRC2012_img_val.tar -C ImageNet/devkit
```
