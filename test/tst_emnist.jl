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
            X_train = EMNIST.balanced.traindata()
            X_test = EMNIST.balanced.testdata()
            Y_train = EMNIST.balanced.trainlabels()
            Y_test = EMNIST.balanced.testlabels()
            @test X_train isa Array{UInt8,3}
            @test X_test isa Array{UInt8,3}
            @test Y_train isa Array{Float64,2}
            @test Y_test isa Array{Float64,2}
            @test size(X_train) == (112800, 28, 28)
            @test size(X_test) == (18800, 28, 28)
            @test size(Y_train) == (112800, 1)
            @test size(Y_test) == (18800, 1)

            X_train = EMNIST.byclass.traindata()
            X_test = EMNIST.byclass.testdata()
            Y_train = EMNIST.byclass.trainlabels()
            Y_test = EMNIST.byclass.testlabels()
            @test X_train isa Array{UInt8,3}
            @test X_test isa Array{UInt8,3}
            @test Y_train isa Array{Float64,2}
            @test Y_test isa Array{Float64,2}
            @test size(X_train) == (697932, 28, 28)
            @test size(X_test) == (116323, 28, 28)
            @test size(Y_train) == (697932, 1)
            @test size(Y_test) == (116323, 1)

            X_train = EMNIST.bymerge.traindata()
            X_test = EMNIST.bymerge.testdata()
            Y_train = EMNIST.bymerge.trainlabels()
            Y_test = EMNIST.bymerge.testlabels()
            @test X_train isa Array{UInt8,3}
            @test X_test isa Array{UInt8,3}
            @test Y_train isa Array{Float64,2}
            @test Y_test isa Array{Float64,2}
            @test size(X_train) == (697932, 28, 28)
            @test size(X_test) == (116323, 28, 28)
            @test size(Y_train) == (697932, 1)
            @test size(Y_test) == (116323, 1)

            X_train = EMNIST.digits.traindata()
            X_test = EMNIST.digits.testdata()
            Y_train = EMNIST.digits.trainlabels()
            Y_test = EMNIST.digits.testlabels()
            @test X_train isa Array{UInt8,3}
            @test X_test isa Array{UInt8,3}
            @test Y_train isa Array{Float64,2}
            @test Y_test isa Array{Float64,2}
            @test size(X_train) == (240000, 28, 28)
            @test size(X_test) == (40000, 28, 28)
            @test size(Y_train) == (240000, 1)
            @test size(Y_test) == (40000, 1)

            X_train = EMNIST.letters.traindata()
            X_test = EMNIST.letters.testdata()
            Y_train = EMNIST.letters.trainlabels()
            Y_test = EMNIST.letters.testlabels()
            @test X_train isa Array{UInt8,3}
            @test X_test isa Array{UInt8,3}
            @test Y_train isa Array{Float64,2}
            @test Y_test isa Array{Float64,2}
            @test size(X_train) == (124800, 28, 28)
            @test size(X_test) == (20800, 28, 28)
            @test size(Y_train) == (124800, 1)
            @test size(Y_test) == (20800, 1)

            X_train = EMNIST.mnist.traindata()
            X_test = EMNIST.mnist.testdata()
            Y_train = EMNIST.mnist.trainlabels()
            Y_test = EMNIST.mnist.testlabels()
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
