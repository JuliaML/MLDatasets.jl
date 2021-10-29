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

## Preview

For image dataset, [`MosaicViews`](https://github.com/JuliaArrays/MosaicViews.jl) provides a very simple interface to display a list
of images.

```@example
using MLDatasets
using ImageCore

# The original dataset is stored in row-major order, to display it
# normally in Julia, we need to permute the first two dimensions.
test_x = Gray.(PermutedDimsArray(MNIST.testtensor(), (2, 1, 3)));
test_x_sample = @view test_x[:, :, 1:64];

mosaic(test_x_sample, nrow=8)
```
