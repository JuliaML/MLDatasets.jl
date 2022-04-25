module SVHN2_Tests
using Test
using ColorTypes
using ImageCore
using FixedPointNumbers
using MLDatasets
using DataDeps
using MAT

@testset "Constants" begin
    @test SVHN2.classnames() isa Vector{Int}
    @test SVHN2.classnames() == [1,2,3,4,5,6,7,8,9,0]
    @test length(SVHN2.classnames()) == 10
    @test length(unique(SVHN2.classnames())) == 10
end

@testset "convert2images" begin

    data = rand(N0f8,32,32,3)
    A = SVHN2.convert2image(data)
    @test size(A) == (32,32)
    @test eltype(A) == RGB{N0f8}
    @test SVHN2.convert2image(vec(data)) == A
    @test permutedims(channelview(A), (3, 2, 1)) == data
    @test SVHN2.convert2image(reinterpret(UInt8, data)) == A

    data = rand(N0f8,32,32,3,2)
    A = SVHN2.convert2image(data)
    @test size(A) == (32,32,2)
    @test eltype(A) == RGB{N0f8}
    @test SVHN2.convert2image(vec(data)) == A
    @test SVHN2.convert2image(reinterpret(UInt8, data)) == A
end

# NOT executed on CI. only executed locally.
# This involves dataset download etc.
if parse(Bool, get(ENV, "CI", "false"))
    @info "CI detected: skipping dataset download"
else
    data_dir = datadep"SVHN2"

    @testset "Images" begin
        X_train = SVHN2.traintensor()
        X_test  = SVHN2.testtensor()
        X_extra = SVHN2.extratensor()
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

        # These tests check if the functions return internaly
        # consistent results for different parameters (e.g. index
        # as int or as vector). That means no matter how you
        # specify an index, you will always get the same result
        # for a specific index.
        for (image_fun, T, nimages) in (
                (SVHN2.testtensor, UInt8,   26_032),
                (SVHN2.testtensor, Int,     26_032),
                (SVHN2.testtensor, Float64, 26_032),
                (SVHN2.testtensor, Float32, 26_032),
                (SVHN2.testtensor, N0f8,    26_032),
            )
            @testset "$image_fun with T=$T" begin
                # whole image set
                A = image_fun(T)
                @test typeof(A) <: Union{Array{T,4},Base.ReinterpretArray{T,4}}
                @test size(A) == (32,32,3,nimages)

                @testset "load single images" begin
                    # Sample a few random images to compare
                    for i = rand(1:nimages, 3)
                        A_i = image_fun(T,i)
                        @test typeof(A_i) <: Union{Array{T,3},Base.ReinterpretArray{T,3}}
                        @test size(A_i) == (32,32,3)
                        @test A_i == A[:,:,:,i]
                    end
                end

                @testset "load multiple images" begin
                    A_5_10 = image_fun(T,5:10)
                    @test typeof(A_5_10) <: Union{Array{T,4},Base.ReinterpretArray{T,4}}
                    @test size(A_5_10) == (32,32,3,6)
                    for i = 1:6
                        @test A_5_10[:,:,:,i] == A[:,:,:,i+4]
                    end

                    # also test edge cases `1`, `nimages`
                    indices = [10,3,9,1,nimages]
                    A_vec   = image_fun(T,indices)
                    A_vec_f = image_fun(T,Vector{Int32}(indices))
                    @test typeof(A_vec) <: Union{Array{T,4},Base.ReinterpretArray{T,4}}
                    @test typeof(A_vec_f) <: Union{Array{T,4},Base.ReinterpretArray{T,4}}
                    @test size(A_vec)   == (32,32,3,5)
                    @test size(A_vec_f) == (32,32,3,5)
                    for i in 1:5
                        @test A_vec[:,:,:,i] == A[:,:,:,indices[i]]
                        @test A_vec[:,:,:,i] == A_vec_f[:,:,:,i]
                    end
                end
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
        for (label_fun, nlabels) in
                    ((SVHN2.trainlabels, 73_257),
                     (SVHN2.testlabels,  26_032),
                     (SVHN2.extralabels, 531_131))
            @testset "$label_fun" begin
                # whole label set
                A = label_fun()
                @test typeof(A) <: Vector{Int64}
                @test size(A) == (nlabels,)

                @testset "load single label" begin
                    # Sample a few random labels to compare
                    for i = rand(1:nlabels, 10)
                        A_i = label_fun(i)
                        @test typeof(A_i) <: Int64
                        @test A_i == A[i]
                    end
                end

                @testset "load multiple labels" begin
                    A_5_10 = label_fun(5:10)
                    @test typeof(A_5_10) <: Vector{Int64}
                    @test size(A_5_10) == (6,)
                    for i = 1:6
                        @test A_5_10[i] == A[i+4]
                    end

                    # also test edge cases `1`, `nlabels`
                    indices = [10,3,9,1,nlabels]
                    A_vec   = label_fun(indices)
                    A_vec_f = label_fun(Vector{Int32}(indices))
                    @test typeof(A_vec)   <: Vector{Int64}
                    @test typeof(A_vec_f) <: Vector{Int64}
                    @test size(A_vec)   == (5,)
                    @test size(A_vec_f) == (5,)
                    for i in 1:5
                        @test A_vec[i] == A[indices[i]]
                        @test A_vec[i] == A_vec_f[i]
                    end
                end
            end
        end
    end

    # Check against the already tested tensor and labels functions
    @testset "Data" begin
        for (data_fun, feature_fun, label_fun, nobs) in
                 ((SVHN2.testdata,  SVHN2.testtensor,  SVHN2.testlabels,  26_032),)
            @testset "check $data_fun against $feature_fun and $label_fun" begin
                data, labels = data_fun()
                @test data == feature_fun()
                @test labels == label_fun()

                for i = rand(1:nobs, 10)
                    d_i, l_i = data_fun(i)
                    @test d_i == feature_fun(i)
                    @test l_i == label_fun(i)
                end

                data, labels = data_fun(5:10)
                @test data == feature_fun(5:10)
                @test labels == label_fun(5:10)

                data, labels = data_fun(Int, 5:10)
                @test data == feature_fun(Int, 5:10)
                @test labels == label_fun(5:10)

                indices = [10,3,9,1,nobs]
                data, labels = data_fun(indices)
                @test data == feature_fun(indices)
                @test labels == label_fun(indices)
            end
        end
    end
end

end
