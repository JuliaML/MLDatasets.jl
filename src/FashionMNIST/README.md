# Fashion-MNIST

Description from the [official website](https://github.com/zalandoresearch/fashion-mnist)

> Fashion-MNIST is a dataset of Zalando's article
> images—consisting of a training set of 60,000 examples and a
> test set of 10,000 examples. Each example is a 28x28 grayscale
> image, associated with a label from 10 classes. We intend
> Fashion-MNIST to serve as a direct drop-in replacement for the
> original MNIST dataset for benchmarking machine learning
> algorithms. It shares the same image size and structure of
> training and testing splits.

## Usage

This sub-module provides a programmatic interface to download,
load, and work with the Fashion MNIST dataset.

```julia
using MLDatasets

# download dataset
FashionMNIST.download()

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
`download([dir])` | Trigger interactive download of the dataset
`traintensor([indices]; [dir], [decimal=true])` | Load the training images as an array
`trainlabels([indices]; [dir])` | Load the labels for the training images
`testtensor([indices]; [dir], [decimal=true])` | Load the test images as an array
`testlabels([indices]; [dir])` | Load the labels for the test images
`traindata([indices]; [dir], [decimal=true])` | Load images and labels of the training data
`testdata([indices]; [dir], [decimal=true])` | Load images and labels of the test data

This module also provides utility functions to make working with
the FashionMNIST dataset in Julia more convenient.

You can use the function `convert2features` to convert the given
FashionMNIST tensor to a feature matrix (or feature vector in the case
of a single image). The purpose of this function is to drop the
spatial dimensions such that traditional ML algorithms can
process the dataset.

```julia
julia> FashionMNIST.convert2features(FashionMNIST.traintensor()) # full training data
784×60000 Array{Float64,2}:
[...]
```

To visualize an image or a prediction we provide the function
`convert2image` to convert the given FashionMNIST horizontal-major
tensor (or feature matrix) to a vertical-major `Colorant` array.
The values are also color corrected according to the website's
description, which means that the digits are black on a white
background.

```julia
julia> FashionMNIST.convert2image(FashionMNIST.traintensor(1)) # first training image
28×28 Array{Gray{Float64},2}:
[...]
```

## References

- **Authors**: Han Xiao, Kashif Rasul, Roland Vollgraf

- **Website**: https://github.com/zalandoresearch/fashion-mnist

- **[Han Xiao et al. 2017]** Han Xiao, Kashif Rasul, and Roland Vollgraf. "Fashion-MNIST: a Novel Image Dataset for Benchmarking Machine Learning Algorithms." arXiv:1708.07747
