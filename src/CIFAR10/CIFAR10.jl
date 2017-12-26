export CIFAR10
module CIFAR10
    using DataDeps
    using BinDeps
    using ImageCore
    using ColorTypes
    using FixedPointNumbers
    using ..bytes_to_type
    using ..datafile
    using ..download_dep

    export

        traintensor,
        testtensor,

        trainlabels,
        testlabels,

        traindata,
        testdata,

        download

    const DEPNAME = "CIFAR10"
    const NCHUNKS = 5

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

    download(args...; kw...) = download_dep(DEPNAME, args...; kw...)

    include(joinpath("Reader","Reader.jl"))
    include("interface.jl")

    function __init__()
        RegisterDataDep(
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
            version for C programs. We can download and unpack
            this archive for you if you wish, but that doesn't
            free you from the burden of using the data
            responsibly and respect copyright. The authors of
            CIFAR-10 aren't really explicit about any terms of
            use, so please read the website to make sure you want
            to download the dataset.
            """,
            "https://www.cs.toronto.edu/~kriz/cifar-10-binary.tar.gz",
            "c4a38c50a1bc5f3a1c5537f2155ab9d68f9f25eb1ed8d9ddda3db29a59bca1dd",
            fetch_method = (src, dst) -> run(BinDeps.download_cmd(src, dst)),
            post_fetch_method = file -> (run(BinDeps.unpack_cmd(file,dirname(file), ".gz", ".tar")); rm(file))
        )
    end
end
