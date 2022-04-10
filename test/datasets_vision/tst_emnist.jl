module EMNIST_Tests
    using Test
    using DataDeps
    using MLDatasets

    if parse(Bool, get(ENV, "CI", "false"))
        @info "CI detected: skipping dataset download"
    else
        data_dir = withenv("DATADEPS_ALWAY_ACCEPT"=>"true") do
            datadep"EMNIST"
        end

        @testset "EMNIST" begin
            X_train = EMNIST.Balanced.traindata()
            X_test = EMNIST.Balanced.testdata()
            Y_train = EMNIST.Balanced.trainlabels()
            Y_test = EMNIST.Balanced.testlabels()
            @test X_train isa Array{UInt8,3}
            @test X_test isa Array{UInt8,3}
            @test Y_train isa Array{Float64,2}
            @test Y_test isa Array{Float64,2}
            @test size(X_train) == (112800, 28, 28)
            @test size(X_test) == (18800, 28, 28)
            @test size(Y_train) == (112800, 1)
            @test size(Y_test) == (18800, 1)

            X_train = EMNIST.ByClass.traindata()
            X_test = EMNIST.ByClass.testdata()
            Y_train = EMNIST.ByClass.trainlabels()
            Y_test = EMNIST.ByClass.testlabels()
            @test X_train isa Array{UInt8,3}
            @test X_test isa Array{UInt8,3}
            @test Y_train isa Array{Float64,2}
            @test Y_test isa Array{Float64,2}
            @test size(X_train) == (697932, 28, 28)
            @test size(X_test) == (116323, 28, 28)
            @test size(Y_train) == (697932, 1)
            @test size(Y_test) == (116323, 1)

            X_train = EMNIST.ByMerge.traindata()
            X_test = EMNIST.ByMerge.testdata()
            Y_train = EMNIST.ByMerge.trainlabels()
            Y_test = EMNIST.ByMerge.testlabels()
            @test X_train isa Array{UInt8,3}
            @test X_test isa Array{UInt8,3}
            @test Y_train isa Array{Float64,2}
            @test Y_test isa Array{Float64,2}
            @test size(X_train) == (697932, 28, 28)
            @test size(X_test) == (116323, 28, 28)
            @test size(Y_train) == (697932, 1)
            @test size(Y_test) == (116323, 1)

            X_train = EMNIST.Digits.traindata()
            X_test = EMNIST.Digits.testdata()
            Y_train = EMNIST.Digits.trainlabels()
            Y_test = EMNIST.Digits.testlabels()
            @test X_train isa Array{UInt8,3}
            @test X_test isa Array{UInt8,3}
            @test Y_train isa Array{Float64,2}
            @test Y_test isa Array{Float64,2}
            @test size(X_train) == (240000, 28, 28)
            @test size(X_test) == (40000, 28, 28)
            @test size(Y_train) == (240000, 1)
            @test size(Y_test) == (40000, 1)

            X_train = EMNIST.Letters.traindata()
            X_test = EMNIST.Letters.testdata()
            Y_train = EMNIST.Letters.trainlabels()
            Y_test = EMNIST.Letters.testlabels()
            @test X_train isa Array{UInt8,3}
            @test X_test isa Array{UInt8,3}
            @test Y_train isa Array{Float64,2}
            @test Y_test isa Array{Float64,2}
            @test size(X_train) == (124800, 28, 28)
            @test size(X_test) == (20800, 28, 28)
            @test size(Y_train) == (124800, 1)
            @test size(Y_test) == (20800, 1)

            X_train = EMNIST.MNIST.traindata()
            X_test = EMNIST.MNIST.testdata()
            Y_train = EMNIST.MNIST.trainlabels()
            Y_test = EMNIST.MNIST.testlabels()
            @test X_train isa Array{UInt8,3}
            @test X_test isa Array{UInt8,3}
            @test Y_train isa Array{Float64,2}
            @test Y_test isa Array{Float64,2}
            @test size(X_train) == (60000, 28, 28)
            @test size(X_test) == (10000, 28, 28)
            @test size(Y_train) == (60000, 1)
            @test size(Y_test) == (10000, 1)
        end
    end

end
