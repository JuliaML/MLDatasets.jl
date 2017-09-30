export FashionMNIST
module FashionMNIST
    using ImageCore
    using ColorTypes
    import ..downloaded_file
    import ..download_helper
    import ..DownloadSettings
    import ..MNIST.convert2image
    import ..MNIST.convert2features
    import ..MNIST.Reader

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

    const DEFAULT_DIR = abspath(joinpath(@__DIR__, "..", "..", "datasets", "fashion_mnist"))

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

    const SETTINGS = DownloadSettings(
        "http://fashion-mnist.s3-website.eu-central-1.amazonaws.com/",
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
        website linked above. We can download these files for you
        if you wish, but that doesn't free you from the burden of
        using the data responsibly and respect lincense and
        authorship.
        """,
        [TRAINIMAGES, TRAINLABELS, TESTIMAGES, TESTLABELS]
    )

    download(dir = DEFAULT_DIR; kw...) =
        download_helper(SETTINGS, dir; kw...)

    include("interface.jl")
end
