export FashionMNIST
module FashionMNIST
    using BinDeps
    using DataDeps
    using FixedPointNumbers
    using ..bytes_to_type
    using ..datafile
    using ..download_dep
    using ..download_docstring
    import ..MNIST.convert2image
    import ..MNIST.convert2features
    import ..MNIST.Reader

    export

        classnames,

        traintensor,
        testtensor,

        trainlabels,
        testlabels,

        traindata,
        testdata,

        convert2image,
        convert2features,

        download

    const DEPNAME = "FashionMNIST"
    const TRAINIMAGES = "train-images-idx3-ubyte.gz"
    const TRAINLABELS = "train-labels-idx1-ubyte.gz"
    const TESTIMAGES  = "t10k-images-idx3-ubyte.gz"
    const TESTLABELS  = "t10k-labels-idx1-ubyte.gz"

    const CLASSES = [
        "T-Shirt",
        "Trouser",
        "Pullover",
        "Dress",
        "Coat",
        "Sandal",
        "Shirt",
        "Sneaker",
        "Bag",
        "Ankle boot"
    ]

    download(args...; kw...) = download_dep(DEPNAME, args...; kw...)

    include("interface.jl")

    function __init__()
        register(DataDep(
            DEPNAME,
            """
            Dataset: Fashion-MNIST
            Authors: Han Xiao, Kashif Rasul, Roland Vollgraf
            Website: https://github.com/zalandoresearch/fashion-mnist
            License: MIT

            [Han Xiao et al. 2017]
                Han Xiao, Kashif Rasul, and Roland Vollgraf.
                "Fashion-MNIST: a Novel Image Dataset for Benchmarking Machine Learning Algorithms."
                arXiv:1708.07747

            The files are available for download at the offical
            website linked above. Note that using the data
            responsibly and respecting copyright remains your
            responsibility.
            """,
            "http://fashion-mnist.s3-website.eu-central-1.amazonaws.com/" .* [TRAINIMAGES, TRAINLABELS, TESTIMAGES, TESTLABELS],
            "c916b6e00d3083643332b70f3c5c3543d3941334b802e252976893969ee6af67",
        ))
    end
end
