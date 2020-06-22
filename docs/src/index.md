# MLDatasets.jl's Documentation

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

Each dataset has its own dedicated sub-module. 
Their functionality is documented accordingly. 
Find below a list of the available datasets and their documentation.

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


### Misc. Datasets
Dataset | Classes | `traintensor` | `trainlabels` | `testtensor` | `testlabels`
:------:|:-------:|:-------------:|:-------------:|:------------:|:------------:
**Iris** | 3 | 4x150 | 150 | - | -
**BostongHousing** | - | 13x506 | 1x506 | - | -

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

The [UD_English](https://github.com/UniversalDependencies/UD_English-EWT)
Universal Dependencies English Web Treebank dataset is an annotated corpus of morphological features,
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


## Index

```@contents
Pages = ["indices.md"]
```
