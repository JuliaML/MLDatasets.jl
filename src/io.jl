read_csv(path; kws...) = read_csv(path, DataFrame; kws...)

# function read_csv(path, sink::Type{<:AbstractMatrix{T}}; delim=nothing, kws...) where T
#     x = delim === nothing ? readdlm(path, T; kws...) : readdlm(path, delim, T; kws...)
#     return x
# end

function read_csv(path, sink::Type{A}; kws...) where A <: AbstractMatrix
    A(read_csv(path; kws...))
end

function read_csv(path, sink::Type{<:DataFrame}; kws...)
    return CSV.read(path, sink; kws...)
end

function read_npy(path)
    return Pickle.npyload(path)
end

function read_npz(path)
    return NPZ.npzread(path)
end

function read_pytorch(path)
    return Pickle.Torch.THload(path)
end
