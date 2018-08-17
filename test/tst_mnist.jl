module MNIST_Tests
using Test
using ColorTypes
using ImageCore
using FixedPointNumbers
using MLDatasets
using DataDeps
using ..MLDatasetsTestUtils

@testset "Constants" begin
    @test MNIST.Reader.IMAGEOFFSET == 16
    @test MNIST.Reader.LABELOFFSET == 8

    @test MNIST.TRAINIMAGES == "train-images-idx3-ubyte.gz"
    @test MNIST.TRAINLABELS == "train-labels-idx1-ubyte.gz"
    @test MNIST.TESTIMAGES  == "t10k-images-idx3-ubyte.gz"
    @test MNIST.TESTLABELS  == "t10k-labels-idx1-ubyte.gz"

    @test DataDeps.registry["MNIST"] isa DataDeps.DataDep
end

@testset "convert2features" begin
    data = rand(28,28)
    @test @inferred(MNIST.convert2features(data)) == vec(data)

    data = rand(28,28,2)
    @test @inferred(MNIST.convert2features(data)) == reshape(data, (28*28, 2))
end

@testset "convert2images" begin
    @test_throws AssertionError MNIST.convert2image(rand(100))
    @test_throws AssertionError MNIST.convert2image(rand(27,28,1))
    @test_throws AssertionError MNIST.convert2image(rand(228,1))

    data = rand(N0f8,28,28)
    data[1] = 0 # make sure 0 means "white"
    A = MNIST.convert2image(data)
    @test A[1] == 1.0
    @test size(A) == (28,28)
    @test eltype(A) == Gray{N0f8}
    @test MNIST.convert2image(vec(data)) == A

    data = rand(N0f8,28,28,2)
    data[1] = 0
    A = MNIST.convert2image(data)
    @test A[1] == 1.0
    @test size(A) == (28,28,2)
    @test eltype(A) == Gray{N0f8}
    @test MNIST.convert2image(vec(data)) == A
    @test MNIST.convert2image(MNIST.convert2features(data)) == A
end

# NOT executed on CI. only executed locally.
# This involves dataset download etc.
    data_dir = withenv("DATADEPS_ALWAYS_ACCEPT"=>"true") do
        datadep"MNIST"
    end

    const _TRAINIMAGES = joinpath(data_dir, MNIST.TRAINIMAGES)
    const _TRAINLABELS = joinpath(data_dir, MNIST.TRAINLABELS)
    const _TESTIMAGES = joinpath(data_dir, MNIST.TESTIMAGES)
    const _TESTLABELS = joinpath(data_dir, MNIST.TESTLABELS)

    @testset "File Header" begin
        @test MNIST.Reader.readimageheader(_TRAINIMAGES) == (0x803,60000,28,28)
        @test MNIST.Reader.readimageheader(_TESTIMAGES)  == (0x803,10000,28,28)
        @test MNIST.Reader.readlabelheader(_TRAINLABELS) == (0x801,60000)
        @test MNIST.Reader.readlabelheader(_TESTLABELS)  == (0x801,10000)
    end

    @testset "Images" begin
        # Sanity check that the first trainimage is not the first testimage
        @test MNIST.traintensor(1) != MNIST.testtensor(1)
        # Make sure other integer types work as indicies
        @test MNIST.traintensor(0xBAE) == MNIST.traintensor(2990)

        @testset "Test that traintensor are the train images" begin
            for i = rand(1:60_000, 10)
                @test MNIST.traintensor(i) == reinterpret(N0f8, MNIST.Reader.readimages(_TRAINIMAGES, i))
                @test MNIST.traintensor(Float64, i) == MNIST.Reader.readimages(_TRAINIMAGES, i) ./ 255.0
                @test MNIST.traintensor(UInt8, i) == MNIST.Reader.readimages(_TRAINIMAGES, i)
            end
        end
        @testset "Test that testtensor are the test images" begin
            for i = rand(1:10_000, 10)
                @test MNIST.testtensor(i) == reinterpret(N0f8, MNIST.Reader.readimages(_TESTIMAGES, i))
                @test MNIST.testtensor(Float64, i) == MNIST.Reader.readimages(_TESTIMAGES, i) ./ 255.0
                @test MNIST.testtensor(UInt8, i) == MNIST.Reader.readimages(_TESTIMAGES, i)
            end
        end

        # Test that `readtrainimage` is the horizontal-major layout
        # by comparing to a hand checked result
        @test MNIST.Reader.readimages(_TRAINIMAGES, 1)[11:13,12:14] ==
                [0x00 0x00 0x00;
                0x8b 0x0b 0x00;
                0xfd 0xbe 0x23]
        @test MNIST.traintensor(UInt8, 1)[11:13,12:14] ==
                [0x00 0x00 0x00;
                0x8b 0x0b 0x00;
                0xfd 0xbe 0x23]

        # These tests check if the functions return internaly
        # consistent results for different parameters (e.g. index
        # as int or as vector). That means no matter how you
        # specify an index, you will always get the same result
        # for a specific index.
        @testset "$image_fun with T=$T" for (image_fun, T, nimages) in (
                (MNIST.traintensor, Float32, 60_000),
                (MNIST.traintensor, Float64, 60_000),
                (MNIST.traintensor, N0f8,    60_000),
                (MNIST.traintensor, Int,     60_000),
                (MNIST.traintensor, UInt8,   60_000),
                (MNIST.testtensor,  Float32, 10_000),
                (MNIST.testtensor,  Float64, 10_000),
                (MNIST.testtensor,  N0f8,    10_000),
                (MNIST.testtensor,  Int,     10_000),
                (MNIST.testtensor,  UInt8,   10_000)
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
        @test MNIST.trainlabels(1) != MNIST.testlabels(1)

        # Check a few hand picked examples. I looked at both the
        # pictures and the native output to make sure these
        # values are correspond to the image at the same index.
        @test MNIST.trainlabels(1) === 5
        @test MNIST.trainlabels(2) === 0
        @test MNIST.trainlabels(1337) === 3
        @test MNIST.trainlabels(0xCAFE) === 6
        @test MNIST.trainlabels(60_000) === 8
        @test MNIST.testlabels(1) === 7
        @test MNIST.testlabels(2) === 2
        @test MNIST.testlabels(0xDAD) === 4
        @test MNIST.testlabels(10_000) === 6

        # These tests check if the functions return internaly
        # consistent results for different parameters (e.g. index
        # as int or as vector). That means no matter how you
        # specify an index, you will always get the same result
        # for a specific index.
        # -- However, technically these tests do not check if
        #    these are the actual MNIST labels of that index!
        @testset "$label_fun" for (label_fun, nlabels) in
                    ((MNIST.trainlabels, 60_000),
                     (MNIST.testlabels,  10_000))
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
                ((MNIST.traindata, MNIST.traintensor, MNIST.trainlabels, 60_000),
                 (MNIST.testdata,  MNIST.testtensor,  MNIST.testlabels,  10_000))

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
