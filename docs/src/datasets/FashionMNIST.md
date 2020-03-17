# [Fashion-MNIST](@id FashionMNIST)

Description from the [official website](https://github.com/zalandoresearch/fashion-mnist)

> Fashion-MNIST is a dataset of Zalando's article
> images—consisting of a training set of 60,000 examples and a
> test set of 10,000 examples. Each example is a 28x28 grayscale
> image, associated with a label from 10 classes. We intend
> Fashion-MNIST to serve as a direct drop-in replacement for the
> original MNIST dataset for benchmarking machine learning
> algorithms. It shares the same image size and structure of
> training and testing splits.

## Contents

```@contents
Pages = ["FashionMNIST.md"]
Depth = 3
```

## Overview

The `MLDatasets.FashionMNIST` sub-module provides a programmatic
interface to download, load, and work with the Fashion-MNIST
dataset.

```julia
using MLDatasets

# load full training set
train_x, train_y = FashionMNIST.traindata()

# load full test set
test_x,  test_y  = FashionMNIST.testdata()
```

The provided functions also allow for optional arguments, such as
the directory `dir` where the dataset is located, or the specific
observation `indices` that one wants to work with. For more
information on the interface take a look at the documentation
(e.g. `?FashionMNIST.traindata`).

Function | Description
---------|-------------
[`download([dir])`](@ref FashionMNIST.download) | Trigger (interactive) download of the dataset
[`classnames()`](@ref FashionMNIST.classnames) | Return the class names as a vector of strings
[`traintensor([T], [indices]; [dir])`](@ref FashionMNIST.traintensor) | Load the training images as an array of eltype `T`
[`trainlabels([indices]; [dir])`](@ref FashionMNIST.trainlabels) | Load the labels for the training images
[`testtensor([T], [indices]; [dir])`](@ref FashionMNIST.testtensor) | Load the test images as an array of eltype `T`
[`testlabels([indices]; [dir])`](@ref FashionMNIST.testlabels) | Load the labels for the test images
[`traindata([T], [indices]; [dir])`](@ref FashionMNIST.traindata) | Load images and labels of the training data
[`testdata([T], [indices]; [dir])`](@ref FashionMNIST.testdata) | Load images and labels of the test data

This module also provides utility functions to make working with
the Fashion-MNIST dataset in Julia more convenient.

Function | Description
---------|-------------
[`convert2image(array)`](@ref MNIST.convert2image) | Convert the Fashion-MNIST tensor/matrix to a colorant array

To visualize an image or a prediction we provide the function
[`convert2image`](@ref MNIST.convert2image) to convert the
given Fashion-MNIST horizontal-major tensor (or feature matrix)
to a vertical-major `Colorant` array. The values are also color
corrected according to the website's description, which means
that the digits are black on a white background.

```julia
julia> FashionMNIST.convert2image(FashionMNIST.traintensor(1)) # first training image
28×28 Array{Gray{N0f8},2}:
[...]
```

## API Documentation

```@docs
FashionMNIST
```

### Trainingset

```@docs
FashionMNIST.traintensor
FashionMNIST.trainlabels
FashionMNIST.traindata
```

### Testset

```@docs
FashionMNIST.testtensor
FashionMNIST.testlabels
FashionMNIST.testdata
```

### Utilities

```@docs
FashionMNIST.download
FashionMNIST.classnames
```

Also, the `FashionMNIST` module is re-exporting [`convert2image`](@ref MNIST.convert2image) from the [`MNIST`](@ref) module.

## References

- **Authors**: Han Xiao, Kashif Rasul, Roland Vollgraf

- **Website**: https://github.com/zalandoresearch/fashion-mnist

- **[Han Xiao et al. 2017]** Han Xiao, Kashif Rasul, and Roland Vollgraf. "Fashion-MNIST: a Novel Image Dataset for Benchmarking Machine Learning Algorithms." arXiv:1708.07747
