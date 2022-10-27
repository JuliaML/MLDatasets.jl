
function read_csv(path; kws...)
    return read_csv_asdf(path; kws...)
end

function read_csv(path, sink::Type{A}; kws...) where A <: AbstractMatrix
    return table_to_matrix(read_csv(path, CSV.File; kws...))
end

function read_csv(path, sink::Type{CSV.File}; kws...)
    return CSV.File(path; kws...)
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
    assert_imported(Pickle._lazy_pkgid)
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

function read_chemfile(path)
    return Chemfiles.Trajectory(path)
end