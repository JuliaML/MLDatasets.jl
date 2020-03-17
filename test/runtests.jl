using Test
using MLDatasets
using ImageCore

tests = [
    "tst_iris.jl",
    "tst_cifar10.jl",
    "tst_cifar100.jl",
    "tst_mnist.jl",
    "tst_fashion_mnist.jl",
    "tst_svhn2.jl",
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
