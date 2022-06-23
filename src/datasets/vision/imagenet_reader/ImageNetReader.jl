module ImageNetReader
import ..read_mat
import ..read_jpg

include("preprocess.jl")

const NCLASSES = 1000

function read_metadata(file::AbstractString)
    meta = read_mat(file)["synsets"]
    is_child = iszero.(meta["num_children"])
    @assert meta["ILSVRC2012_ID"][is_child] == 1:NCLASSES

    metadata = Dict{String,Any}()
    metadata["class_WNID"] = Vector{String}(meta["WNID"][is_child]) # WordNet IDs
    metadata["class_names"] = split.(meta["words"][is_child], ", ")
    metadata["class_description"] = Vector{String}(meta["gloss"][is_child])
    return metadata
end

# The full ImageNet dataset doesn't fit into memory, so we only save filenames
struct ImageNetFile
    path::String
    ID::Int # class ID
    WNID::String # WordNet ID
end

# Load file paths and labels/WNIDs of the entire dataset split in `dir`.
function readdata(
    dir::AbstractString, wnids::AbstractVector{<:AbstractString}
)::Vector{ImageNetFile}
    return reduce(vcat, readfolder(dir, i, w) for (i, w) in enumerate(wnids))
end

function readfolder(
    split_dir::AbstractString, id::Integer, wnid::AbstractString
)::Vector{ImageNetFile}
    path = joinpath(split_dir, wnid)
    img_paths = filter!(isfile, readdir(path; join=true))
    return [ImageNetFile(p, id, wnid) for p in img_paths]
end

# Load image from ImageNetFile path and preprocess it to normalized 224x224x3 Array{Tx,3}
function readimage(Tx::Type, i::ImageNetFile)
    im = read_jpg(i.path)
    return preprocess(Tx, im)
end

# Load batched array of images
cat_batchdim(xs...) = cat(xs...; dims=4)
function readimage(Tx::Type, is::AbstractVector{ImageNetFile})
    return reduce(cat_batchdim, readimage(Tx, i) for i in is)
end

end # module
