export Mutagenesis
module Mutagenesis

    using DataDeps, JSON
    using ..MLDatasets: datafile

    function __init__()
        DEPNAME = "Mutagenesis"
        ORIGINAL_LINK = "https://relational.fit.cvut.cz/dataset/Mutagenesis"
        DATA_LINK = "https://raw.githubusercontent.com/CTUAvastLab/datasets/main/mutagenesis"
        DATA = "data.json"
        METADATA = "meta.json"

        register(DataDep(
            DEPNAME,
            """
            Dataset: The $DEPNAME dataset.
            Website: $ORIGINAL_LINK
            License: CC0
            """,
            "$DATA_LINK/" .* [DATA, METADATA],
        ))
    end

    traindata(; dir = nothing) = traindata(dir)
    testdata(; dir = nothing) = testdata(dir)
    valdata(; dir = nothing) = valdata(dir)

    function traindata(dir)
        samples, targets, train_idxs, val_idxs, test_idxs = load_data(dir)
        samples[train_idxs], targets[train_idxs]
    end

    function testdata(dir)
        samples, targets, train_idxs, val_idxs, test_idxs = load_data(dir)
        samples[test_idxs], targets[test_idxs]
    end

    function valdata(dir)
        samples, targets, train_idxs, val_idxs, test_idxs = load_data(dir)
        samples[val_idxs], targets[val_idxs]
    end

    function load_data(dir)
        data_path = datafile(DEPNAME, DATA, dir)
        metadata_path = datafile(DEPNAME, METADATA, dir)
        samples = read_data(data_path)
        metadata = read_metadata(metadata_path)
        labelkey = metadata["label"]
        targets = map(i -> i[labelkey], samples)
        val_num = metadata["val_samples"]
        test_num = metadata["test_samples"]
        train_idxs = 1:length(samples)-val_num-test_num
        val_idxs = length(samples)-val_num-test_num+1:length(samples)-test_num
        test_idxs = length(samples)-test_num+1:length(samples)
        samples, targets, train_idxs, val_idxs, test_idxs
    end

    read_data(path) = Vector{Dict}(open(JSON.parse, path))
    read_metadata(path) = open(JSON.parse, path)

end # module
