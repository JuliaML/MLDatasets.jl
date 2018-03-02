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

Each dataset has its own dedicated sub-module. As such, it makes
sense to document their functionality similarly distributed. Find
below a list of available datasets and their documentation.

### Image Classification

This package provides a variety of common benchmark datasets for
the purpose of image classification.

Dataset | Classes | `traintensor` | `trainlabels` | `testtensor` | `testlabels`
:------:|:-------:|:-------------:|:-------------:|:------------:|:------------:
[**MNIST**](@ref MNIST) | 10 | 28x28x60000 | 60000 | 28x28x10000 | 10000
[**FashionMNIST**](@ref FashionMNIST) | 10 | 28x28x60000 | 60000 | 28x28x10000 | 10000
[**CIFAR-10**](@ref CIFAR10) | 10 | 32x32x3x50000 | 50000 | 32x32x3x10000 | 10000
[**CIFAR-100**](@ref CIFAR100) | 100 (20) | 32x32x3x50000 | 50000 (x2) | 32x32x3x10000 | 10000 (x2)
[**SVHN-2**](@ref SVHN2) (*) | 10 | 32x32x3x73257 | 73257 | 32x32x3x26032 | 26032

(*) Note that the SVHN-2 dataset provides an additional 531131 observations aside from the training- and testset

### Language Modeling

Work in progress

## Index

```@contents
Pages = ["indices.md"]
```
