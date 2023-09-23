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
package manager.

```julia
Pkg.add("MLDatasets")
```

## Available Datasets

Datasets are grouped into different categories. Click on the links below for a full list of datasets available in each category.

- [Graph Datasets](@ref) - datasets with an underlying graph structure: Cora, PubMed, CiteSeer, ...
- [Miscellaneuous Datasets](@ref) - datasets that do not fall into any of the other categories: Iris, BostonHousing, ...
- [Text Datasets](@ref) - datasets for language models. 
- [Vision Datasets](@ref) - vision related datasets such as MNIST, CIFAR10, CIFAR100, ... 


## Basic Usage

The way `MLDatasets.jl` is organized is that each dataset is its own type. 
Where possible, those types share a common interface (fields and methods). 

Once a dataset has been instantiated, e.g. by `dataset = MNIST()`,  
an observation `i` can be retrieved using the indexing syntax `dataset[i]`.
By indexing with no arguments, `dataset[:]`, the whole set of observations is collected.
The total number of observations is given by `length(dataset)`.

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

julia> length(trainset)
60000

julia> trainset[1]  # return first observation as a NamedTuple
(features = Float32[0.0 0.0 … 0.0 0.0; 0.0 0.0 … 0.0 0.0; … ; 0.0 0.0 … 0.0 0.0; 0.0 0.0 … 0.0 0.0], 
 targets = 5)

julia> X_train, y_train = trainset[:] # return all observations
(features = [0.0 0.0 … 0.0 0.0; 0.0 0.0 … 0.0 0.0; … ; 0.0 0.0 … 0.0 0.0; 0.0 0.0 … 0.0 0.0;;; 0.0 0.0 … 0.0 0.0; 0.0 0.0 … 0.0 0.0; … ; 0.0 0.0 … 0.0 0.0; 0.0 0.0 … 0.0 0.0;;; 0.0 0.0 … 0.0 0.0; 0.0 0.0 … 0.0 0.0; … ; 0.0 0.0 … 0.0 0.0; 0.0 0.0 … 0.0 0.0;;; … ;;; 0.0 0.0 … 0.0 0.0; 0.0 0.0 … 0.0 0.0; … ; 0.0 0.0 … 0.0 0.0; 0.0 0.0 … 0.0 0.0;;; 0.0 0.0 … 0.0 0.0; 0.0 0.0 … 0.0 0.0; … ; 0.0 0.0 … 0.0 0.0; 0.0 0.0 … 0.0 0.0;;; 0.0 0.0 … 0.0 0.0; 0.0 0.0 … 0.0 0.0; … ; 0.0 0.0 … 0.0 0.0; 0.0 0.0 … 0.0 0.0], 
 targets = [5, 0, 4, 1, 9, 2, 1, 3, 1, 4  …  9, 2, 9, 5, 1, 8, 3, 5, 6, 8])

julia> summary(X_train)
"28×28×60000 Array{Float32, 3}"
```

Input features are commonly denoted by `features`, while classification labels and regression targets are denoted by `targets`.

```julia-repl
julia> using MLDatasets, DataFrames

julia> iris = Iris()
dataset Iris:
  metadata    =>    Dict{String, Any} with 4 entries
  features    =>    150×4 DataFrame
  targets     =>    150×1 DataFrame
  dataframe   =>    150×5 DataFrame

julia> iris.features
150×4 DataFrame
 Row │ sepallength  sepalwidth  petallength  petalwidth 
     │ Float64      Float64     Float64      Float64    
─────┼──────────────────────────────────────────────────
   1 │         5.1         3.5          1.4         0.2
   2 │         4.9         3.0          1.4         0.2
   3 │         4.7         3.2          1.3         0.2
   4 │         4.6         3.1          1.5         0.2
   5 │         5.0         3.6          1.4         0.2
   6 │         5.4         3.9          1.7         0.4
   7 │         4.6         3.4          1.4         0.3
   8 │         5.0         3.4          1.5         0.2
   9 │         4.4         2.9          1.4         0.2
  ⋮  │      ⋮           ⋮            ⋮           ⋮
 142 │         6.9         3.1          5.1         2.3
 143 │         5.8         2.7          5.1         1.9
 144 │         6.8         3.2          5.9         2.3
 145 │         6.7         3.3          5.7         2.5
 146 │         6.7         3.0          5.2         2.3
 147 │         6.3         2.5          5.0         1.9
 148 │         6.5         3.0          5.2         2.0
 149 │         6.2         3.4          5.4         2.3
 150 │         5.9         3.0          5.1         1.8
                                        132 rows omitted

julia> iris.targets
150×1 DataFrame
 Row │ class          
     │ String15       
─────┼────────────────
   1 │ Iris-setosa
   2 │ Iris-setosa
   3 │ Iris-setosa
   4 │ Iris-setosa
   5 │ Iris-setosa
   6 │ Iris-setosa
   7 │ Iris-setosa
   8 │ Iris-setosa
   9 │ Iris-setosa
  ⋮  │       ⋮
 142 │ Iris-virginica
 143 │ Iris-virginica
 144 │ Iris-virginica
 145 │ Iris-virginica
 146 │ Iris-virginica
 147 │ Iris-virginica
 148 │ Iris-virginica
 149 │ Iris-virginica
 150 │ Iris-virginica
      132 rows omitted
```

## MLUtils compatibility

MLDatasets.jl guarantees compatibility with the [getobs](https://juliaml.github.io/MLUtils.jl/dev/api/#MLUtils.getobs) and [numobs](https://juliaml.github.io/MLUtils.jl/dev/api/#MLUtils.numobs) interface defined in [MLUtils.jl](https://github.com/JuliaML/MLUtils.jl).
In practice, applying `getobs` and `numobs` on datasets is equivalent to applying indexing and `length`.

## Conditional module loading

MLDatasets.jl relies on many different packages in order to load and process the diverse type of datasets it supports. Most likely, any single user of the library will use a limited subset of these functionalities.
In order to reduce the time taken by `using MLDatasets` in users' code,
we use a [lazy import system](https://github.com/johnnychen94/LazyModules.jl) that defers the import of packages inside MLDatasets.jl as much as possible.  
For some of the packages, some manual intervention is needed from the user. 
As an example, the following code will produce an error:

```julia-repl
julia> using MLDataset

julia> MNIST(); # fine, MNIST doesn't require DataFrames

julia> Iris() # ERROR: Add `import DataFrames` or `using DataFrames` to your code to unlock this functionality.
```

We can easily fix the error with an additional import as recommended by the error message:

```julia-repl
julia> using MLDataset, DataFrames

julia> Iris()
dataset Iris:
  metadata    =>    Dict{String, Any} with 4 entries
  features    =>    150×4 DataFrame
  targets     =>    150×1 DataFrame
  dataframe   =>    150×5 DataFrame
```

## Download location

MLDatasets.jl is built on top of the package
[`DataDeps.jl`](https://github.com/oxinabox/DataDeps.jl).
To load the data, the package looks for the necessary files in
various locations (see
[`DataDeps.jl`](https://github.com/oxinabox/DataDeps.jl#configuration)
for more information on how to configure such defaults). If the
data can't be found in any of those locations, then the package
will trigger a download dialog to `~/.julia/datadeps/<DATASETNAME>`. To
overwrite this on a case by case basis, it is possible to specify
a data directory directly in the dataset constructor (e.g. `MNIST(dir = <directory>)`).

In order to download datasets without having to manually confirm the download, 
you can set to true the following environmental variable:

```julia
ENV["DATADEPS_ALWAYS_ACCEPT"] = true
```
