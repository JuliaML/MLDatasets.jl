function setup_hdf5dataset_test()
    datasets = [
        ("d1", rand(2, 10)),
        ("g1/d1", rand(10)),
        # these are broken at HDF5 level
        # ("g1/d2", string.('a':'j')),
        # ("g2/g1/d1", "test")
    ]

    fid = h5open("test.h5", "w")
    for (path, data) in datasets
        fid[path] = data
    end
    close(fid)

    return first.(datasets), last.(datasets)
end

@testset "HDF5Dataset" begin
    paths, datas = setup_hdf5dataset_test()
    dataset = HDF5Dataset("test.h5", paths)
    for i in 1:10
        data = Tuple(map(x -> getobs(x, i), datas))
        @test getobs(dataset, i) == data
    end
    @test numobs(dataset) == 10
    close(dataset)
    rm("test.h5")
end
