export CIFAR100
module CIFAR100

using BinDeps

const defdir = joinpath(Pkg.dir("MLDatasets"), "datasets", "cifar100")

function getdata(dir)
    mkpath(dir)
    path = download("https://www.cs.toronto.edu/~kriz/cifar-100-binary.tar.gz")
    run(unpack_cmd(path,dir,".gz",".tar"))
end

function readdata(data::Vector{UInt8})
    n = Int(length(data)/3074)
    x = Array(Float64, 3072, n)
    y = Array(Int, 2, n)
    for i = 1:n
        k = (i-1) * 3074 + 1
        y[:,i] = data[k:k+1]
        x[:,i] = data[k+2:k+3073] / 255
    end
    x = reshape(x, 32, 32, 3, n)
    x, y
end

function traindata(dir=defdir)
    file = joinpath(dir,"cifar-100-binary", "train.bin")
    isfile(file) || getdata(dir)
    readdata(open(read,file))
end

function testdata(dir=defdir)
    file = joinpath(dir,"cifar-100-binary", "test.bin")
    isfile(file) || getdata(dir)
    readdata(open(read,file))
end

end
