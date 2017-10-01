export PTBLM
module PTBLM

const defdir = joinpath(Pkg.dir("MLDatasets"), "datasets", "ptblm")

function traindata(dir=defdir)
    xs = readdata(dir, "ptb.train.txt")
    ys = makeys(xs)
    xs, ys
end

function testdata(dir=defdir)
    xs = readdata(dir, "ptb.test.txt")
    ys = makeys(xs)
    xs, ys
end

function readdata(dir, filename)
    mkpath(dir)
    url = "https://raw.githubusercontent.com/tomsercu/lstm/master/data"
    path = joinpath(dir, filename)
    isfile(path) || download("$(url)/$(filename)", path)
    lines = open(readlines, path)
    map(l -> Vector{String}(split(chomp(l))), lines)
end

function makeys(xs::Vector{Vector{String}})
    map(xs) do x
        y = copy(x)
        shift!(y)
        push!(y, "<eos>")
    end
end

end
