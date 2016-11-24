export UD_English
module UD_English
using ..MLDatasets

const defdir = joinpath(Pkg.dir("MLDatasets"), "datasets/ud_english")

traindata(dir=defdir) = readdata(dir, "en-ud-train.conllu")

devdata(dir=defdir) = readdata(dir, "en-ud-dev.conllu")

testdata(dir=defdir) = readdata(dir, "en-ud-test.conllu")

function readdata(dir, filename)
    mkpath(dir)
    url = "https://raw.githubusercontent.com/UniversalDependencies/UD_English/master"
    path = joinpath(dir, filename)
    isfile(path) || download("$(url)/$(filename)", path)
    CoNLL.read(path)
end

end
