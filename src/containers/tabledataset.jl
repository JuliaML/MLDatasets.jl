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
            throw(ArgumentError("TableDatasets must implement the Tabels.jl interface"))

        new{T}(table)
    end
end

TableDataset(table::T) where {T} = TableDataset{T}(table)
TableDataset(path::AbstractString) = TableDataset(DataFrame(CSV.File(path)))

# slow accesses based on Tables.jl
_getobs_row(x, i) = first(Iterators.peel(Iterators.drop(x, i - 1)))
function _getobs_column(x, i)
    colnames = Tuple(Tables.columnnames(x))
    rowvals = ntuple(j -> Tables.getcolumn(x, j)[i], length(colnames))

    return NamedTuple{colnames}(rowvals)
end
function Base.getindex(dataset::TableDataset, i)
    if Tables.rowaccess(dataset.table)
        return _getobs_row(Tables.rows(dataset.table), i)
    elseif Tables.columnaccess(dataset.table)
        return _getobs_column(dataset.table, i)
    else
        error("The Tables.jl implementation used should have either rowaccess or columnaccess.")
    end
end
function Base.length(dataset::TableDataset)
    if Tables.columnaccess(dataset.table)
        return length(Tables.getcolumn(dataset.table, 1))
    elseif Tables.rowaccess(dataset.table)
        # length might not be defined, but has to be for this to work.
        return length(Tables.rows(dataset.table))
    else
        error("The Tables.jl implementation used should have either rowaccess or columnaccess.")
    end
end

# fast access for DataFrame
Base.getindex(dataset::TableDataset{<:DataFrame}, i) = dataset.table[i, :]
Base.length(dataset::TableDataset{<:DataFrame}) = nrow(dataset.table)

# fast access for CSV.File
Base.getindex(dataset::TableDataset{<:CSV.File}, i) = dataset.table[i]
Base.length(dataset::TableDataset{<:CSV.File}) = length(dataset.table)
