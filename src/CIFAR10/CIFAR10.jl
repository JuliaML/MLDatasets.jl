export CIFAR10
module CIFAR10
    using DataDeps
    using BinDeps
    using ColorTypes
    using FixedPointNumbers
    using ..MLDatasets: bytes_to_type, datafile, download_dep, download_docstring,
                        _colorview, _channelview

    export

        classnames,

        traintensor,
        testtensor,

        trainlabels,
        testlabels,

        traindata,
        testdata,

        convert2image,

        download

    @deprecate convert2features reshape

    const DEPNAME = "CIFAR10"
    const NCHUNKS = 5

    filename_for_chunk(file_index::Int) =
        joinpath("cifar-10-batches-bin", "data_batch_$(file_index).bin")

    const TESTSET_FILENAME =
        joinpath("cifar-10-batches-bin", "test_batch.bin")

    const CLASSES = [
        "airplane",
        "automobile",
        "bird",
        "cat",
        "deer",
        "dog",
        "frog",
        "horse",
        "ship",
        "truck",
    ]

    """
        download([dir]; [i_accept_the_terms_of_use])

    Trigger the (interactive) download of the full dataset into
    "`dir`". If no `dir` is provided the dataset will be
    downloaded into "~/.julia/datadeps/$DEPNAME".

    This function will display an interactive dialog unless
    either the keyword parameter `i_accept_the_terms_of_use` or
    the environment variable `DATADEPS_ALWAYS_ACCEPT` is set to
    `true`. Note that using the data responsibly and respecting
    copyright/terms-of-use remains your responsibility.
    """
    download(args...; kw...) = download_dep(DEPNAME, args...; kw...)

    include(joinpath("Reader","Reader.jl"))
    include("interface.jl")
    include("utils.jl")

    function __init__()
        register(DataDep(
            DEPNAME,
            """
            Dataset: The CIFAR-10 dataset
            Authors: Alex Krizhevsky, Vinod Nair, Geoffrey Hinton
            Website: https://www.cs.toronto.edu/~kriz/cifar.html
            Reference: https://www.cs.toronto.edu/~kriz/learning-features-2009-TR.pdf

            [Krizhevsky, 2009]
                Alex Krizhevsky.
                "Learning Multiple Layers of Features from Tiny Images",
                Tech Report, 2009.

            The CIFAR-10 dataset is a labeled subsets of the 80
            million tiny images dataset. It consists of 60000
            32x32 colour images in 10 classes, with 6000 images
            per class.

            The compressed archive file that contains the
            complete dataset is available for download at the
            offical website linked above; specifically the binary
            version for C programs. Note that using the data
            responsibly and respecting copyright remains your
            responsibility. The authors of CIFAR-10 aren't really
            explicit about any terms of use, so please read the
            website to make sure you want to download the
            dataset.
            """,
            "https://www.cs.toronto.edu/~kriz/cifar-10-binary.tar.gz",
            "c4a38c50a1bc5f3a1c5537f2155ab9d68f9f25eb1ed8d9ddda3db29a59bca1dd",
            post_fetch_method = file -> (run(BinDeps.unpack_cmd(file,dirname(file), ".gz", ".tar")); rm(file))
        ))
    end
end
