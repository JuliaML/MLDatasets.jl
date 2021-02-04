# MLDatasets.jl

_This package represents a community effort to provide a common
interface for accessing common Machine Learning (ML) datasets. In
contrast to other data-related Julia packages, the focus of
`MLDatasets.jl` is specifically on downloading, unpacking, and
accessing benchmark dataset. Functionality for the purpose of
data processing or visualization is only provided to a degree
that is special to some dataset._

| **Package Status** | **Build Status**  |
|:------------------:|:-----------------:|
| [![License](http://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat)](LICENSE.md) [![Docs](https://img.shields.io/badge/docs-stable-blue.svg)](https://JuliaML.github.io/MLDatasets.jl/stable) |  [![Build Status](https://github.com/JuliaML/MLDatasets.jl/workflows/Unit%20test/badge.svg)](https://github.com/JuliaML/MLDatasets.jl/actions)|

This package is a part of the
[`JuliaML`](https://github.com/JuliaML) ecosystem. Its
functionality is build on top of the package
[`DataDeps.jl`](https://github.com/oxinabox/DataDeps.jl).

## Introduction

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

[**EMNIST**](https://www.nist.gov/itl/products-and-services/emnist-dataset) packages 6 different extensions of the MNIST dataset involving letters and digits and variety of test train split options. Each extension has the standard test/train data/labels nested under it as shown below.

```julia
traindata = EMNIST.Balanced.traindata()
testdata = EMNIST.Balanced.testdata()
trainlabels = EMNIST.Balanced.trainlabels()
testlabels = EMNIST.Balanced.testlabels()
```

Dataset | Classes | `traintensor` | `trainlabels` | `testtensor` | `testlabels` | `balanced classes`
:------:|:-------:|:-------------:|:-------------:|:------------:|:------------:|:------------:
**ByClass** | 62 | 697932x28x28 | 697932x1 | 116323x28x28 | 116323x1 | no
**ByMerge** | 47 | 697932x28x28 | 697932x1 | 116323x28x28 | 116323x1 | no
**Balanced** | 47 | 112800x28x28 | 112800x1 | 18800x28x28 | 18800x1 | yes
**Letters** | 26 | 124800x28x28 | 124800x1 | 20800x28x28 | 208000x1 | yes
**Digits** | 10 | 240000x28x28 | 240000x1 | 40000x28x28 | 40000x1 | yes
**MNIST** | 10 | 60000x28x28 | 60000x1 | 10000x28x28 | 10000x1 | yes

### Misc. Datasets

Dataset | Classes | `traintensor` | `trainlabels` | `testtensor` | `testlabels`
:------:|:-------:|:-------------:|:-------------:|:------------:|:------------:
**Iris** | 3 | 4x150 | 150 | - | -
**BostongHousing** | - | 13x506 | 1x506 | - | -

### Language Modeling

|    | Train x | Train y | Test x | Test y |
|:--:|:-------:|:-------:|:------:|:------:|
| **PTBLM** | 42068 | 42068 | 3761 | 3761 |
| **UD_English** | 12543 | - | 2077 | - |

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

The [UD_English](https://github.com/UniversalDependencies/UD_English-EWT)
Universal Dependencies English Web Treebank dataset is an annotated corpus of morphological features,
POS-tags and syntactic trees. The dataset follows CoNLL-style
format.

```julia
traindata = UD_English.traindata()
devdata = UD_English.devdata()
testdata = UD_English.devdata()
```

## Documentation

Check out the **[latest
documentation](https://JuliaML.github.io/MLDatasets.jl/stable)**

Additionally, you can make use of Julia's native docsystem.
The following example shows how to get additional information
on `MNIST.convert2image` within Julia's REPL:

```julia
?MNIST.convert2image
```
```
  convert2image(array) -> Array{Gray}

  Convert the given MNIST horizontal-major tensor (or feature matrix) to a vertical-major Colorant array. The values are also color corrected according to
  the website's description, which means that the digits are black on a white background.

  julia> MNIST.convert2image(MNIST.traintensor()) # full training dataset
  28×28×60000 Array{Gray{N0f8},3}:
  [...]

  julia> MNIST.convert2image(MNIST.traintensor(1)) # first training image
  28×28 Array{Gray{N0f8},2}:
  [...]
```

## Installation

To install `MLDatasets.jl`, start up Julia and type the following
code snippet into the REPL. It makes use of the native Julia
package manger.

```julia
import Pkg
Pkg.add("MLDatasets")
```

## License

This code is free to use under the terms of the MIT license.
