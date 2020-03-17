# [The Street View House Numbers (SVHN) Dataset](@id SVHN2)

Description from the [official
website](http://ufldl.stanford.edu/housenumbers/):

> SVHN is a real-world image dataset for developing machine
> learning and object recognition algorithms with minimal
> requirement on data preprocessing and formatting. It can be
> seen as similar in flavor to MNIST (e.g., the images are of
> small cropped digits), but incorporates an order of magnitude
> more labeled data (over 600,000 digit images) and comes from a
> significantly harder, unsolved, real world problem (recognizing
> digits and numbers in natural scene images). SVHN is obtained
> from house numbers in Google Street View images.

About Format 2 (Cropped Digits):

> All digits have been resized to a fixed resolution of 32-by-32
> pixels. The original character bounding boxes are extended in
> the appropriate dimension to become square windows, so that
> resizing them to 32-by-32 pixels does not introduce aspect
> ratio distortions. Nevertheless this preprocessing introduces
> some distracting digits to the sides of the digit of interest.

!!! note

    For non-commercial use only

## Contents

```@contents
Pages = ["SVHN2.md"]
Depth = 3
```

## Overview

The `MLDatasets.SVHN2` sub-module provides a programmatic
interface to download, load, and work with the SVHN2 dataset of
handwritten digits.

```julia
using MLDatasets

# load full training set
train_x, train_y = SVHN2.traindata()

# load full test set
test_x,  test_y  = SVHN2.testdata()

# load additional train set
extra_x, extra_y = SVHN2.extradata()
```

The provided functions also allow for optional arguments, such as
the directory `dir` where the dataset is located, or the specific
observation `indices` that one wants to work with. For more
information on the interface take a look at the documentation
(e.g. `?SVHN2.traindata`).

Function | Description
---------|-------------
[`download([dir])`](@ref SVHN2.download) | Trigger interactive download of the dataset
[`classnames()`](@ref SVHN2.classnames) | Return the class names as a vector of strings
[`traintensor([T], [indices]; [dir])`](@ref SVHN2.traintensor) | Load the training images as an array of eltype `T`
[`trainlabels([indices]; [dir])`](@ref SVHN2.trainlabels) | Load the labels for the training images
[`traindata([T], [indices]; [dir])`](@ref SVHN2.traindata) | Load images and labels of the training data
[`testtensor([T], [indices]; [dir])`](@ref SVHN2.testtensor) | Load the test images as an array of eltype `T`
[`testlabels([indices]; [dir])`](@ref SVHN2.testlabels) | Load the labels for the test images
[`testdata([T], [indices]; [dir])`](@ref SVHN2.testdata) | Load images and labels of the test data
[`extratensor([T], [indices]; [dir])`](@ref SVHN2.extratensor) | Load the extra images as an array of eltype `T`
[`extralabels([indices]; [dir])`](@ref SVHN2.extralabels) | Load the labels for the extra training images
[`extradata([T], [indices]; [dir])`](@ref SVHN2.extradata) | Load images and labels of the extra training data

This module also provides utility functions to make working with
the SVHN (format 2) dataset in Julia more convenient.

Function | Description
---------|-------------
[`convert2image(array)`](@ref SVHN2.convert2image) | Convert the SVHN tensor/matrix to a colorant array

To visualize an image or a prediction we provide the function
[`convert2image`](@ref SVHN2.convert2image) to convert the
given SVHN2 horizontal-major tensor (or feature matrix) to a
vertical-major `Colorant` array.

```julia
julia> SVHN2.convert2image(SVHN2.traindata(1)[1]) # first training image
32×32 Array{RGB{N0f8},2}:
[...]
```

## API Documentation

```@docs
SVHN2
```

### Trainingset

```@docs
SVHN2.traintensor
SVHN2.trainlabels
SVHN2.traindata
```

### Testset

```@docs
SVHN2.testtensor
SVHN2.testlabels
SVHN2.testdata
```

### Extraset

```@docs
SVHN2.extratensor
SVHN2.extralabels
SVHN2.extradata
```

### Utilities

```@docs
SVHN2.download
SVHN2.classnames
SVHN2.convert2image
```

## References

- **Authors**: Yuval Netzer, Tao Wang, Adam Coates, Alessandro Bissacco, Bo Wu, Andrew Y. Ng

- **Website**: http://ufldl.stanford.edu/housenumbers

- **[Netzer et al., 2011]** Yuval Netzer, Tao Wang, Adam Coates, Alessandro Bissacco, Bo Wu, Andrew Y. Ng. "Reading Digits in Natural Images with Unsupervised Feature Learning" NIPS Workshop on Deep Learning and Unsupervised Feature Learning 2011
