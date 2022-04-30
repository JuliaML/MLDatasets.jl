# MLDatasets.jl's Documentation

This package represents a community effort to provide a common
interface for accessing common Machine Learning (ML) datasets. In
contrast to other data-related Julia packages, the focus of
`MLDatasets.jl` is specifically on downloading, unpacking, and
accessing benchmark dataset. Functionality for the purpose of
data processing or visualization is only provided to a degree
that is special to some dataset.

This package is a part of the
[`JuliaML`](https://github.com/JuliaML) ecosystem.

## Installation

To install `MLDatasets.jl`, start up Julia and type the following
code snippet into the REPL. It makes use of the native Julia
package manger.

```julia
Pkg.add("MLDatasets")
```

## Basic Usage

The way `MLDatasets.jl` is organized is that each dataset is its own type. 
Where possible, those types share a common interface (fields and methods). 

Once a dataset has been instantiated, e.g. by `dataset = MNIST()`,  
an observation `i` can be retrieved using the indexing syntax `dataset[i]`.
By indexing with no arguments, `dataset[]`, the whole set of observations is collected.

For example you can load the training set of the [`MNIST`](@ref)
database of handwritten digits using the following commands:
```julia-repl
julia> using MLDatasets

julia> trainset = MNIST(:train)
dataset MNIST:
  metadata    =>    Dict{String, Any} with 3 entries
  split       =>    :train
  features    =>    28×28×60000 Array{Float32, 3}
  targets     =>    60000-element Vector{Int64}

julia> trainset[1]  # return first observation as a NamedTuple
(features = Float32[0.0 0.0 … 0.0 0.0; 0.0 0.0 … 0.0 0.0; … ; 0.0 0.0 … 0.0 0.0; 0.0 0.0 … 0.0 0.0], 
 targets = 5)

julia> X_train, y_train = trainset[] # return all observations
(features = [0.0 0.0 … 0.0 0.0; 0.0 0.0 … 0.0 0.0; … ; 0.0 0.0 … 0.0 0.0; 0.0 0.0 … 0.0 0.0;;; 0.0 0.0 … 0.0 0.0; 0.0 0.0 … 0.0 0.0; … ; 0.0 0.0 … 0.0 0.0; 0.0 0.0 … 0.0 0.0;;; 0.0 0.0 … 0.0 0.0; 0.0 0.0 … 0.0 0.0; … ; 0.0 0.0 … 0.0 0.0; 0.0 0.0 … 0.0 0.0;;; … ;;; 0.0 0.0 … 0.0 0.0; 0.0 0.0 … 0.0 0.0; … ; 0.0 0.0 … 0.0 0.0; 0.0 0.0 … 0.0 0.0;;; 0.0 0.0 … 0.0 0.0; 0.0 0.0 … 0.0 0.0; … ; 0.0 0.0 … 0.0 0.0; 0.0 0.0 … 0.0 0.0;;; 0.0 0.0 … 0.0 0.0; 0.0 0.0 … 0.0 0.0; … ; 0.0 0.0 … 0.0 0.0; 0.0 0.0 … 0.0 0.0], 
 targets = [5, 0, 4, 1, 9, 2, 1, 3, 1, 4  …  9, 2, 9, 5, 1, 8, 3, 5, 6, 8])

julia> summary(X_train)
"28×28×60000 Array{Float32, 3}"
```

Input features are commonly denoted by `features`, while labels for classification or regression targets are denoted by `targets`.

## Download location

MLDatasets.jl is build on top of the package
[`DataDeps.jl`](https://github.com/oxinabox/DataDeps.jl).
To load the data the package looks for the necessary files in
various locations (see
[`DataDeps.jl`](https://github.com/oxinabox/DataDeps.jl#configuration)
for more information on how to configure such defaults). If the
data can't be found in any of those locations, then the package
will trigger a download dialog to `~/.julia/datadeps/<DATASETNAME>`. To
overwrite this on a case by case basis, it is possible to specify
a data directory directly in the dataset constructor (e.g. `MNIST(dir = <directory>)`).

In order to download datasets without having to manually confirm the download, 
you can set to true the following enviromental variable:

```julia
ENV["DATADEPS_ALWAYS_ACCEPT"] = true
```


