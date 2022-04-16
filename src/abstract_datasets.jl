abstract type AbstractDataset <: AbstractDataContainer end

function Base.show(io::IO, d::D) where D <: AbstractDataset
    recur_io = IOContext(io, :compact => false)
    
    print(io, "$(D.name.name):")  # if the type is parameterized don't print the parameters
    
    for f in fieldnames(D)
        if !startswith(string(f), "_")
            fstring = leftalign(string(f), 10)
            print(recur_io, "\n  $fstring  =>    ")
            # show(recur_io, MIME"text/plain"(), getfield(d, f))
            # println(recur_io)
            print(recur_io, "$(_summary(getfield(d, f)))")
        end
    end
end

function leftalign(s::AbstractString, n::Int)
    m = length(s) 
    if m > n
        return s[1:n]
    else
        return s * repeat(" ", n-m)
    end
end

_summary(x) = x
_summary(x::Symbol) = ":$x"
_summary(x::Union{Dict, AbstractArray, DataFrame}) = summary(x)
_summary(x::Union{Tuple, NamedTuple}) = map(summary, x)

"""
    abstract type SupervisedDataset <: AbstractDataset end

An abstract dataset type for supervised learning tasks. 
Concrete dataset types inheriting from it must provide
a `features` and a `targets` fields.
"""
abstract type SupervisedDataset <: AbstractDataset end



Base.length(d::SupervisedDataset) = numobs((d.features, d.targets))

# We return named tuples
Base.getindex(d::SupervisedDataset) = getobs((; d.features, d.targets)) 
Base.getindex(d::SupervisedDataset, i) = getobs((; d.features, d.targets), i)

"""
    abstract type UnsupervisedDataset <: AbstractDataset end

An abstract dataset type for unsupervised or self-supervised learning tasks. 
Concrete dataset types inheriting from it must provide
a `features` field.
"""
abstract type UnsupervisedDataset <: AbstractDataset end


Base.length(d::UnsupervisedDataset) = numobs(d.features)

Base.getindex(d::UnsupervisedDataset) = getobs(d.features) 
Base.getindex(d::UnsupervisedDataset, i) = getobs(d.features, i)


### DOCSTRING TEMPLATES ######################

# SUPERVISED TABLE
const ARGUMENTS_SUPERVISED_TABLE = """
- If `as_df = true`, load the data as dataframes instead of plain arrays.

- You can pass a specific `dir` where to load or download the dataset, otherwise uses
the default one.
"""

const FIELDS_SUPERVISED_TABLE = """
- `metadata`: A dictionary containing additional information on the dataset.
- `features`: The data features. An array if `as_df=true`, otherwise a dataframe. 
- `targets`: The targets for supervised learning. An array if `as_df=true`, otherwise a dataframe.
- `dataframe`: A dataframe containing both `features` and `targets`. It is `nothing` if `as_df=false`.
"""

const METHODS_SUPERVISED_TABLE = """
- `dataset[i]`: Return observation(s) `i` as a named tuple of features and targets . 
- `dataset[]`: Return all observations as a named tuple of features and targets.
- `length(dataset)`: Number of observations.
"""


# SUPERVISED ARRAY DATASET

const ARGUMENTS_SUPERVISED_ARRAY = """
- You can pass a specific `dir` where to load or download the dataset, otherwise uses
the default one.
"""

const FIELDS_SUPERVISED_ARRAY = """
- `metadata`: A dictionary containing additional information on the dataset.
- `features`: An array storing the data features. 
- `targets`: An array storing the targets for supervised learning.
"""

const METHODS_SUPERVISED_ARRAY = """
- `dataset[i]`: Return observation(s) `i` as a named tuple of features and targets . 
- `dataset[]`: Return all observations as a named tuple of features and targets.
- `length(dataset)`: Number of observations.
"""
