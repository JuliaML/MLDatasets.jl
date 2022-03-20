@testset "ArrayDataset" begin
    x = rand(4)
    data = ArrayDataset(x)
    @test length(data) == size(x, ndims(x))
    @test data[1] == x[1]
    @test data[1:2] == x[1:2]
    @test MLDatasets.unwrap(data) === x

    x = rand(2, 5)
    data = ArrayDataset(x)
    @test length(data) == size(x, ndims(x))
    @test data[1] == x[:,1]
    @test data[1:2] == x[:,1:2]
    @test MLDatasets.unwrap(data) === x
end