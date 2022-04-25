n_features = (32, 32, 3)
n_targets = 1

@testset "trainset" begin
    d = SVHN2()

    @test d.split == :train
    @test extrema(d.features) == (0, 1)
    @test convert2image(d, 1) isa AbstractMatrix{<:RGB}
    @test convert2image(d, 1:2) isa AbstractArray{<:RGB,3}

    test_supervised_array_dataset(d;
        n_features, n_targets, n_obs=73257,
        Tx=Float32, Ty=Int)
end

@testset "testset" begin 
    d = SVHN2(split=:test, Tx=UInt8)

    @test d.split == :test
    @test extrema(d.features) == (0, 255)
    @test convert2image(d, 1) isa AbstractMatrix{<:RGB}
    @test convert2image(d, 1:2) isa AbstractArray{<:RGB,3}

    test_supervised_array_dataset(d;
        n_features, n_targets, n_obs=26032,
        Tx=UInt8, Ty=Int)
end

# @testset "extraset" begin 
#     d = SVHN2(split=:test)

#     @test d.split == :extra
#     @test extrema(d.features) == (0, 1)
#     @test convert2image(d, 1) isa AbstractMatrix{<:RGB}
#     @test convert2image(d, 1:2) isa AbstractArray{<:RGB,3}

#     test_supervised_array_dataset(d;
#         n_features, n_targets, n_obs=531131,
#         Tx=Float32, Ty=Int)
# end
