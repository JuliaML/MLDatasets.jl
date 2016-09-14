export CIFAR10
module CIFAR10

using BinDeps

const defdir = joinpath(Pkg.dir("MLDatasets"), "datasets/cifar10")

function getdata(dir)
    mkpath(dir)
    path = download("https://www.cs.toronto.edu/~kriz/cifar-10-binary.tar.gz")
    run(unpack_cmd(path,dir,".gz",".tar"))
end

function readdata(data::Vector{UInt8})
    n = Int(length(data)/3073)
    x = Array(Float64, 3072, n)
    y = Array(Int, n)
    for i = 1:n
        k = (i-1) * 3073 + 1
        y[i] = Int(data[k])
        x[:,i] = data[k+1:k+3072] / 255
    end
    x = reshape(x, 32, 32, 3, n)
    x, y
end

function traindata(dir=defdir)
    files = ["$(dir)/cifar-10-batches-bin/data_batch_$(i).bin" for i=1:5]
    all(isfile, files) || getdata(dir)
    data = UInt8[]
    for file in files
        append!(data, open(read,file))
    end
    readdata(data)
end

function testdata(dir=defdir)
    file = "$(dir)/cifar-10-batches-bin/test_batch.bin"
    isfile(file) || getdata(dir)
    readdata(open(read,file))
end

end
