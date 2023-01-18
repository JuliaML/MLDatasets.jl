function setup_jld2dataset_test()
    datasets = [
        ("d1", rand(2, 10)),
        ("g1/d1", rand(10)),
        ("g1/d2", string.('a':'j')),
        ("g2/g1/d1", rand(Bool, 3, 3, 10)),
    ]

    fid = jldopen("test.jld2", "w")
    for (path, data) in datasets
        fid[path] = data
    end
    close(fid)

    return first.(datasets), Tuple(last.(datasets))
end
cleanup_jld2dataset_test() = rm("test.jld2")

@testset "JLD2Dataset" begin
    paths, datas = setup_jld2dataset_test()
    @testset "Single path" begin
        dataset = JLD2Dataset("test.jld2", "d1")
        for i in 1:10
            @test @inferred(getobs(dataset, i)) == getobs(datas[1], i)
        end
        @test numobs(dataset) == 10
        close(dataset)
    end
    @testset "Multiple paths" begin
        dataset = JLD2Dataset("test.jld2", paths)
        for i in 1:10
            @test @inferred(getobs(dataset, i)) == getobs(datas, i)
        end
        @test numobs(dataset) == 10
        close(dataset)
    end
    cleanup_jld2dataset_test()
end
