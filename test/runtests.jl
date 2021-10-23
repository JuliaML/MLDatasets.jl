using Test
using MLDatasets
using ImageCore
using DataDeps


ENV["DATADEPS_ALWAYS_ACCEPT"] = true

tests = [
    # misc
    "tst_iris.jl",
    "tst_boston_housing.jl",
    "tst_mutagenesis.jl",
    # vision
    "tst_cifar10.jl",
    "tst_cifar100.jl",
    "tst_mnist.jl",
    "tst_fashion_mnist.jl",
    "tst_svhn2.jl",
    "tst_emnist.jl",
    # graphs    
    "tst_citeseer.jl",
    "tst_cora.jl",
    "tst_pubmed.jl",
    "tst_tudataset.jl",
]

for t in tests
    @testset "$t" begin
        include(t)
    end
end

#temporary to not stress CI
if !parse(Bool, get(ENV, "CI", "false"))
    @testset "other tests" begin
        # PTBLM
        x, y = PTBLM.traindata()
        x, y = PTBLM.testdata()

        # UD_English
        x = UD_English.traindata()
        x = UD_English.devdata()
        x = UD_English.testdata()
    end
end
nothing
