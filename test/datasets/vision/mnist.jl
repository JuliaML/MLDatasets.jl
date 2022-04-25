n_features = (28, 28)
n_targets = 1

@testset "trainset" begin
    d = MNIST()

    @test d.split == :train
    @test extrema(d.features) == (0, 1)
    @test convert2image(d, 1) isa AbstractMatrix{<:Gray}
    @test convert2image(d, 1:2) isa AbstractArray{<:Gray, 3}

    test_supervised_array_dataset(d;
        n_features, n_targets, n_obs=60000,
        Tx=Float32, Ty=Int,
        conv2img=true)
end

@testset "testset" begin
    d = MNIST(split=:test, Tx=UInt8)

    @test d.split == :test
    @test extrema(d.features) == (0, 255)
    @test convert2image(d, 1) isa AbstractMatrix{<:Gray}

    test_supervised_array_dataset(d;
        n_features, n_targets, n_obs=10000,
        Tx=UInt8, Ty=Int,
        conv2img=true)

end
