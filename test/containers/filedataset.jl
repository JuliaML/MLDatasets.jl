function setup_filedataset_test()
    files = [
        "root/p1/f1.csv",
        "root/p2/f2.csv",
        "root/p2/p2p1/f2.csv",
        "root/p3/p3p1/f1.csv"
    ]

    for (i, file) in enumerate(files)
        paths = splitpath(file)[1:(end - 1)]
        root = ""
        for p in paths
            fullp = joinpath(root, p)
            isdir(fullp) || mkdir(fullp)
            root = fullp
        end

        open(file, "w") do io
            write(io, "a,b,c\n")
            write(io, join(i .* [1, 2, 3], ","))
        end
    end

    return files
end
cleanup_filedataset_test() = rm("root"; recursive = true)

@testset "FileDataset" begin
    files = setup_filedataset_test()
    dataset = FileDataset("root", "*.csv")
    @test numobs(dataset) == length(files)
    for (i, file) in enumerate(files)
        true_obs = MLDatasets.loadfile(file)
        @test getobs(dataset, i) == true_obs
    end
    cleanup_filedataset_test()
end
