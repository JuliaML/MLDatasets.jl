# MLDatasets.jl
[![Build Status](https://travis-ci.org/hshindo/MLDatasets.jl.svg?branch=master)](https://travis-ci.org/hshindo/MLDatasets.jl)

`MLDatasets` provides an access to common machine learning datasets for [Julia](http://julialang.org/).

The datasets are automatically downloaded to the specified directory.
The default directory is `MLDatasets/datasets`.

## Installation
```julia
julia> Pkg.clone("https://github.com/hshindo/MLDatasets.jl.git")
```

## Supported Datasets
#### CIFAR-10
The [CIFAR10](https://www.cs.toronto.edu/~kriz/cifar.html) dataset consists of 60000 32x32 color images in 10 classes.

#### CIFAR-100
The [CIFAR100](https://www.cs.toronto.edu/~kriz/cifar.html) dataset consists of 600 32x32 color images in 100 classes. The 100 classes are grouped into 20 superclasses (fine and coarse labels).

#### MNIST
The [MNIST](http://yann.lecun.com/exdb/mnist/) dataset consists of 60000 28x28 images of handwritten digits.

#### PTBLM
The PTBLM dataset is a Penn Treebank sentences for language modeling.
The vocaburary is limited to 10000.
The unknown word is replaced with `<unk>`.

### Data Size
| | Train x | Train y | Test x | Test y |
|:---:|:---:|:---:|:---:|:---:|
| **CIFAR10** | 32x32x3x50000 | 50000 | 32x32x3x10000 | 10000 |
| **CIFAR100** | 32x32x3x5000 | 2x500 | 32x32x3x100 | 2x100 |
| **MNIST** | 28x28x60000 | 60000 | 28x28x10000 | 10000 |
| **PTBLM** | 42068 | - | 3761 | - |

## Basic Usage
```julia
using MLDatasets

traindata = MNIST.traindata()
testdata = MNIST.testdata()
```
