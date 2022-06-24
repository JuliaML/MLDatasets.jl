module ImageNetReader
using ImageCore: channelview, colorview, AbstractRGB, RGB

import ..FileDataset
import ..read_mat
import ..@lazy

@lazy import JpegTurbo = "b835a17e-a41a-41e7-81f0-2f016b05efe0"

const NCLASSES = 1000
const IMGSIZE = (224, 224)

include("preprocess.jl")

function read_metadata(file::AbstractString)
    meta = read_mat(file)["synsets"]
    is_child = iszero.(meta["num_children"])
    @assert meta["ILSVRC2012_ID"][is_child] == 1:NCLASSES

    metadata = Dict{String,Any}()
    metadata["class_WNIDs"] = Vector{String}(meta["WNID"][is_child]) # WordNet IDs
    metadata["class_names"] = split.(meta["words"][is_child], ", ")
    metadata["class_description"] = Vector{String}(meta["gloss"][is_child])
    metadata["wnid_to_label"] = Dict(metadata["class_WNIDs"] .=> 1:NCLASSES)
    return metadata
end

# The full ImageNet dataset doesn't fit into memory, so we only save filenames
function readdata(Tx::Type{<:Real}, dir::AbstractString)
    return FileDataset(image_loader(Tx), dir, "*.JPEG")
end

# Get WordNet ID from path
load_wnids(d::FileDataset) = load_wnids(d.paths)
load_wnids(fs::AbstractVector{<:AbstractString}) = [split(f, "/")[end - 1] for f in fs]

# Construct a function that loads images from FileDataset path
# and preprocess it to normalized 224x224x3 Array{Tx,3}
function image_loader(Tx::Type{<:Real})
    function load_image(file::AbstractString)::AbstractArray{Tx,3}
        im = JpegTurbo.jpeg_decode(RGB{Tx}, file; preferred_size=IMGSIZE)
        return preprocess(Tx, im)
    end
    return load_image
end

end # module
