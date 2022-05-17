
function read_csv(path; kws...)
    return read_csv_asdf(path; kws...)
end

# function read_csv(path, sink::Type{<:AbstractMatrix{T}}; delim=nothing, kws...) where T
#     x = delim === nothing ? readdlm(path, T; kws...) : readdlm(path, delim, T; kws...)
#     return x
# end

function read_csv(path, sink::Type{A}; kws...) where A <: AbstractMatrix
    return A(read_csv(path; kws...))
end

function read_csv_asdf(path; kws...)
    return CSV.read(path, DataFrames.DataFrame; kws...)
end

function read_npy(path)
    return FileIO.load(File{format"NPY"}(path)) # FileIO does lazy import of NPZ.jl
end

function read_npz(path)
    return FileIO.load(File{format"NPZ"}(path)) # FileIO does lazy import of NPZ.jl
end

function read_pytorch(path)
    return Pickle.Torch.THload(path)
end

function read_pickle(path)
    return Pickle.npyload(path)
end

function read_mat(path)
    return MAT.matread(path)
end

function read_json(path)
    return open(JSON3.read, path)
end
