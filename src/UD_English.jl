export UD_English
module UD_English
using ..MLDatasets

const defdir = joinpath(Pkg.dir("MLDatasets"), "datasets/ud_english")

traindata(dir=defdir; col=Int[]) = readdata(dir, "en-ud-train.conllu", col)

devdata(dir=defdir; col=Int[]) = readdata(dir, "en-ud-dev.conllu", col)

testdata(dir=defdir; col=Int[]) = readdata(dir, "en-ud-test.conllu", col)

function readdata(dir, filename, col)
    mkpath(dir)
    url = "https://raw.githubusercontent.com/UniversalDependencies/UD_English/master"
    path = joinpath(dir, filename)
    isfile(path) || download("$(url)/$(filename)", path)
    CoNLL.read(path, col)
end

end
