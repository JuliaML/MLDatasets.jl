module CIFAR

using GZip

function gzread(fnames; dirname="cifar10")
    url = "https://www.cs.toronto.edu/~kriz/cifar-10-binary.tar.gz"

    dir = joinpath(Pkg.dir("Merlin"), "dataset", dirname)
    ispath(dir) || mkdir(dir)
    data = Array{Any}(0)
    for filename in fnames
        path = joinpath(dir, "$filename.gz")
        isfile(path) || gzwrite(fnames, dir, url)
        push!(data, gzopen(read,path))
    end
    data
end

function gzwrite(fnames, dir, url)
    filename = split(url, '/')[end]
    gzpath = joinpath(dir, filename)
    isfile(gzpath) || download(url, gzpath)
    run(`tar zxf $(gzpath) -C $(dir)`)
    bindir = joinpath(dir, "cifar-10-batches-bin")
    for filename in fnames
        rpath = joinpath(bindir, "$filename.bin")
        wpath = joinpath(dir, "$filename.gz")
        data = open(read, rpath)
        f = gzopen(wpath, "w")
        for i=1:length(data)
            write(f, data[i])
        end
        close(f)
    end
    run(`rm -rf $bindir`)
    run(`rm $gzpath`)
end

function batread(data)
    x = Array{Float32}(0)
    y = Array{Int}(0)
    for i=1:3073:30730000
        push!(y, Int(data[i]))
        append!(x, data[i+1:i+3072]*Float32(1/255))
    end
    x, y
end

query = Array{String}(0)
for i=1:5
    push!(query, "data_batch_$i")
end
push!(query, "test_batch")
data = gzread(query)

train_x = Array{Float32}(0)
train_y = Array{Int}(0)
for i=1:5
    bat = batread(data[i])
    append!(train_x, bat[1])
    append!(train_y, bat[2])
end
train_x = reshape(train_x, 32, 32, 3, 50000)

test_x, test_y = batread(data[6])
test_x = reshape(test_x, 32, 32, 3, 10000)

end
