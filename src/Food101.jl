export Food101
module Food101

using BinDeps
using Images
import JSON
import MLDataPattern: nobs, getobs

const datadir = joinpath(Pkg.dir("MLDatasets"), "datasets")
const defdir = joinpath(datadir, "food-101")


function getdata(dir=datadir)
    mkpath(dir)
    path = download("http://data.vision.ee.ethz.ch/cvl/food-101.tar.gz")
    run(unpack_cmd(path,dir,".gz",".tar"))
end


struct Food101Dataset
    dir::AbstractString
    files::Vector{String}
end


function Food101Dataset(dir::AbstractString, classes::Set{String}, train=true)
    isdir(dir) || getdata(dir)
    meta_fiile = train ? "train.json" : "test.json"
    meta = open(JSON.parse, joinpath(defdir, "meta", "train.json"))    
    meta = isempty(classes) ? meta : Dict(k => v for (k, v) in meta if k in classes)
    files = vcat(values(meta)...)
    return Food101Dataset(dir, files)
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

function getobs(data::Food101Data, idx::Integer)
    ds = data.dataset
    path = joinpath(ds.dir, "images", ds.files[idx] * ".jpg")
    return permutedims(rawview(channelview(im)), (2,3,1))    
end


function getobs(data::Food101Data, idxs::Union{Vector{<:Integer}, UnitRange{<:Integer}})
    ret = Array{UInt8,4}(512, 512, 3, length(idxs))
    for idx in idxs
        ret[:,:,:,idx] = getobs(data, idx)
    end
    return ret
end


nobs(data::Food101Data) = length(data.dataset.files)


## targets

function getobs(targets::Food101Targets, idx::Integer)
    ds = targets.dataset
    return dirname(targets.dataset.files[idx])
end


function getobs(targets::Food101Targets, idxs::Union{Vector{<:Integer}, UnitRange{<:Integer}})
    ret = Vector{String}(length(idxs))
    for idx in idxs
        ret[idx] = getobs(targets, idx)
    end
    return ret
end

nobs(targets::Food101Targets) = length(targets.dataset.files)


## interface

function traindata(dir=defdir; classes=[])
    dataset = Food101Dataset(dir, Set{String}(classes), true)
    return Food101Data(dataset), Food101Targets(dataset)
end


function testdata(dir=defdir; classes=[])
    dataset = Food101Dataset(dir, Set{String}(classes), false)
    return Food101Data(dataset), Food101Targets(dataset)
end


end
