"""
    TableDataset(table)
    TableDataset(path::AbstractString)

Wrap a Tables.jl-compatible `table` as a dataset container.
Alternatively, specify the `path` to a CSV file directly
to load it with CSV.jl + DataFrames.jl.
"""
struct TableDataset{T} <: AbstractDataContainer
    table::T

    # TableDatasets must implement the Tables.jl interface
    function TableDataset{T}(table::T) where {T}
        Tables.istable(table) ||
            throw(ArgumentError("The input must implement the Tables.jl interface"))

        new{T}(table)
    end
end

TableDataset(table::T) where {T} = TableDataset{T}(table)
TableDataset(path::AbstractString) = TableDataset(read_csv(path))

# slow accesses based on Tables.jl
_getobs_row(x, i) = first(Iterators.peel(Iterators.drop(x, i - 1)))
function _getobs_column(x, i)
    colnames = Tuple(Tables.columnnames(x))
    rowvals = ntuple(j -> Tables.getcolumn(x, j)[i], length(colnames))

    return NamedTuple{colnames}(rowvals)
end

function getobs_table(table, i)
    if Tables.rowaccess(table)
        return _getobs_row(Tables.rows(table), i)
    elseif Tables.columnaccess(table)
        return _getobs_column(table, i)
    else
        error("The Tables.jl implementation used should have either rowaccess or columnaccess.")
    end
end

function numobs_table(table)
    if Tables.columnaccess(table)
        return length(Tables.getcolumn(table, 1))
    elseif Tables.rowaccess(table)
        # length might not be defined, but has to be for this to work.
        return length(Tables.rows(table))
    else
        error("The Tables.jl implementation used should have either rowaccess or columnaccess.")
    end
end

Base.getindex(dataset::TableDataset, i) = getobs_table(dataset.table, i)
Base.length(dataset::TableDataset) = numobs_table(dataset.table)


# fast access for DataFrame
# Base.getindex(dataset::TableDataset{<:DataFrame}, i) = dataset.table[i, :]
# Base.length(dataset::TableDataset{<:DataFrame}) = nrow(dataset.table)

# fast access for CSV.File
# Base.getindex(dataset::TableDataset{<:CSV.File}, i) = dataset.table[i]
# Base.length(dataset::TableDataset{<:CSV.File}) = length(dataset.table)

## Tables.jl interface

Tables.istable(::TableDataset) = true

for fn in (:rowaccess, :rows, :columnaccess, :columns, :schema, :materializer)
    @eval Tables.$fn(dataset::TableDataset) = Tables.$fn(dataset.table)
end
