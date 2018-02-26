module SVHN2_Tests
using Base.Test
using ColorTypes
using ImageCore
using FixedPointNumbers
using MLDatasets
using DataDeps

@testset "Constants" begin
    @test SVHN2.classnames() isa Vector{Int}
    @test SVHN2.classnames() == [1,2,3,4,5,6,7,8,9,0]
    @test length(SVHN2.classnames()) == 10
    @test length(unique(SVHN2.classnames())) == 10

    @test DataDeps.registry["SVHN2"] isa DataDeps.DataDep
end

@testset "convert2features" begin
    data = rand(32,32,3)
    ref = vec(data)
    @test @inferred(SVHN2.convert2features(data)) == ref
    @test @inferred(SVHN2.convert2features(SVHN2.convert2image(data))) == ref

    data = rand(32,32,3,2)
    ref = reshape(data, (32*32*3, 2))
    @test @inferred(SVHN2.convert2features(data)) == ref
    @test @inferred(SVHN2.convert2features(SVHN2.convert2image(data))) == ref
end

@testset "convert2images" begin
    @test_throws AssertionError SVHN2.convert2image(rand(100))
    @test_throws AssertionError SVHN2.convert2image(rand(228,1))
    @test_throws AssertionError SVHN2.convert2image(rand(32,32,4))

    data = rand(N0f8,32,32,3)
    A = @inferred SVHN2.convert2image(data)
    @test size(A) == (32,32)
    @test eltype(A) == RGB{N0f8}
    @test SVHN2.convert2image(vec(data)) == A
    @test permutedims(channelview(A), (2,3,1)) == data
    @test SVHN2.convert2image(reinterpret(UInt8, data)) == A

    data = rand(N0f8,32,32,3,2)
    A = @inferred SVHN2.convert2image(data)
    @test size(A) == (32,32,2)
    @test eltype(A) == RGB{N0f8}
    @test SVHN2.convert2image(vec(data)) == A
    @test SVHN2.convert2image(SVHN2.convert2features(data)) == A
    @test SVHN2.convert2image(reinterpret(UInt8, data)) == A
end

# NOT executed on CI. only executed locally.
# This involves dataset download etc.
if parse(Bool, get(ENV, "CI", "false"))
    info("CI detected: skipping dataset download")
else
    data_dir = withenv("DATADEPS_ALWAY_ACCEPT"=>"true") do
        datadep"SVHN2"
    end
end

end
