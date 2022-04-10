module CIFAR100_Tests
using Test
using ColorTypes
using ImageCore
using FixedPointNumbers
using MLDatasets
using DataDeps

function readimage(path, m, i)
    MLDatasets.CIFAR100Reader.readdata(path, m, i)[1]
end


# NOT executed on CI. only executed locally.
# This involves dataset download etc.
if parse(Bool, get(ENV, "CI", "false"))
    @info "CI detected: skipping dataset download"
else
    data_dir = datadep"CIFAR100"

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
            @test CIFAR100.traintensor(1) == reinterpret(N0f8, readimage(path, 10_000, 1))
            @test CIFAR100.traintensor(Float64, 1) ≈ readimage(path, 10_000, 1) ./ 255
            @test CIFAR100.traintensor(Int, 1) == Int.(readimage(path, 10_000, 1))
            @test CIFAR100.traintensor(UInt8, 1) == readimage(path, 10_000, 1)
            @test CIFAR100.traintensor(UInt8, 2) == readimage(path, 10_000, 2)
            @test CIFAR100.traintensor(UInt8, 10_000) == readimage(path, 10_000, 10_000)
        end

        @testset "Test that testtensor are the test images" begin
            path = joinpath(data_dir, "cifar-100-binary", "test.bin")
            @test CIFAR100.testtensor(1) == reinterpret(N0f8, readimage(path, 10_000, 1))
            @test CIFAR100.testtensor(Float64, 1) ≈ readimage(path, 10_000, 1) ./ 255
            @test CIFAR100.testtensor(Int, 1) == Int.(readimage(path, 10_000, 1))
            @test CIFAR100.testtensor(UInt8, 1) == readimage(path, 10_000, 1)
            @test CIFAR100.testtensor(UInt8, 2) == readimage(path, 10_000, 2)
            @test CIFAR100.testtensor(UInt8, 10_000) == readimage(path, 10_000, 10_000)
        end

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
                A = image_fun(T)
                @test typeof(A) <: Union{Array{T,4},Base.ReinterpretArray{T,4}}
                @test size(A) == (32,32,3,nimages)

                @testset "load single images" begin
                    # Sample a few random images to compare
                    for i = rand(1:nimages, 10)
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
        for (label_fun, nlabels) in
                    ((CIFAR100.trainlabels, 50_000),
                     (CIFAR100.testlabels,  10_000))
            @testset "$label_fun" begin
                # whole label set
                A, B = label_fun()
                @test typeof(A) <: Vector{Int64}
                @test size(A) == (nlabels,)
                @test typeof(B) <: Vector{Int64}
                @test size(B) == (nlabels,)

                @testset "load single label" begin
                    # Sample a few random labels to compare
                    for i = rand(1:nlabels, 10)
                        A_i, B_i = label_fun(i)
                        @test typeof(A_i) <: Int64
                        @test A_i == A[i]
                        @test typeof(B_i) <: Int64
                        @test B_i == B[i]
                    end
                end

                @testset "load multiple labels" begin
                    A_5_10, B_5_10 = label_fun(5:10)
                    @test typeof(A_5_10) <: Vector{Int64}
                    @test size(A_5_10) == (6,)
                    @test typeof(B_5_10) <: Vector{Int64}
                    @test size(B_5_10) == (6,)
                    for i = 1:6
                        @test A_5_10[i] == A[i+4]
                        @test B_5_10[i] == B[i+4]
                    end

                    # also test edge cases `1`, `nlabels`
                    indices = [10,3,9,1,nlabels]
                    A_vec, B_vec     = label_fun(indices)
                    A_vec_f, B_vec_f = label_fun(Vector{Int32}(indices))
                    @test typeof(A_vec)   <: Vector{Int64}
                    @test typeof(A_vec_f) <: Vector{Int64}
                    @test size(A_vec)   == (5,)
                    @test size(A_vec_f) == (5,)
                    @test typeof(B_vec)   <: Vector{Int64}
                    @test typeof(B_vec_f) <: Vector{Int64}
                    @test size(B_vec)   == (5,)
                    @test size(B_vec_f) == (5,)
                    for i in 1:5
                        @test A_vec[i] == A[indices[i]]
                        @test A_vec[i] == A_vec_f[i]
                        @test B_vec[i] == B[indices[i]]
                        @test B_vec[i] == B_vec_f[i]
                    end
                end
            end
        end
    end

    # Check against the already tested tensor and labels functions
    @testset "Data" begin
        for (data_fun, feature_fun, label_fun, nobs) in
                ((CIFAR100.traindata, CIFAR100.traintensor, CIFAR100.trainlabels, 50_000),
                 (CIFAR100.testdata,  CIFAR100.testtensor,  CIFAR100.testlabels,  10_000))
            @testset "check $data_fun against $feature_fun and $label_fun" begin
                data, l1, l2 = data_fun()
                @test data == feature_fun()
                @test (l1, l2) == label_fun()

                for i = rand(1:nobs, 10)
                    d_i, l1_i, l2_i = data_fun(i)
                    @test d_i == feature_fun(i)
                    @test (l1_i, l2_i) == label_fun(i)
                end

                data, l1, l2 = data_fun(5:10)
                @test data == feature_fun(5:10)
                @test (l1, l2) == label_fun(5:10)

                data, l1, l2 = data_fun(Int, 5:10)
                @test data == feature_fun(Int, 5:10)
                @test (l1, l2) == label_fun(5:10)

                indices = [10,3,9,1,nobs]
                data, l1, l2 = data_fun(indices)
                @test data == feature_fun(indices)
                @test (l1, l2) == label_fun(indices)
            end
        end
    end
end

end # module
