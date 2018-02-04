# MLDatasets.jl

[![Build Status](https://travis-ci.org/JuliaML/MLDatasets.jl.svg?branch=master)](https://travis-ci.org/JuliaML/MLDatasets.jl)

`MLDatasets` provides access to common machine learning datasets
for [Julia](http://julialang.org/). Currently, julia 0.6 is
supported.

## Installation

```julia
julia> Pkg.clone("https://github.com/JuliaML/MLDatasets.jl.git")
```

## Basic Usage

```julia
using MLDatasets

train_x, train_y = MNIST.traindata()
test_x, test_y = MNIST.testdata()
```

Use `traindata(<directory>)` and `testdata(<directory>)` to change the default directory.

## Available Datasets

### Image Classification

#### CIFAR-10

The [CIFAR-10](https://www.cs.toronto.edu/~kriz/cifar.html)
dataset consists of 60000 32x32 RGB images in 10 classes.

Take a look at the [sub-module](src/CIFAR10/README.md) for more
information

#### CIFAR-100

The [CIFAR-100](https://www.cs.toronto.edu/~kriz/cifar.html)
dataset consists of 60000 32x32 color images in 100 classes. The
100 classes are grouped into 20 superclasses (fine and coarse
labels).

Take a look at the [sub-module](src/CIFAR100/README.md) for more
information

#### MNIST

The [MNIST](http://yann.lecun.com/exdb/mnist/) dataset consists
of 60000 28x28 images of handwritten digits.

Take a look at the [sub-module](src/MNIST/README.md) for more
information

#### Fashion-MNIST

The [Fashion-MNIST](https://github.com/zalandoresearch/fashion-mnist)
dataset consists of 60000 28x28 images of fashion products. It
was designed to be a drop-in replacement for the MNIST dataset

Take a look at the [sub-module](src/FashionMNIST/README.md) for more
information

### Language Modeling

#### PTBLM

The `PTBLM` dataset consists of Penn Treebank sentences for
language modeling, available from
[tomsercu/lstm](https://github.com/tomsercu/lstm). The unknown
words are replaced with `<unk>` so that the total vocaburary size
becomes 10000.

This is the first sentence of the PTBLM dataset.

```julia
x, y = PTBLM.traindata()

x[1]
> ["no", "it", "was", "n't", "black", "monday"]
y[1]
> ["it", "was", "n't", "black", "monday", "<eos>"]
```

where `MLDataset` adds the special word: `<eos>` to the end of `y`.

### Text Analysis (POS-Tagging, Parsing)

#### UD English

The [UD_English](https://github.com/UniversalDependencies/UD_English)
dataset is an annotated corpus of morphological features,
POS-tags and syntactic trees. The dataset follows CoNLL-style
format.

```julia
traindata = UD_English.traindata()
devdata = UD_English.devdata()
testdata = UD_English.devdata()
```

## Data Size
| | Type | Train x | Train y | Test x | Test y |
|:---:|:---:|:---:|:---:|:---:|:---:|
| **CIFAR-10** | image | 32x32x3x50000 | 50000 | 32x32x3x10000 | 10000 |
| **CIFAR-100** | image | 32x32x3x5000 | 50000 (x2) | 32x32x3x10000 | 10000 (x2) |
| **MNIST** | image | 28x28x60000 | 60000 | 28x28x10000 | 10000 |
| **FashionMNIST** | image | 28x28x60000 | 60000 | 28x28x10000 | 10000 |
| **PTBLM** | text | 42068 | 42068 | 3761 | 3761 |
| **UD_English** | text | 12543 | - | 2077 | - |
