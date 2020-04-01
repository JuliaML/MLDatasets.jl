export CIFAR100
module CIFAR100
    using DataDeps
    using BinDeps
    using FixedPointNumbers
    using ..MLDatasets: bytes_to_type, datafile, download_dep, download_docstring
    using ..CIFAR10: convert2image

    export

        classnames_coarse,
        classnames_fine,

        traintensor,
        testtensor,

        trainlabels,
        testlabels,

        traindata,
        testdata,

        convert2image,

        download

    @deprecate convert2features reshape


    const DEPNAME = "CIFAR100"
    const TRAINSET_FILENAME = joinpath("cifar-100-binary", "train.bin")
    const TESTSET_FILENAME  = joinpath("cifar-100-binary", "test.bin")
    const COARSE_FILENAME = joinpath("cifar-100-binary", "coarse_label_names.txt")
    const FINE_FILENAME = joinpath("cifar-100-binary", "fine_label_names.txt")

    const TRAINSET_SIZE = 50_000
    const TESTSET_SIZE  = 10_000

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

    function __init__()
        register(DataDep(
            DEPNAME,
            """
            Dataset: The CIFAR-100 dataset
            Authors: Alex Krizhevsky, Vinod Nair, Geoffrey Hinton
            Website: https://www.cs.toronto.edu/~kriz/cifar.html
            Reference: https://www.cs.toronto.edu/~kriz/learning-features-2009-TR.pdf

            [Krizhevsky, 2009]
                Alex Krizhevsky.
                "Learning Multiple Layers of Features from Tiny Images",
                Tech Report, 2009.

            The CIFAR-100 dataset is a labeled subsets of the 80
            million tiny images dataset. It consists of 60000
            32x32 colour images in 100 classes. Specifically, it
            has 100 classes containing 600 images each. There are
            500 training images and 100 testing images per class.
            The 100 classes in the CIFAR-100 are grouped into 20
            superclasses. Each image comes with a "fine" label
            (the class to which it belongs) and a "coarse" label
            (the superclass to which it belongs).

            The compressed archive file that contains the
            complete dataset is available for download at the
            offical website linked above; specifically the binary
            version for C programs. Note that using the data
            responsibly and respecting copyright remains your
            responsibility. The authors of CIFAR-100 aren't
            really explicit about any terms of use, so please
            read the website to make sure you want to download
            the dataset.
            """,
            "https://www.cs.toronto.edu/~kriz/cifar-100-binary.tar.gz",
            "58a81ae192c23a4be8b1804d68e518ed807d710a4eb253b1f2a199162a40d8ec",
            post_fetch_method = file -> (run(BinDeps.unpack_cmd(file,dirname(file), ".gz", ".tar")); rm(file))
        ))
    end
end
