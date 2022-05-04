# MLDatasets.jl

[![Docs Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://JuliaML.github.io/MLDatasets.jl/stable)
[![Docs Latest](https://img.shields.io/badge/docs-dev-blue.svg)](https://JuliaML.github.io/MLDatasets.jl/dev)
[![CI](https://github.com/JuliaML/MLDatasets.jl/workflows/Unit%20test/badge.svg)](https://github.com/JuliaML/MLDatasets.jl/actions)

This package represents a community effort to provide a common interface for accessing common Machine Learning datasets. 
In contrast to other data-related Julia packages, the focus of MLDatasets.jl is specifically on downloading, unpacking, and accessing benchmark datasets. 
Functionality for the purpose of data processing or visualization is only provided to a degree that is special to some dataset.

This package is a part of the
[JuliaML](https://github.com/JuliaML) ecosystem. 
Its functionality is built on top of the package
[DataDeps.jl](https://github.com/oxinabox/DataDeps.jl).

## Available Datasets

**Warning**: this package is under heavy redesign. The link belows point to the documentation for the yet to be released version. 
For the tagged version instead, please consult the [stable docs](https://JuliaML.github.io/MLDatasets.jl/stable) 

Datasets are grouped into different categories. Click on the links below for a full list of datasets available in each category.

- [Graphs](https://juliaml.github.io/MLDatasets.jl/dev/datasets/graphs) - Datasets with an underlying graph structure: Cora, PubMed, CiteSeer, ...
- [Misc](https://juliaml.github.io/MLDatasets.jl/dev/datasets/misc/) - Datasets that do not fall into any of the other categories: Iris, BostonHousing, ...
- [Text](https://juliaml.github.io/MLDatasets.jl/dev/datasets/text/) - Datasets for language models. 
- [Vision](https://juliaml.github.io/MLDatasets.jl/dev/datasets/vision/) - Vision related datasets such as MNIST, CIFAR10, CIFAR100, ... 


## Installation

To install MLDatasets.jl, start up Julia and type the following code snippet into the REPL. It makes use of the native Julia package manger.

```julia
import Pkg
Pkg.add("MLDatasets")
```

## Contributing to MLDatasets

Pull requests contributing new datasets are warmly welcome. See the source code of any of the currently implemented datasets, e.g. [Iris](https://github.com/JuliaML/MLDatasets.jl/blob/master/src/datasets/misc/iris.jl), for examples.

## License

This code is free to use under the terms of the MIT license.
