function __init__matminer()
    DEPNAME = "MatMiner"
    DOCS = "https://hackingmaterials.lbl.gov/matminer/"

    register(ManualDataDep(
        DEPNAME,
        """
        Datahub: $DEPNAME.
        Website: $DOCS
        """,
    ))
end

"""
    MatMiner(name; dir=nothing)


# Examples
    
```julia
data = MatMiner("steels")
```
"""
struct MatMiner <: AbstractDataset
    name::String
    metadata
    data
end

function MatMiner(name::String; dir=nothing)
    jsondata, metadata, dir = matminer_getdata(name; dir)
    data = JSON3.copy(jsondata)
    metadata = JSON3.copy(metadata)
    return MatMiner(name, metadata, data)
end

function matminer_metadata(mmdir)
    LINK = "https://raw.githubusercontent.com/hackingmaterials/matminer/main/matminer/datasets/dataset_metadata.json"
    path = joinpath(mmdir, "dataset_metadata.json")
    if !isfile(path)
        DataDeps.fetch_default(LINK, mmdir)
    end
    @assert isfile(path)
    return read_json(path)
end

function matminer_getdata(name; dir = nothing)
    create_default_dir("MatMiner")
    mmdir = isnothing(dir) ? datadep"MatMiner" : dir
    metadata = matminer_metadata(mmdir)
    @assert name in keys(metadata) "Dataset $name not found among $(string.(keys(metadata)))"
    if !isdir(joinpath(mmdir, name))
        mkdir(joinpath(mmdir, name))
    end
    dir = joinpath(mmdir, name) 
    url = metadata[name]["url"]
    @assert metadata[name]["file_type"] == "json.gz"
    filepath = joinpath(dir, name * ".json")
    if !isfile(filepath)
        DataDeps.fetch_default(url, dir)
        currdir = pwd()
        cd(dir) # Needed since `unpack` extracts in working dir
        DataDeps.unpack(filepath * ".gz")
        cd(currdir)
    end
    jsondata = read_json(filepath)
    return jsondata, metadata, dir
end
