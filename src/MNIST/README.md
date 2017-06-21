# THE MNIST DATABASE of handwritten digits

Description from the [official website](http://yann.lecun.com/exdb/mnist/):

> The MNIST database of handwritten digits, available from this
> page, has a training set of 60,000 examples, and a test set of
> 10,000 examples. It is a subset of a larger set available from
> NIST. The digits have been size-normalized and centered in a
> fixed-size image.
>
> It is a good database for people who want to try learning
> techniques and pattern recognition methods on real-world data
> while spending minimal efforts on preprocessing and formatting.

## Usage

This sub-module provides a programmatic interface to download,
load, and work with the MNIST dataset of handwritten digits.

```julia
using MLDatasets

# download dataset
MNIST.download_helper()

# load full training set
train_x, train_y = MNIST.traindata()

# load full test set
test_x,  test_y  = MNIST.testdata()
```

The provided functions also allow for optional arguments, such as
the directory `dir` where the dataset is located, or the specific
observation `indices` that one wants to work with. For more
information on the interface take a look at the documentation
(e.g. `?MNIST.traindata`).

Function | Description
---------|-------------
`download_helper([dir])` | Trigger interactive download of the dataset
`traintensor([indices]; [dir], [decimal=true])` | Load the training images as an array
`trainlabels([indices]; [dir])` | Load the labels for the training images
`testtensor([indices]; [dir], [decimal=true])` | Load the test images as an array
`testlabels([indices]; [dir])` | Load the labels for the test images
`traindata([indices]; [dir], [decimal=true])` | Load images and labels of the training data
`testdata([indices]; [dir], [decimal=true])` | Load images and labels of the test data

This module also provides utility functions to make working with
the MNIST dataset in Julia more convenient.

You can use the function `convert2features` to convert the given
MNIST tensor to a feature matrix (or feature vector in the case
of a single image). The purpose of this function is to drop the
spatial dimensions such that traditional ML algorithms can
process the dataset.

```julia
julia> MNIST.convert2features(MNIST.traintensor()) # full training data
784×60000 Array{Float64,2}:
[...]
```

To visualize an image or a prediction we provide the function
`convert2image` to convert the given MNIST horizontal-major
tensor (or feature matrix) to a vertical-major `Colorant` array.
The values are also color corrected according to the website's
description, which means that the digits are black on a white
background.

```julia
julia> MNIST.convert2image(MNIST.traintensor(1)) # first training image
28×28 Array{Gray{Float64},2}:
[...]
```

## References

- **Authors**: Yann LeCun, Corinna Cortes, Christopher J.C. Burges

- **Website**: http://yann.lecun.com/exdb/mnist/

- **[LeCun et al., 1998a]** Y. LeCun, L. Bottou, Y. Bengio, and P. Haffner. "Gradient-based learning applied to document recognition." Proceedings of the IEEE, 86(11):2278-2324, November 1998
