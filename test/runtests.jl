using Test
using MLDatasets

module MLDatasetsTestUtils
export isCI

# detect whether the tests are running in CI environment
isCI() = parse(Bool, get(ENV, "CI", "false"))
end # module

@testset "CIFAR10" begin
    include("tst_cifar10.jl")
end
@testset "CIFAR100" begin
    include("tst_cifar100.jl")
end
@testset "MNIST" begin
    include("tst_mnist.jl")
end
@testset "FashionMNIST" begin
    include("tst_fashion_mnist.jl")
end
@testset "SVHN2" begin
    include("tst_svhn2.jl")
end

using .MLDatasetsTestUtils

# temporary to not stress CI
if !isCI()
    @testset "PTBLM" begin
        x, y = PTBLM.traindata()
        x, y = PTBLM.testdata()
    end

    @testset "UD_English" begin
        x = UD_English.traindata()
        x = UD_English.devdata()
        x = UD_English.testdata()
    end
end

nothing
