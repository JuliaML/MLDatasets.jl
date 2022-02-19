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
TableDataset(path::Union{AbstractPath, AbstractString}) =
    TableDataset(DataFrame(CSV.File(path)))

# slow accesses based on Tables.jl
function MLUtils.getobs(dataset::TableDataset, i)
    if Tables.rowaccess(dataset.table)
        row, _ = Iterators.peel(Iterators.drop(Tables.rows(dataset.table), i - 1))
        return row
    elseif Tables.columnaccess(dataset.table)
        colnames = Tables.columnnames(dataset.table)
        rowvals = [Tables.getcolumn(dataset.table, j)[i] for j in 1:length(colnames)]
        return (; zip(colnames, rowvals)...)
    else
        error("The Tables.jl implementation used should have either rowaccess or columnaccess.")
    end
end
function MLUtils.numobs(dataset::TableDataset)
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
MLUtils.getobs(dataset::TableDataset{<:DataFrame}, i) = dataset.table[i, :]
MLUtils.numobs(dataset::TableDataset{<:DataFrame}) = nrow(dataset.table)

# fast access for CSV.File
MLUtils.getobs(dataset::TableDataset{<:CSV.File}, i) = dataset.table[i]
MLUtils.numobs(dataset::TableDataset{<:CSV.File}) = length(dataset.table)
