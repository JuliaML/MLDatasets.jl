module FashionMNIST_Tests
using Test
using ColorTypes
using ImageCore
using FixedPointNumbers
using MLDatasets
using DataDeps
using ..MLDatasetsTestUtils

@testset "Constants" begin
    @test FashionMNIST.TRAINIMAGES == "train-images-idx3-ubyte.gz"
    @test FashionMNIST.TRAINLABELS == "train-labels-idx1-ubyte.gz"
    @test FashionMNIST.TESTIMAGES  == "t10k-images-idx3-ubyte.gz"
    @test FashionMNIST.TESTLABELS  == "t10k-labels-idx1-ubyte.gz"
    @test FashionMNIST.classnames() isa Vector{String}
    @test length(FashionMNIST.classnames()) == 10
    @test length(unique(FashionMNIST.classnames())) == 10

    @test DataDeps.registry["FashionMNIST"] isa DataDeps.DataDep
end

@testset "convert2features" begin
    @test FashionMNIST.convert2features === MNIST.convert2features
end

@testset "convert2images" begin
    @test FashionMNIST.convert2image === MNIST.convert2image
end

# NOT executed on CI. only executed locally.
# This involves dataset download etc.
if isCI()
    @info "CI detected: skipping dataset download"
else
    data_dir = withenv("DATADEPS_ALWAYS_ACCEPT"=>"true") do
        datadep"FashionMNIST"
    end

    const _TRAINIMAGES = joinpath(data_dir, FashionMNIST.TRAINIMAGES)
    const _TRAINLABELS = joinpath(data_dir, FashionMNIST.TRAINLABELS)
    const _TESTIMAGES = joinpath(data_dir, FashionMNIST.TESTIMAGES)
    const _TESTLABELS = joinpath(data_dir, FashionMNIST.TESTLABELS)

    @testset "Images" begin
        # Sanity check that the first trainimage is not the first testimage
        @test FashionMNIST.traintensor(1) != FashionMNIST.testtensor(1)
        # Make sure other integer types work as indicies
        @test FashionMNIST.traintensor(0xBAE) == FashionMNIST.traintensor(2990)

        @testset "Test that traintensor are the train images" begin
            for i = rand(1:60_000, 10)
                @test FashionMNIST.traintensor(i) == reinterpret(N0f8, FashionMNIST.Reader.readimages(_TRAINIMAGES, i))
                @test FashionMNIST.traintensor(Float64, i) == FashionMNIST.Reader.readimages(_TRAINIMAGES, i) ./ 255.0
                @test FashionMNIST.traintensor(UInt8, i) == FashionMNIST.Reader.readimages(_TRAINIMAGES, i)
            end
        end
        @testset "Test that testtensor are the test images" begin
            for i = rand(1:10_000, 10)
                @test FashionMNIST.testtensor(i) == reinterpret(N0f8, FashionMNIST.Reader.readimages(_TESTIMAGES, i))
                @test FashionMNIST.testtensor(Float64, i) == FashionMNIST.Reader.readimages(_TESTIMAGES, i) ./ 255.0
                @test FashionMNIST.testtensor(UInt8, i) == FashionMNIST.Reader.readimages(_TESTIMAGES, i)
            end
        end

        # These tests check if the functions return internaly
        # consistent results for different parameters (e.g. index
        # as int or as vector). That means no matter how you
        # specify an index, you will always get the same result
        # for a specific index.
        @testset "$image_fun with T=$T" for (image_fun, T, nimages) in (
                (FashionMNIST.traintensor, Float32, 60_000),
                (FashionMNIST.traintensor, Float64, 60_000),
                (FashionMNIST.traintensor, N0f8,    60_000),
                (FashionMNIST.traintensor, Int,     60_000),
                (FashionMNIST.traintensor, UInt8,   60_000),
                (FashionMNIST.testtensor,  Float32, 10_000),
                (FashionMNIST.testtensor,  Float64, 10_000),
                (FashionMNIST.testtensor,  N0f8,    10_000),
                (FashionMNIST.testtensor,  Int,     10_000),
                (FashionMNIST.testtensor,  UInt8,   10_000)
            )
            # whole image set
            A = @inferred image_fun(T)
            @test A isa AbstractArray{T,3}
            @test size(A) == (28,28,nimages)

            @test_throws ArgumentError image_fun(T,-1)
            @test_throws ArgumentError image_fun(T,0)
            @test_throws ArgumentError image_fun(T,nimages+1)

            @testset "load single images" begin
                # Sample a few random images to compare
                for i = rand(1:nimages, 10)
                    A_i = @inferred image_fun(T,i)
                    @test A_i isa AbstractArray{T,2}
                    @test size(A_i) == (28,28)
                    @test A_i == A[:,:,i]
                end
            end

            @testset "load multiple images" begin
                A_5_10 = @inferred image_fun(T,5:10)
                @test A_5_10 isa AbstractArray{T,3}
                @test size(A_5_10) == (28,28,6)
                @test A_5_10 == A[:,:,5:10]

                # also test edge cases `1`, `nimages`
                indices = [10,1,3,3,9,1,nimages]
                A_vec   = image_fun(T,indices)
                A_vec_f = image_fun(T,Vector{Int32}(indices))
                @test A_vec   isa AbstractArray{T,3}
                @test A_vec_f isa AbstractArray{T,3}
                @test size(A_vec)   == (28,28,7)
                @test size(A_vec_f) == (28,28,7)
                @test A_vec == A[:,:,indices]
                @test A_vec == A_vec_f
            end
        end
    end

    @testset "Labels" begin
        # Sanity check that the first trainlabel is not also
        # the first testlabel
        @test FashionMNIST.trainlabels(2) != FashionMNIST.testlabels(2)

        # Check a few hand picked examples. I looked at both the
        # pictures and the native output to make sure these
        # values are correspond to the image at the same index.
        @test FashionMNIST.trainlabels(1) === 9
        @test FashionMNIST.trainlabels(5) === 0
        @test FashionMNIST.trainlabels(60_000) === 5
        @test FashionMNIST.testlabels(1) === 9
        @test FashionMNIST.testlabels(10_000) === 5

        # These tests check if the functions return internaly
        # consistent results for different parameters (e.g. index
        # as int or as vector). That means no matter how you
        # specify an index, you will always get the same result
        # for a specific index.
        # -- However, technically these tests do not check if
        #    these are the actual FashionMNIST labels of that index!
        @testset "$label_fun" for (label_fun, nlabels) in
                ((FashionMNIST.trainlabels, 60_000),
                (FashionMNIST.testlabels,  10_000))

            # whole label set
            A = @inferred label_fun()
            @test A isa Vector{Int64}
            @test size(A) == (nlabels,)

            @testset "load single label" begin
                # Sample a few random labels to compare
                for i = rand(1:nlabels, 10)
                    A_i = @inferred label_fun(i)
                    @test A_i isa Int64
                    @test A_i == A[i]
                end
            end

            @testset "load multiple labels" begin
                A_5_10 = @inferred label_fun(5:10)
                @test A_5_10 isa Vector{Int64}
                @test size(A_5_10) == (6,)
                @test A_5_10 == A[5:10]

                # also test edge cases `1`, `nlabels`
                indices = [10,1,3,3,9,1,nlabels]
                A_vec   = @inferred label_fun(indices)
                A_vec_f = @inferred label_fun(Vector{Int32}(indices))
                @test A_vec   isa Vector{Int64}
                @test A_vec_f isa Vector{Int64}
                @test size(A_vec)   == (7,)
                @test size(A_vec_f) == (7,)
                @test A_vec == A[indices]
                @test A_vec == A_vec_f
            end
        end
    end

    # Check against the already tested tensor and labels functions
    @testset "Data" begin
        @testset "check $data_fun against $feature_fun and $label_fun" for
            (data_fun, feature_fun, label_fun, nobs) in
                ((FashionMNIST.traindata, FashionMNIST.traintensor, FashionMNIST.trainlabels, 60_000),
                (FashionMNIST.testdata,  FashionMNIST.testtensor,  FashionMNIST.testlabels,  10_000))

            data, labels = @inferred data_fun()
            @test data == @inferred feature_fun()
            @test labels == @inferred label_fun()

            for i = rand(1:nobs, 10)
                d_i, l_i = @inferred data_fun(i)
                @test d_i == @inferred feature_fun(i)
                @test l_i == @inferred label_fun(i)
            end

            data, labels = @inferred data_fun(5:10)
            @test data == @inferred feature_fun(5:10)
            @test labels == @inferred label_fun(5:10)

            data, labels = @inferred data_fun(Int, 5:10)
            @test data == @inferred feature_fun(Int, 5:10)
            @test labels == @inferred label_fun(5:10)

            indices = [10,1,3,3,9,1,nobs]
            data, labels = @inferred data_fun(indices)
            @test data == @inferred feature_fun(indices)
            @test labels == @inferred label_fun(indices)
        end
    end
end

end
