n_features = (105, 105)
n_targets = 1

@testset "trainset" begin
    d = Omniglot()

    @test d.split == :train
    @test extrema(d.features) == (0, 1)
    @test convert2image(d, 1) isa AbstractMatrix{<:Gray}
    @test convert2image(d, 1:2) isa AbstractArray{<:Gray, 3}

    test_supervised_array_dataset(d;
                                  n_features, n_targets, n_obs = 19280,
                                  Tx = Float32, Ty = String,
                                  conv2img = true)

    d = Omniglot(:train)
    @test d.split == :train
    d = Omniglot(Int)
    @test d.split == :train
    @test d.features isa Array{Int}
end

@testset "testset" begin
    d = Omniglot(split = :test, Tx = UInt8)

    @test d.split == :test
    @test extrema(d.features) == (0, 1)
    @test convert2image(d, 1) isa AbstractMatrix{<:Gray}

    test_supervised_array_dataset(d;
                                  n_features, n_targets, n_obs = 13180,
                                  Tx = UInt8, Ty = String,
                                  conv2img = true)

    d = Omniglot(:test)
    @test d.split == :test
    d = Omniglot(Int, :test)
    @test d.split == :test
    @test d.features isa Array{Int}
end

@testset "small1set" begin
    d = Omniglot(split = :small1, Tx = Float32)

    @test d.split == :small1
    @test extrema(d.features) == (0, 1)
    @test convert2image(d, 1) isa AbstractMatrix{<:Gray}

    test_supervised_array_dataset(d;
                                  n_features, n_targets, n_obs = 2720,
                                  Tx = Float32, Ty = String,
                                  conv2img = true)

    d = Omniglot(:small1)
    @test d.split == :small1
    d = Omniglot(Int, :small1)
    @test d.split == :small1
    @test d.features isa Array{Int}
end

@testset "small2set" begin
    d = Omniglot(split = :small2, Tx = UInt8)

    @test d.split == :small2
    @test extrema(d.features) == (0, 1)
    @test convert2image(d, 1) isa AbstractMatrix{<:Gray}

    test_supervised_array_dataset(d;
                                  n_features, n_targets, n_obs = 3120,
                                  Tx = UInt8, Ty = String,
                                  conv2img = true)

    d = Omniglot(:small2)
    @test d.split == :small2
    d = Omniglot(Int, :small2)
    @test d.split == :small2
    @test d.features isa Array{Int}
end
