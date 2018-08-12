# MLDatasets.jl

[![Docs](https://img.shields.io/badge/docs-stable-blue.svg)](https://JuliaML.github.io/MLDatasets.jl/stable)
[![Build Status](https://travis-ci.org/JuliaML/MLDatasets.jl.svg?branch=master)](https://travis-ci.org/JuliaML/MLDatasets.jl)

This package represents a community effort to provide a common
interface for accessing common Machine Learning (ML) datasets. In
contrast to other data-related Julia packages, the focus of
`MLDatasets.jl` is specifically on downloading, unpacking, and
accessing benchmark dataset. Functionality for the purpose of
data processing or visualization is only provided to a degree
that is special to some dataset.

This package is a part of the
[`JuliaML`](https://github.com/JuliaML) ecosystem. Its
functionality is build on top of the package
[`DataDeps.jl`](https://github.com/oxinabox/DataDeps.jl).

## Basic Usage

The way `MLDatasets.jl` is organized is that each dataset has its
own dedicated sub-module. Where possible, those sub-module share
a common interface for interacting with the datasets. For example
you can load the training set and the test set of the MNIST
database of handwritten digits using the following commands:

```julia
using MLDatasets

train_x, train_y = MNIST.traindata()
test_x,  test_y  = MNIST.testdata()
```

To load the data the package looks for the necessary files in
various locations (see
[`DataDeps.jl`](https://github.com/oxinabox/DataDeps.jl#configuration)
for more information on how to configure such defaults). If the
data can't be found in any of those locations, then the package
will trigger a download dialog to `~/.julia/datadeps/MNIST`. To
overwrite this on a case by case basis, it is possible to specify
a data directory directly in `traindata(dir = <directory>)` and
`testdata(dir = <directory>)`.

## Available Datasets

Check out the **[latest
documentation](https://juliaml.github.io/MLDatasets.jl/latest)**

Additionally, you can make use of Julia's native docsystem.
The following example shows how to get additional information
on `MNIST.traintensor` within Julia's REPL:

```julia
?MNIST.traintensor
```

Each dataset has its own dedicated sub-module. As such, it makes
sense to document their functionality similarly distributed. Find
below a list of available datasets and links to their their
documentation.

### Image Classification

This package provides a variety of common benchmark datasets for
the purpose of image classification.

Dataset | Classes | `traintensor` | `trainlabels` | `testtensor` | `testlabels`
:------:|:-------:|:-------------:|:-------------:|:------------:|:------------:
[**MNIST**](https://juliaml.github.io/MLDatasets.jl/latest/datasets/MNIST/) | 10 | 28x28x60000 | 60000 | 28x28x10000 | 10000
[**FashionMNIST**](https://juliaml.github.io/MLDatasets.jl/latest/datasets/FashionMNIST/) | 10 | 28x28x60000 | 60000 | 28x28x10000 | 10000
[**CIFAR-10**](https://juliaml.github.io/MLDatasets.jl/latest/datasets/CIFAR10/) | 10 | 32x32x3x50000 | 50000 | 32x32x3x10000 | 10000
[**CIFAR-100**](https://juliaml.github.io/MLDatasets.jl/latest/datasets/CIFAR100/) | 100 (20) | 32x32x3x50000 | 50000 (x2) | 32x32x3x10000 | 10000 (x2)
[**SVHN-2**](https://juliaml.github.io/MLDatasets.jl/latest/datasets/SVHN2/) (*) | 10 | 32x32x3x73257 | 73257 | 32x32x3x26032 | 26032

(*) Note that the SVHN-2 dataset provides an additional 531131 observations aside from the training- and testset

### Language Modeling

#### PTBLM

The `PTBLM` dataset consists of Penn Treebank sentences for
language modeling, available from
[tomsercu/lstm](https://github.com/tomsercu/lstm). The unknown
words are replaced with `<unk>` so that the total vocabulary size
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
|    | Train x | Train y | Test x | Test y |
|:--:|:-------:|:-------:|:------:|:------:|
| **PTBLM** | 42068 | 42068 | 3761 | 3761 |
| **UD_English** | 12543 | - | 2077 | - |

## Installation

To install `MLDatasets.jl`, start up Julia and type the following
code snippet into the REPL. It makes use of the native Julia
package manger.

```julia
Pkg.add("MLDatasets")
```

Additionally, for example if you encounter any sudden issues, or
in the case you would like to contribute to the package, you can
manually choose to be on the latest (untagged) version.

```julia
Pkg.checkout("MLDatasets")
```

## License

This code is free to use under the terms of the MIT license.
