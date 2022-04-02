# MLDatasets.jl

[![Docs Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://JuliaML.github.io/MLDatasets.jl/stable)
[![Docs Latest](https://img.shields.io/badge/docs-dev-blue.svg)](https://JuliaML.github.io/MLDatasets.jl/dev)
[![CI](https://github.com/JuliaML/MLDatasets.jl/workflows/Unit%20test/badge.svg)](https://github.com/JuliaML/MLDatasets.jl/actions)

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
  - [CIFAR10](https://juliaml.github.io/MLDatasets.jl/dev/datasets/CIFAR10/)
  - [CIFAR100](https://juliaml.github.io/MLDatasets.jl/dev/datasets/CIFAR100/)
  - [EMNIST](https://juliaml.github.io/MLDatasets.jl/dev/datasets/EMNIST/)
  - [FashionMNIST](https://juliaml.github.io/MLDatasets.jl/dev/datasets/FashionMNIST/)
  - [MNIST](https://juliaml.github.io/MLDatasets.jl/dev/datasets/MNIST/)
  - [SVHN2](https://juliaml.github.io/MLDatasets.jl/dev/datasets/SVHN2/)

#### Miscellaneous
  - [BostonHousing](https://juliaml.github.io/MLDatasets.jl/dev/datasets/BostonHousing/)
  - [Iris](https://juliaml.github.io/MLDatasets.jl/dev/datasets/Iris/)
  - [Mutagenesis](https://relational.fit.cvut.cz/dataset/Mutagenesis)
  - [Titanic](https://juliaml.github.io/MLDatasets.jl/dev/datasets/Titanic/)

#### Text
  - [PTBLM](https://juliaml.github.io/MLDatasets.jl/dev/datasets/PTBLM/)
  - [UD_English](https://juliaml.github.io/MLDatasets.jl/dev/datasets/UD_English/)
  - [SMSSpamClassification](https://juliaml.github.io/MLDatasets.jl/dev/datasets/SMSSpamClassification/)

#### Graphs

Documentation [link](https://juliaml.github.io/MLDatasets.jl/dev/datasets/graphs). Available datasets:
  - CiteSeer
  - Cora
  - OGBDataset
  - PubMed
  - TUDataset

## Installation

To install `MLDatasets.jl`, start up Julia and type the following code snippet into the REPL. 
It makes use of the native Julia
package manger.

```julia
import Pkg
Pkg.add("MLDatasets")
```

## Contributing to MLDatasets

New dataset contributions are warmly welcome. See `src/Cora/Cora.jl` for an example
of a minimal implementation. 

## License

This code is free to use under the terms of the MIT license.
