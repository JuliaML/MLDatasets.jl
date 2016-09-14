export PTBLM
module PTBLM

const defdir = joinpath(Pkg.dir("MLDatasets"), "datasets/ptblm")

function traindata(dir=defdir)
    readdata(dir, "ptb.train.txt")
end

function testdata(dir=defdir)
    readdata(dir, "ptb.test.txt")
end

function readdata(dir, filename)
    mkpath(dir)
    url = "https://raw.githubusercontent.com/tomsercu/lstm/master/data"
    path = joinpath(dir, filename)
    isfile(path) || download("$(url)/$(filename)", path)
    lines = open(readlines, path)
    data = map(l -> strip(chomp(l)), lines)
    data
end

end
