module CIFAR100_Tests
using Test
using ColorTypes
using ImageCore
using FixedPointNumbers
using MLDatasets
using DataDeps
using ..MLDatasetsTestUtils

@testset "Constants" begin
    @test CIFAR100.Reader.NROW === 32
    @test CIFAR100.Reader.NCOL === 32
    @test CIFAR100.Reader.NCHAN === 3

    @test CIFAR100.TRAINSET_SIZE === 50_000
    @test CIFAR100.TESTSET_SIZE  === 10_000

    @test DataDeps.registry["CIFAR100"] isa DataDeps.DataDep
end

@testset "convert2features" begin
    @test CIFAR100.convert2features === CIFAR10.convert2features
end

@testset "convert2images" begin
    @test CIFAR100.convert2image === CIFAR10.convert2image
end

# NOT executed on CI. only executed locally.
# This involves dataset download etc.
if isCI()
    @info "CI detected: skipping dataset download"
else
    data_dir = withenv("DATADEPS_ALWAYS_ACCEPT"=>"true") do
        datadep"CIFAR100"
    end

    @testset "classnames" begin
        @test CIFAR100.classnames_coarse() isa Vector{String}
        @test length(CIFAR100.classnames_coarse()) == 20
        @test length(unique(CIFAR100.classnames_coarse())) == 20
        @test CIFAR100.classnames_fine() isa Vector{String}
        @test length(CIFAR100.classnames_fine()) == 100
        @test length(unique(CIFAR100.classnames_fine())) == 100
    end

    @testset "Images" begin
        # Sanity check that the first trainimage is not the first testimage
        @test CIFAR100.traintensor(1) != CIFAR100.testtensor(1)
        # Make sure other integer types work as indicies
        @test CIFAR100.traintensor(0xBAE) == CIFAR100.traintensor(2990)

        @testset "Test that traintensor are the train images" begin
            path = joinpath(data_dir, "cifar-100-binary", "train.bin")
            @test CIFAR100.traintensor(1) == reinterpret(N0f8, CIFAR100.Reader.readdata(path, 10_000, 1)[1])
            @test CIFAR100.traintensor(Float64, 1) ≈ CIFAR100.Reader.readdata(path, 10_000, 1)[1] ./ 255
            @test CIFAR100.traintensor(Int, 1) == Int.(CIFAR100.Reader.readdata(path, 10_000, 1)[1])
            @test CIFAR100.traintensor(UInt8, 1) == CIFAR100.Reader.readdata(path, 10_000, 1)[1]
            @test CIFAR100.traintensor(UInt8, 2) == CIFAR100.Reader.readdata(path, 10_000, 2)[1]
            @test CIFAR100.traintensor(UInt8, 10_000) == CIFAR100.Reader.readdata(path, 10_000, 10_000)[1]
        end

        @testset "Test that testtensor are the test images" begin
            path = joinpath(data_dir, "cifar-100-binary", "test.bin")
            @test CIFAR100.testtensor(1) == reinterpret(N0f8, CIFAR100.Reader.readdata(path, 10_000, 1)[1])
            @test CIFAR100.testtensor(Float64, 1) ≈ CIFAR100.Reader.readdata(path, 10_000, 1)[1] ./ 255
            @test CIFAR100.testtensor(Int, 1) == Int.(CIFAR100.Reader.readdata(path, 10_000, 1)[1])
            @test CIFAR100.testtensor(UInt8, 1) == CIFAR100.Reader.readdata(path, 10_000, 1)[1]
            @test CIFAR100.testtensor(UInt8, 2) == CIFAR100.Reader.readdata(path, 10_000, 2)[1]
            @test CIFAR100.testtensor(UInt8, 10_000) == CIFAR100.Reader.readdata(path, 10_000, 10_000)[1]
        end

        @test CIFAR100.traintensor(UInt8, 1)[11:13, 12:14, 1] == [
            0x5b  0x49  0x49;
            0x45  0x2a  0x6a;
            0x93  0x9b  0xb1;
        ]
        @test CIFAR100.testtensor(UInt8, 1)[11:13, 12:14, 1] == [
            0xef  0xe7  0xe5;
            0xf1  0xe6  0xe0;
            0xf3  0xe5  0xd6;
        ]

        # These tests check if the functions return internaly
        # consistent results for different parameters (e.g. index
        # as int or as vector). That means no matter how you
        # specify an index, you will always get the same result
        # for a specific index.
        for (image_fun, T, nimages) in (
                (CIFAR100.traintensor, Float32, 50_000),
                (CIFAR100.traintensor, Float64, 50_000),
                (CIFAR100.traintensor, N0f8,    50_000),
                (CIFAR100.traintensor, Int,     50_000),
                (CIFAR100.traintensor, UInt8,   50_000),
                (CIFAR100.testtensor,  Float32, 10_000),
                (CIFAR100.testtensor,  Float64, 10_000),
                (CIFAR100.testtensor,  N0f8,    10_000),
                (CIFAR100.testtensor,  Int,     10_000),
                (CIFAR100.testtensor,  UInt8,   10_000)
            )
            @testset "$image_fun with T=$T" begin
                # whole image set
                A = @inferred image_fun(T)
                @test A isa AbstractArray{T,4}
                @test size(A) == (32,32,3,nimages)

                @test_throws ArgumentError image_fun(T,-1)
                @test_throws ArgumentError image_fun(T,0)
                @test_throws ArgumentError image_fun(T,nimages+1)

                @testset "load single images" begin
                    # Sample a few random images to compare
                    for i = rand(1:nimages, 10)
                        A_i = @inferred image_fun(T,i)
                        @test A_i isa AbstractArray{T,3}
                        @test size(A_i) == (32,32,3)
                        @test A_i == A[:,:,:,i]
                    end
                end

                @testset "load multiple images" begin
                    A_5_10 = @inferred image_fun(T,5:10)
                    @test A_5_10 isa AbstractArray{T,4}
                    @test size(A_5_10) == (32,32,3,6)
                    @test A_5_10 == A[:,:,:,5:10]

                    # also test edge cases `1`, `nimages`
                    indices = [10,1,3,3,9,1,nimages]
                    A_vec   = image_fun(T,indices)
                    A_vec_f = image_fun(T,Vector{Int32}(indices))
                    @test A_vec   isa AbstractArray{T,4}
                    @test A_vec_f isa AbstractArray{T,4}
                    @test size(A_vec)   == (32,32,3,7)
                    @test size(A_vec_f) == (32,32,3,7)
                    @test A_vec == A[:,:,:,indices]
                    @test A_vec == A_vec_f
                end
            end
        end
    end

    @testset "Labels" begin
        # Sanity check that the first trainlabel is not also
        # the first testlabel
        @test CIFAR100.trainlabels(1) != CIFAR100.testlabels(1)

        # Check a few hand picked examples. I looked at both the
        # pictures and the native output to make sure these
        # values are correspond to the image at the same index.
        @test CIFAR100.trainlabels(1) === (11, 19)
        @test CIFAR100.trainlabels(2) === (15, 29)
        @test CIFAR100.trainlabels(1337) === (11, 19)
        @test CIFAR100.trainlabels(0xCAF) === (18, 58)
        @test CIFAR100.trainlabels(50_000) === (1, 73)
        @test CIFAR100.testlabels(1) === (10, 49)
        @test CIFAR100.testlabels(4) === (4, 51)
        @test CIFAR100.testlabels(0xDAD) === (9, 12)
        @test CIFAR100.testlabels(10_000) === (2, 70)

        # These tests check if the functions return internaly
        # consistent results for different parameters (e.g. index
        # as int or as vector). That means no matter how you
        # specify an index, you will always get the same result
        # for a specific index.
        # -- However, technically these tests do not check if
        #    these are the actual CIFAR100 labels of that index!
        @testset "$label_fun" for (label_fun, nlabels) in
                    ((CIFAR100.trainlabels, 50_000),
                     (CIFAR100.testlabels,  10_000))
            # whole label set
            A, B = @inferred label_fun()
            @test A isa AbstractVector{Int64}
            @test size(A) == (nlabels,)
            @test B isa AbstractVector{Int64}
            @test size(B) == (nlabels,)

            @testset "load single label" begin
                # Sample a few random labels to compare
                for i = rand(1:nlabels, 10)
                    A_i, B_i = @inferred label_fun(i)
                    @test A_i isa Int64
                    @test A_i == A[i]
                    @test B_i isa Int64
                    @test B_i == B[i]
                end
            end

            @testset "load multiple labels" begin
                A_5_10, B_5_10 = @inferred label_fun(5:10)
                @test A_5_10 isa Vector{Int64}
                @test size(A_5_10) == (6,)
                @test B_5_10 isa Vector{Int64}
                @test size(B_5_10) == (6,)
                @test A_5_10 == A[5:10]
                @test B_5_10 == B[5:10]

                # also test edge cases `1`, `nlabels`
                indices = [10,1,3,3,9,1,nlabels]
                A_vec, B_vec     = @inferred label_fun(indices)
                A_vec_f, B_vec_f = @inferred label_fun(Vector{Int32}(indices))
                @test A_vec   isa Vector{Int64}
                @test A_vec_f isa Vector{Int64}
                @test size(A_vec)   == (7,)
                @test size(A_vec_f) == (7,)
                @test B_vec   isa Vector{Int64}
                @test B_vec_f isa Vector{Int64}
                @test size(B_vec)   == (7,)
                @test size(B_vec_f) == (7,)
                @test A_vec == A[indices]
                @test A_vec == A_vec_f
                @test B_vec == B[indices]
                @test B_vec == B_vec_f
            end
        end
    end

    # Check against the already tested tensor and labels functions
    @testset "Data" begin
        @testset "check $data_fun against $feature_fun and $label_fun" for
            (data_fun, feature_fun, label_fun, nobs) in
                ((CIFAR100.traindata, CIFAR100.traintensor, CIFAR100.trainlabels, 50_000),
                 (CIFAR100.testdata,  CIFAR100.testtensor,  CIFAR100.testlabels,  10_000))

            data, l1, l2 = @inferred data_fun()
            @test data == @inferred feature_fun()
            @test (l1, l2) == @inferred label_fun()

            for i = rand(1:nobs, 10)
                d_i, l1_i, l2_i = @inferred data_fun(i)
                @test d_i == @inferred feature_fun(i)
                @test (l1_i, l2_i) == @inferred label_fun(i)
            end

            data, l1, l2 = @inferred data_fun(5:10)
            @test data == @inferred feature_fun(5:10)
            @test (l1, l2) == @inferred label_fun(5:10)

            data, l1, l2 = @inferred data_fun(Int, 5:10)
            @test data == @inferred feature_fun(Int, 5:10)
            @test (l1, l2) == @inferred label_fun(5:10)

            indices = [10,1,3,3,9,1,nobs]
            data, l1, l2 = @inferred data_fun(indices)
            @test data == @inferred feature_fun(indices)
            @test (l1, l2) == @inferred label_fun(indices)
        end
    end
end

end # module
