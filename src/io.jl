function read_csv(path; kws...)
    return read_csv_asdf(path; kws...)
end

# function read_csv(path, sink::Type{<:AbstractMatrix{T}}; delim=nothing, kws...) where T
#     x = delim === nothing ? readdlm(path, T; kws...) : readdlm(path, delim, T; kws...)
#     return x
# end

function read_csv(path, sink::Type{A}; kws...) where A <: AbstractMatrix
    A(read_csv(path; kws...))
end

function read_csv_asdf(path; kws...)
    DF = checked_import(idDataFrames).mod.DataFrame
    return checked_import(idCSV).read(path, DF; kws...)
end

function read_npy(path)
    return FileIO.load(File{format"NPY"}(path))
end

function read_npz(path)
    return FileIO.load(File{format"NPZ"}(path))
end

function read_pytorch(path)
    Base.invokelatest(checked_import(idPickle).mod.Torch.THload, path)
end

function read_pickle(path)
    checked_import(idPickle).npyload(path)
end

function read_mat(path)
    checked_import(idMAT).matread(path)
end

function read_json(path)
    Base.invokelatest(open, checked_import(idJSON3).mod.read, path)
end
