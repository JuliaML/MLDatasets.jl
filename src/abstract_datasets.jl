abstract type AbstractDataset <: AbstractDataContainer end

function Base.show(io::IO, d::D) where D <: AbstractDataset
    recur_io = IOContext(io, :compact => false)
    
    print(io, "$D:")
    
    for f in fieldnames(D)
        if !startswith(string(f), "_")
            print(recur_io, "\n  $f => ")
            # show(recur_io, MIME"text/plain"(), getfield(d, f))
            # println(recur_io)
            print(recur_io, "$(_summary(getfield(d, f)))")
        end
    end
end

_summary(x) = x
_summary(x::Union{Dict, AbstractArray, DataFrame}) = summary(x)

"""
    abstract type SupervisedDataset <: AbstractDataset end

An abstract dataset type for supervised learning tasks. 
Concrete dataset types inheriting from it must provide
a `features` and a `targets` fields.
"""
abstract type SupervisedDataset <: AbstractDataset end

Base.length(d::SupervisedDataset) = numobs((d.features, d.targets))
Base.getindex(d::SupervisedDataset) = getobs((d.features, d.targets))
Base.getindex(d::SupervisedDataset, i) = getobs((d.features, d.targets), i)


### DOCSTRING TEMPLATES ######################

const ARGUMENTS_SUPERVISED_TABLE = """
If `as_df = true`, load the data as dataframes instead of plain arrays.

You can pass a specific `dir` where to download the dataset, otherwise uses
the default one.
"""

const FIELDS_SUPERVISED_TABLE = """
- `metadata`: A dictionary containing additional information on the dataset.
- `features`: The data features. An array if `as_df=true`, otherwise a dataframe. 
- `targets`: The targets for supervised learning. An array if `as_df=true`, otherwise a dataframe.
- `dataframe`: A dataframe containing both `features` and `targets`. It is `nothing` if `as_df=false`.
"""

const METHODS_SUPERVISED_TABLE = """
- `dataset[i]`: Return observation(s) `i` as a tuple of features and targets . 
- `dataset[]`: Return all observations as a tuple of features and targets.
- `length(dataset)`: Number of observations.
"""