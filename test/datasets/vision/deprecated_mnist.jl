@testset "Images" begin
    # Sanity check that the first trainimage is not the first testimage
    @test MNIST.traintensor(1) != MNIST.testtensor(1)
    # Make sure other integer types work as indicies
    @test MNIST.traintensor(0xBAE) == MNIST.traintensor(2990)

    @test size(MNIST.traintensor()) == (28,28,60000)
    @test size(MNIST.testtensor()) == (28,28,10000)

    # These tests check if the functions return internaly
    # consistent results for different parameters (e.g. index
    # as int or as vector). That means no matter how you
    # specify an index, you will always get the same result
    # for a specific index.
    for (image_fun, T, nimages) in (
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
        @testset "$image_fun with T=$T" begin
            # whole image set
            A = image_fun(T)
            @test typeof(A) <: Union{Array{T,3},Base.ReinterpretArray{T,3}}
            @test size(A) == (28,28,nimages)


            @testset "load single images" begin
                # Sample a few random images to compare
                for i = rand(1:nimages, 10)
                    A_i = image_fun(T,i)
                    @test typeof(A_i) <: Union{Array{T,2},Base.ReinterpretArray{T,2}}
                    @test size(A_i) == (28,28)
                    @test A_i == A[:,:,i]
                end
            end

            @testset "load multiple images" begin
                A_5_10 = image_fun(T,5:10)
                @test typeof(A_5_10) <: Union{Array{T,3},Base.ReinterpretArray{T,3}}
                @test size(A_5_10) == (28,28,6)
                for i = 1:6
                    @test A_5_10[:,:,i] == A[:,:,i+4]
                end

                # also test edge cases `1`, `nimages`
                indices = [10,3,9,1,nimages]
                A_vec   = image_fun(T,indices)
                A_vec_f = image_fun(T,Vector{Int32}(indices))
                @test typeof(A_vec) <: Union{Array{T,3},Base.ReinterpretArray{T,3}}
                @test typeof(A_vec_f) <: Union{Array{T,3},Base.ReinterpretArray{T,3}}
                @test size(A_vec)   == (28,28,5)
                @test size(A_vec_f) == (28,28,5)
                for i in 1:5
                    @test A_vec[:,:,i] == A[:,:,indices[i]]
                    @test A_vec[:,:,i] == A_vec_f[:,:,i]
                end
            end
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
    for (label_fun, nlabels) in
                ((MNIST.trainlabels, 60_000),
                    (MNIST.testlabels,  10_000))
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
            ((MNIST.traindata, MNIST.traintensor, MNIST.trainlabels, 60_000),
                (MNIST.testdata,  MNIST.testtensor,  MNIST.testlabels,  10_000))
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
