"""
    AbstractDataset

Super-type from which all datasets in MLDatasets.jl inherit.

Implements the following functionality:
- `getobs(d)` and `getobs(d, i)` falling back to `d[:]` and `d[i]` 
- Pretty printing.
"""
abstract type AbstractDataset <: AbstractDataContainer end

MLUtils.getobs(d::AbstractDataset) = d[:]
MLUtils.getobs(d::AbstractDataset, i) = d[i]

function Base.show(io::IO, d::D) where {D <: AbstractDataset}
    print(io, "$(D.name.name)()")
end

function Base.show(io::IO, ::MIME"text/plain", d::D) where {D <: AbstractDataset}
    recur_io = IOContext(io, :compact => false)

    print(io, "dataset $(D.name.name):")  # if the type is parameterized don't print the parameters

    fnames = filter(!startswith("_"), string.(fieldnames(D)))
    f_length = max(length.(fnames)...)
    for f in fnames
        fstring = leftalign(f, f_length)
        print(recur_io, "\n  $fstring  =>    ")
        # show(recur_io, MIME"text/plain"(), getfield(d, f))
        # println(recur_io)
        print(recur_io, "$(_summary(getfield(d, Symbol(f))))")
    end
end

function leftalign(s::AbstractString, n::Int)
    m = length(s)
    if m > n
        return s[1:n]
    else
        return s * repeat(" ", n - m)
    end
end

_summary(x) = Tables.istable(x) ? summary(x) : x
_summary(x::Symbol) = ":$x"
_summary(x::Dict) = summary(x)
_summary(x::Tuple) = map(_summary, x)
_summary(x::NamedTuple) = map(_summary, x)
_summary(x::AbstractArray) = summary(x)
_summary(x::BitVector) = "$(count(x))-trues BitVector"

"""
    SupervisedDataset <: AbstractDataset

An abstract dataset type for supervised learning tasks. 
Concrete dataset types inheriting from it must provide
a `features` and a `targets` fields.
"""
abstract type SupervisedDataset <: AbstractDataset end

function Base.length(d::SupervisedDataset)
    Tables.istable(d.features) ? numobs_table(d.features) :
    numobs((d.features, d.targets))
end

# We return named tuples
function Base.getindex(d::SupervisedDataset, ::Colon)
    Tables.istable(d.features) ?
    (features = d.features, targets = d.targets) :
    getobs((; d.features, d.targets))
end

function Base.getindex(d::SupervisedDataset, i)
    Tables.istable(d.features) ?
    (features = getobs_table(d.features, i), targets = getobs_table(d.targets, i)) :
    getobs((; d.features, d.targets), i)
end

"""
    UnsupervisedDataset <: AbstractDataset

An abstract dataset type for unsupervised or self-supervised learning tasks. 
Concrete dataset types inheriting from it must provide a `features` field.
"""
abstract type UnsupervisedDataset <: AbstractDataset end

Base.length(d::UnsupervisedDataset) = numobs(d.features)

Base.getindex(d::UnsupervisedDataset, ::Colon) = getobs(d.features)
Base.getindex(d::UnsupervisedDataset, i) = getobs(d.features, i)

### DOCSTRING TEMPLATES ######################

# SUPERVISED TABLE
const ARGUMENTS_SUPERVISED_TABLE = """
- If `as_df = true`, load the data as dataframes instead of plain arrays.

- You can pass a specific `dir` where to load or download the dataset, otherwise uses the default one.
"""

const FIELDS_SUPERVISED_TABLE = """
- `metadata`: A dictionary containing additional information on the dataset.
- `features`: The data features. An array if `as_df=false`, otherwise a dataframe.
- `targets`: The targets for supervised learning. An array if `as_df=false`, otherwise a dataframe.
- `dataframe`: A dataframe containing both `features` and `targets`. It is `nothing` if `as_df=false`, otherwise a dataframed.
"""

const METHODS_SUPERVISED_TABLE = """
- `dataset[i]`: Return observation(s) `i` as a named tuple of features and targets.
- `dataset[:]`: Return all observations as a named tuple of features and targets.
- `length(dataset)`: Number of observations.
"""

# SUPERVISED ARRAY DATASET

const ARGUMENTS_SUPERVISED_ARRAY = """
- You can pass a specific `dir` where to load or download the dataset, otherwise uses the default one.
"""

const FIELDS_SUPERVISED_ARRAY = """
- `metadata`: A dictionary containing additional information on the dataset.
- `features`: An array storing the data features.
- `targets`: An array storing the targets for supervised learning.
"""

const METHODS_SUPERVISED_ARRAY = """
- `dataset[i]`: Return observation(s) `i` as a named tuple of features and targets.
- `dataset[:]`: Return all observations as a named tuple of features and targets.
- `length(dataset)`: Number of observations.
"""
