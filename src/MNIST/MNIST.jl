export MNIST
module MNIST
    using BinDeps
    using DataDeps
    using ImageCore
    using ColorTypes
    using FixedPointNumbers
    using ..bytes_to_type
    using ..datafile
    using ..download_dep
    using ..download_docstring

    export

        traintensor,
        testtensor,

        trainlabels,
        testlabels,

        traindata,
        testdata,

        convert2image,
        convert2features,

        download

    const DEPNAME = "MNIST"
    const TRAINIMAGES = "train-images-idx3-ubyte.gz"
    const TRAINLABELS = "train-labels-idx1-ubyte.gz"
    const TESTIMAGES  = "t10k-images-idx3-ubyte.gz"
    const TESTLABELS  = "t10k-labels-idx1-ubyte.gz"

    download(args...; kw...) = download_dep(DEPNAME, args...; kw...)

    include(joinpath("Reader","Reader.jl"))
    include("interface.jl")
    include("utils.jl")

    function __init__()
        RegisterDataDep(
            DEPNAME,
            """
            Dataset: THE MNIST DATABASE of handwritten digits
            Authors: Yann LeCun, Corinna Cortes, Christopher J.C. Burges
            Website: http://yann.lecun.com/exdb/mnist/

            [LeCun et al., 1998a]
                Y. LeCun, L. Bottou, Y. Bengio, and P. Haffner.
                "Gradient-based learning applied to document recognition."
                Proceedings of the IEEE, 86(11):2278-2324, November 1998

            The files are available for download at the offical
            website linked above. We can download these files for you
            if you wish, but that doesn't free you from the burden of
            using the data responsibly and respect copyright. The
            authors of MNIST aren't really explicit about any terms
            of use, so please read the website to make sure you want
            to download the dataset.
            """,
            "http://yann.lecun.com/exdb/mnist/" .* [TRAINIMAGES, TRAINLABELS, TESTIMAGES, TESTLABELS],
            "0bb1d5775d852fc5bb32c76ca15a7eb4e9a3b1514a2493f7edfcf49b639d7975",
            fetch_method = (src, dst) -> run(BinDeps.download_cmd(src, dst))
        )
    end
end
