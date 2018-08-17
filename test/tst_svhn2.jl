module SVHN2_Tests
using Test
using ColorTypes
using ImageCore
using FixedPointNumbers
using MLDatasets
using DataDeps
using MAT
using ..MLDatasetsTestUtils

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
if isCI()
    @info "CI detected: skipping dataset download"
else
    data_dir = withenv("DATADEPS_ALWAYS_ACCEPT"=>"true") do
        datadep"SVHN2"
    end

    @testset "Images" begin
        X_train = @inferred SVHN2.traintensor()
        X_test  = @inferred SVHN2.testtensor()
        X_extra = @inferred SVHN2.extratensor()
        @test size(X_train, 4) == 73_257
        @test size(X_test,  4) == 26_032
        @test size(X_extra, 4) == 531_131

        # Sanity check that the first trainimage is not the
        # first testimage nor extra image
        @test X_train[:,:,:,1] != X_test[:,:,:,1]
        @test X_train[:,:,:,1] != X_extra[:,:,:,1]
        @test X_test[:,:,:,1]  != X_extra[:,:,:,1]
        # Make sure other integer types work as indicies
        @test SVHN2.testtensor(0xBAE) == SVHN2.testtensor(2990)

        @test reinterpret(UInt8, X_train)[11:13, 12:14, 1, 1] == [
            0x5a  0x5c  0x5b
            0x5c  0x5b  0x5d
            0x5d  0x57  0x59
        ]
        @test reinterpret(UInt8, X_test)[11:13, 12:14, 1, 1] == [
            0x28  0x2f  0x33
            0x2e  0x38  0x3b
            0x2d  0x37  0x3b
        ]
        @test reinterpret(UInt8, X_extra)[11:13, 12:14, 1, 1] == [
            0x51  0x51  0x50
            0x53  0x4e  0x4c
            0x52  0x4c  0x49
        ]

        # These tests check if the functions return internaly
        # consistent results for different parameters (e.g. index
        # as int or as vector). That means no matter how you
        # specify an index, you will always get the same result
        # for a specific index.
        @testset "$image_fun with T=$T" for (image_fun, T, nimages) in (
                (SVHN2.testtensor, UInt8,   26_032),
                (SVHN2.testtensor, Int,     26_032),
                (SVHN2.testtensor, Float64, 26_032),
                (SVHN2.testtensor, Float32, 26_032),
                (SVHN2.testtensor, N0f8,    26_032),
            )

            # whole image set
            A = @inferred image_fun(T)
            @test A isa AbstractArray{T,4}
            @test size(A) == (32,32,3,nimages)

            @test_throws BoundsError image_fun(T,-1)
            @test_throws BoundsError image_fun(T,0)
            @test_throws BoundsError image_fun(T,nimages+1)

            @testset "load single images" begin
                # Sample a few random images to compare
                for i = rand(1:nimages, 3)
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
                for i = 1:6
                    @test A_5_10[:,:,:,i] == A[:,:,:,i+4]
                end

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

    @testset "Labels" begin
        # Sanity check that the first trainlabel is not also
        # the first testlabel
        @test SVHN2.trainlabels(1) != SVHN2.testlabels(1)
        @test SVHN2.trainlabels(1) != SVHN2.extralabels(1)
        @test SVHN2.testlabels(1) != SVHN2.extralabels(1)

        # Check a few hand picked examples. I looked at both the
        # pictures and the native output to make sure these
        # values are correspond to the image at the same index.
        @test SVHN2.trainlabels(1) === 1
        @test SVHN2.trainlabels(2) === 9
        @test SVHN2.trainlabels(1337) === 2
        @test SVHN2.trainlabels(0xCAF) === 3
        @test SVHN2.trainlabels(73_257) === 9
        @test SVHN2.testlabels(1) === 5
        @test SVHN2.testlabels(4) === 10
        @test SVHN2.testlabels(0xDAD) === 4
        @test SVHN2.testlabels(26_032) === 7
        @test SVHN2.extralabels(1) === 4
        @test SVHN2.extralabels(3) === 8
        @test SVHN2.extralabels(531_131) === 4

        # These tests check if the functions return internaly
        # consistent results for different parameters (e.g. index
        # as int or as vector). That means no matter how you
        # specify an index, you will always get the same result
        # for a specific index.
        # -- However, technically these tests do not check if
        #    these are the actual SVHN labels of that index!
        @testset "$label_fun" for (label_fun, nlabels) in
            ((SVHN2.trainlabels, 73_257),
             (SVHN2.testlabels,  26_032),
             (SVHN2.extralabels, 531_131))

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
                 ((SVHN2.testdata,  SVHN2.testtensor,  SVHN2.testlabels,  26_032),)

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
