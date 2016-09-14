# MLDatasets.jl
[![Build Status](https://travis-ci.org/hshindo/MLDatasets.jl.svg?branch=master)](https://travis-ci.org/hshindo/MLDatasets.jl)

`MLDatasets` provides an access to common machine learning datasets for [Julia](http://julialang.org/).

The datasets are automatically downloaded to the specified directory.
The default path is `MLDatasets/datasets`.

## Installation
```julia
julia> Pkg.clone("https://github.com/hshindo/MLDatasets.jl.git")
```

## Supported Datasets
| Dataset | Functions | Size |
|:---:|:---:|:---:|
| [MNIST](http://yann.lecun.com/exdb/mnist/) | traindata, testdata | train: 28 \* 28 \* 60000 <br> test: 28 \* 28 \* 10000 |
| [CIFAR-10](https://www.cs.toronto.edu/~kriz/cifar.html) | traindata, testdata | train: 32 \* 32 \* 3 \* 50000 <br> test: 32 \* 32 \* 3 \* 10000 |
| CIFAR-100 | under development | _ |
| PTBLM | traindata, testdata | train: 42068 sentences <br> test: 3761 sentences |

## Basic Usage
```julia
using MLDatasets

traindata = MNIST.traindata()
testdata = MNIST.testdata()
```
