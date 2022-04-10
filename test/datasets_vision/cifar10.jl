n_features = (32, 32, 3)
n_targets = 1

@testset "trainset" begin
    d = CIFAR10()

    @test d.split == :train
    @test extrema(d.features) == (0, 1)
    @test convert2image(d, 1) isa AbstractMatrix{<:RGB}
    @test convert2image(d, 1:2) isa AbstractArray{<:RGB,3}

    test_supervised_array_dataset(d;
        n_features, n_targets, n_obs=50000,
        Tx=Float32, Ty=Int)
end

@testset "testset" begin 
    d = CIFAR10(split=:test, Tx=UInt8)

    @test d.split == :test
    @test extrema(d.features) == (0, 255)
    @test convert2image(d, 1) isa AbstractMatrix{<:RGB}
    @test convert2image(d, 1:2) isa AbstractArray{<:RGB,3}

    test_supervised_array_dataset(d;
        n_features, n_targets, n_obs=10000,
        Tx=UInt8, Ty=Int)
end
