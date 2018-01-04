# CIFAR-100

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

## Usage

This sub-module provides a programmatic interface to download,
load, and work with the CIFAR-100 dataset.

```julia
using MLDatasets

# download dataset
CIFAR100.download()

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
`download([dir])` | Trigger interactive download of the dataset
`classnames_coarse()` | Return the 20 super-class names as a vector of strings
`classnames_fine()` | Return the 100 class names as a vector of strings
`traintensor([T], [indices]; [dir])` | Load the training images as an array of eltype `T`
`trainlabels([indices]; [dir])` | Load the labels for the training images
`testtensor([T], [indices]; [dir])` | Load the test images as an array of eltype `T`
`testlabels([indices]; [dir])` | Load the labels for the test images
`traindata([T], [indices]; [dir])` | Load images and labels of the training data
`testdata([T], [indices]; [dir])` | Load images and labels of the test data

This module also provides utility functions to make working with
the CIFAR100 dataset in Julia more convenient.

You can use the function `convert2features` to convert the given
CIFAR100 tensor to a feature matrix (or feature vector in the case
of a single image). The purpose of this function is to drop the
spatial dimensions such that traditional ML algorithms can
process the dataset.

```julia
julia> CIFAR100.convert2features(CIFAR100.traintensor()) # full training data
3072×50000 Array{N0f8,2}:
[...]
```

To visualize an image or a prediction we provide the function
`convert2image` to convert the given CIFAR100 horizontal-major
tensor (or feature matrix) to a vertical-major `Colorant` array.

```julia
julia> CIFAR100.convert2image(CIFAR100.traintensor(1)) # first training image
32×32 Array{RGB{N0f8},2}:
[...]
```

## References

- **Authors**: Alex Krizhevsky, Vinod Nair, Geoffrey Hinton

- **Website**: https://www.cs.toronto.edu/~kriz/cifar.html

- **[Krizhevsky, 2009]** Alex Krizhevsky. ["Learning Multiple Layers of Features from Tiny Images"](https://www.cs.toronto.edu/~kriz/learning-features-2009-TR.pdf), Tech Report, 2009.
