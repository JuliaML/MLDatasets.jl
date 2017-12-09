export Food101
module Food101

using BinDeps
using Images
import JSON
import MLDataPattern: nobs, getobs

const datadir = joinpath(Pkg.dir("MLDatasets"), "datasets")
const defdir = joinpath(datadir, "food-101")

const DEFAULT_SIZE = (512, 512)

function getdata(dir=datadir)
    mkpath(dir)
    path = download("http://data.vision.ee.ethz.ch/cvl/food-101.tar.gz")
    run(unpack_cmd(path,dir,".gz",".tar"))
end


struct Food101Dataset
    dir::AbstractString               # base directory
    files::Vector{String}             # list of files to use
    opts::Dict{Symbol, Any}           # dataset options, e.g. image size
end


function Food101Dataset(dir::AbstractString, classes::Set{String}, train=true; opts...)
    isdir(dir) || getdata(dir)
    meta_file = train ? "train.json" : "test.json"
    meta = open(JSON.parse, joinpath(defdir, "meta", meta_file))
    meta = isempty(classes) ? meta : Dict(k => v for (k, v) in meta if k in classes)
    files = vcat(values(meta)...)

    return Food101Dataset(dir, files, Dict(opts))
end


struct Food101Data
    dataset::Food101Dataset
end
Base.show(io::IO, X::Food101Data) = print(io, "Food101Data()")

struct Food101Targets
    dataset::Food101Dataset
end
Base.show(io::IO, X::Food101Targets) = print(io, "Food101Targets()")



## data

function getobs!(buf::AbstractArray{UInt8,3}, data::Food101Data, idx::Integer)
    ds = data.dataset
    path = joinpath(ds.dir, "images", ds.files[idx] * ".jpg")
    sz = get(data.dataset.opts, :size, DEFAULT_SIZE)
    im_ = nothing
    try
        im_ = load(path)
        im = imresize(im_, sz)
        buf .= permutedims(rawview(channelview(im)), (2,3,1))
    catch e
        warn("Can't load $path", e)
        buf .= zeros(UInt8, sz..., 3)
    end
    return buf
end


function getobs!(buf::AbstractArray{UInt8,4}, data::Food101Data, idxs::AbstractVector{<:Integer})
    for (i, idx) in enumerate(idxs)
        getobs!(@view(buf[:,:,:,i]), data, idx)
    end
    return buf
end

function getobs(data::Food101Data, idx::Integer)
    sz = get(data.dataset.opts, :size, DEFAULT_SIZE)
    getobs!(Array{UInt8}(sz..., 3), data, idx)
end

function getobs(data::Food101Data, idxs::AbstractVector{<:Integer})
    sz = get(data.dataset.opts, :size, DEFAULT_SIZE)
    getobs!(Array{UInt8,4}(sz..., 3, length(idxs)), data, idxs)
end

Base.getindex(data::Food101Data, idx) = getobs(data, idx)

nobs(data::Food101Data) = length(data.dataset.files)
Base.length(data::Food101Data) = nobs(data)
Base.endof(data::Food101Data) = nobs(data)


## targets


function getobs(targets::Food101Targets, idx::Integer)
    ds = targets.dataset
    return dirname(targets.dataset.files[idx])
end


function getobs(targets::Food101Targets, idxs::AbstractVector{<:Integer})
    ret = Vector{String}(length(idxs))
    for idx in idxs
        ret[idx] = getobs(targets, idx)
    end
    return ret
end

Base.getindex(data::Food101Targets, idx) = getobs(data, idx)

nobs(targets::Food101Targets) = length(targets.dataset.files)
Base.length(targets::Food101Targets) = nobs(targets)
Base.endof(targets::Food101Targets) = nobs(targets)


## interface

function traindata(dir=defdir; classes=[], opts...)
    dataset = Food101Dataset(dir, Set{String}(classes), true; opts...)
    return Food101Data(dataset), Food101Targets(dataset)
end


function testdata(dir=defdir; classes=[], opts...)
    dataset = Food101Dataset(dir, Set{String}(classes), false; opts...)
    return Food101Data(dataset), Food101Targets(dataset)
end


end
