# [CIFAR-10](@id CIFAR10)

Description from the [original
website](https://www.cs.toronto.edu/~kriz/cifar.html)

> The CIFAR-10 and CIFAR-100 are labeled subsets of the
> [80 million tiny images](http://people.csail.mit.edu/torralba/tinyimages/)
> dataset. They were collected by Alex Krizhevsky, Vinod Nair,
> and Geoffrey Hinton.
>
> The CIFAR-10 dataset consists of 60000 32x32 colour images in
> 10 classes, with 6000 images per class. There are 50000
> training images and 10000 test images.

## Contents

```@contents
Pages = ["CIFAR10.md"]
Depth = 3
```

## Overview

The `MLDatasets.CIFAR10` sub-module provides a programmatic
interface to download, load, and work with the CIFAR-10 dataset.

```julia
using MLDatasets

# load full training set
train_x, train_y = CIFAR10.traindata()

# load full test set
test_x,  test_y  = CIFAR10.testdata()
```

The provided functions also allow for optional arguments, such as
the directory `dir` where the dataset is located, or the specific
observation `indices` that one wants to work with. For more
information on the interface take a look at the documentation
(e.g. `?CIFAR10.traindata`).

Function | Description
---------|-------------
[`download([dir])`](@ref CIFAR10.download) | Trigger interactive download of the dataset
[`classnames()`](@ref CIFAR10.classnames) | Return the class names as a vector of strings
[`traintensor([T], [indices]; [dir])`](@ref CIFAR10.traintensor) | Load the training images as an array of eltype `T`
[`trainlabels([indices]; [dir])`](@ref CIFAR10.trainlabels) | Load the labels for the training images
[`testtensor([T], [indices]; [dir])`](@ref CIFAR10.testtensor) | Load the test images as an array of eltype `T`
[`testlabels([indices]; [dir])`](@ref CIFAR10.testlabels) | Load the labels for the test images
[`traindata([T], [indices]; [dir])`](@ref CIFAR10.traindata) | Load images and labels of the training data
[`testdata([T], [indices]; [dir])`](@ref CIFAR10.testdata) | Load images and labels of the test data

This module also provides utility functions to make working with
the CIFAR-10 dataset in Julia more convenient.

Function | Description
---------|-------------
[`convert2image(array)`](@ref CIFAR10.convert2image) | Convert the CIFAR-10 tensor/matrix to a colorant array


To visualize an image or a prediction we provide the function
[`convert2image`](@ref CIFAR10.convert2image) to convert the
given CIFAR10 horizontal-major tensor (or feature matrix) to a
vertical-major `Colorant` array.

```julia
julia> CIFAR10.convert2image(CIFAR10.traintensor(1)) # first training image
32×32 Array{RGB{N0f8},2}:
[...]
```

## API Documentation

### Trainingset

```@docs
CIFAR10.traintensor
CIFAR10.trainlabels
CIFAR10.traindata
```

### Testset

```@docs
CIFAR10.testtensor
CIFAR10.testlabels
CIFAR10.testdata
```

### Utilities

```@docs
CIFAR10.download
CIFAR10.classnames
CIFAR10.convert2image
```

## References

- **Authors**: Alex Krizhevsky, Vinod Nair, Geoffrey Hinton

- **Website**: https://www.cs.toronto.edu/~kriz/cifar.html

- **[Krizhevsky, 2009]** Alex Krizhevsky. ["Learning Multiple Layers of Features from Tiny Images"](https://www.cs.toronto.edu/~kriz/learning-features-2009-TR.pdf), Tech Report, 2009.
