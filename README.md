# MLDatasets.jl

| **Documentation** | **Build Status**  |
|:------------------:|:-----------------:|
| ![Docs][docs-stable-img](docs-stable-url) [![Docs][docs-latest-img](docs-latest-url) |  [![Build Status](https://github.com/JuliaML/MLDatasets.jl/workflows/Unit%20test/badge.svg)](https://github.com/JuliaML/MLDatasets.jl/actions)|

[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-latest-img]: https://img.shields.io/badge/docs-latest-blue.svg
[docs-stable-url]: https://JuliaML.github.io/MLDatasets.jl/stable
[docs-latest-url]: https://JuliaML.github.io/MLDatasets.jl/latest

This package represents a community effort to provide a common interface for accessing common Machine Learning (ML) datasets. 
In contrast to other data-related Julia packages, the focus of `MLDatasets.jl` is specifically on downloading, unpacking, and accessing benchmark datasets. 
Functionality for the purpose of data processing or visualization is only provided to a degree that is special to some dataset.

This package is a part of the
[`JuliaML`](https://github.com/JuliaML) ecosystem. 
Its functionality is built on top of the package
[`DataDeps.jl`](https://github.com/oxinabox/DataDeps.jl).


## Available Datasets

Each dataset has its own dedicated sub-module. 
Find below a list of available datasets and links to their documentation.

#### Vision
  - [CIFAR10](https://juliaml.github.io/MLDatasets.jl/latest/datasets/CIFAR100/)
  - [CIFAR100](https://juliaml.github.io/MLDatasets.jl/latest/datasets/CIFAR100/)
  - [EMNIST](https://juliaml.github.io/MLDatasets.jl/latest/datasets/EMNIST/)
  - [FashionMNIST](https://juliaml.github.io/MLDatasets.jl/latest/datasets/FashionMNIST/)
  - [MNIST](https://juliaml.github.io/MLDatasets.jl/latest/datasets/MNIST/)
  - [SVHN2](https://juliaml.github.io/MLDatasets.jl/latest/datasets/SVHN2/)


#### Miscellaneous
  - [BostonHousing](https://juliaml.github.io/MLDatasets.jl/latest/datasets/BostonHousing/)
  - [Iris](https://juliaml.github.io/MLDatasets.jl/latest/datasets/Iris/)


#### Text
  - [PTBLM](https://juliaml.github.io/MLDatasets.jl/latest/datasets/PTBLM/)
  - [UD_English](https://juliaml.github.io/MLDatasets.jl/latest/datasets/UD_English/)

#### Graphs
  - To be added.

#### Audio
  - To be added.


## Installation

To install `MLDatasets.jl`, start up Julia and type the following code snippet into the REPL. 
It makes use of the native Julia
package manger.

```julia
import Pkg
Pkg.add("MLDatasets")
```

## License

This code is free to use under the terms of the MIT license.
