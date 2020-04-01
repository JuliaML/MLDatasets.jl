# [CIFAR-100](@id CIFAR100)

Description from the [original
website](https://www.cs.toronto.edu/~kriz/cifar.html)

> The CIFAR-10 and CIFAR-100 are labeled subsets of the
> [80 million tiny images](http://people.csail.mit.edu/torralba/tinyimages/)
> dataset. They were collected by Alex Krizhevsky, Vinod Nair,
> and Geoffrey Hinton.
>
> This dataset is just like the CIFAR-10, except it has 100
> classes containing 600 images each. There are 500 training
> images and 100 testing images per class. The 100 classes in the
> CIFAR-100 are grouped into 20 superclasses. Each image comes
> with a "fine" label (the class to which it belongs) and a
> "coarse" label (the superclass to which it belongs).

## Contents

```@contents
Pages = ["CIFAR100.md"]
Depth = 3
```

## Overview

The `MLDatasets.CIFAR100` sub-module provides a programmatic
interface to download, load, and work with the CIFAR-100 dataset.

```julia
using MLDatasets

# load full training set
train_x, train_y_coarse, train_y_fine = CIFAR100.traindata()

# load full test set
test_x, test_y_coarse, test_y_fine  = CIFAR100.testdata()
```

The provided functions also allow for optional arguments, such as
the directory `dir` where the dataset is located, or the specific
observation `indices` that one wants to work with. For more
information on the interface take a look at the documentation
(e.g. `?CIFAR100.traindata`).

Function | Description
---------|-------------
[`download([dir])`](@ref CIFAR100.download) | Trigger interactive download of the dataset
[`classnames_coarse(; [dir])`](@ref CIFAR100.classnames_coarse) | Return the 20 super-class names as a vector of strings
[`classnames_fine(; [dir])`](@ref CIFAR100.classnames_fine) | Return the 100 class names as a vector of strings
[`traintensor([T], [indices]; [dir])`](@ref CIFAR100.traintensor) | Load the training images as an array of eltype `T`
[`trainlabels([indices]; [dir])`](@ref CIFAR100.trainlabels) | Load the labels for the training images
[`testtensor([T], [indices]; [dir])`](@ref CIFAR100.testtensor) | Load the test images as an array of eltype `T`
[`testlabels([indices]; [dir])`](@ref CIFAR100.testlabels) | Load the labels for the test images
[`traindata([T], [indices]; [dir])`](@ref CIFAR100.traindata) | Load images and labels of the training data
[`testdata([T], [indices]; [dir])`](@ref CIFAR100.testdata) | Load images and labels of the test data

This module also provides utility functions to make working with
the CIFAR-100 dataset in Julia more convenient.

Function | Description
---------|-------------
[`convert2image(array)`](@ref CIFAR10.convert2image) | Convert the CIFAR-100 tensor/matrix to a colorant array


To visualize an image or a prediction we provide the function
[`convert2image`](@ref CIFAR10.convert2image) to convert the
given CIFAR-100 horizontal-major tensor (or feature matrix) to a
vertical-major `Colorant` array.

```julia
julia> CIFAR100.convert2image(CIFAR100.traintensor(1)) # first training image
32×32 Array{RGB{N0f8},2}:
[...]
```

## API Documentation

### Trainingset

```@docs
CIFAR100.traintensor
CIFAR100.trainlabels
CIFAR100.traindata
```

### Testset

```@docs
CIFAR100.testtensor
CIFAR100.testlabels
CIFAR100.testdata
```

### Utilities


```@docs
CIFAR100.download
CIFAR100.classnames_coarse
CIFAR100.classnames_fine
```

See also [`CIFAR10.convert2image`](@ref).

## References

- **Authors**: Alex Krizhevsky, Vinod Nair, Geoffrey Hinton

- **Website**: https://www.cs.toronto.edu/~kriz/cifar.html

- **[Krizhevsky, 2009]** Alex Krizhevsky. ["Learning Multiple Layers of Features from Tiny Images"](https://www.cs.toronto.edu/~kriz/learning-features-2009-TR.pdf), Tech Report, 2009.
