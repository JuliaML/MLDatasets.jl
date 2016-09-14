export MNIST
module MNIST

using GZip

const defdir = joinpath(Pkg.dir("MLDatasets"), "datasets/mnist")

"""
* [dir]: save directory. Default: "MLDatasets/datasets/mnist"
"""
function traindata(dir=defdir)
    x = gzread(dir,"train-images-idx3-ubyte.gz")[17:end]
    x = reshape(x/255, 28, 28, 60000)
    y = gzread(dir,"train-labels-idx1-ubyte.gz")[9:end]
    y = Vector{Int}(y)
    x, y
end

"""
* [dir]: save directory. Default: "MLDatasets/datasets/mnist"
"""
function testdata(dir=defdir)
    data = gzread(dir,"t10k-images-idx3-ubyte.gz")[17:end]
    x = reshape(data/255, 28, 28, 10000)
    data = gzread(dir,"t10k-labels-idx1-ubyte.gz")[9:end]
    y = Vector{Int}(data)
    x, y
end

function gzread(dir, filename)
    mkpath(dir)
    url = "http://yann.lecun.com/exdb/mnist"
    path = joinpath(dir, filename)
    isfile(path) || download("$(url)/$(filename)", path)
    f = gzopen(path)
    data = read(f)
    close(f)
    data
end

end
