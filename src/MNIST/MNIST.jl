export MNIST
module MNIST
    using ImageCore
    using ColorTypes
    import ..downloaded_file
    import ..download_helper
    import ..DownloadSettings

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

    const DEFAULT_DIR = abspath(joinpath(@__DIR__, "..", "..", "datasets", "mnist"))

    const TRAINIMAGES = "train-images-idx3-ubyte.gz"
    const TRAINLABELS = "train-labels-idx1-ubyte.gz"
    const TESTIMAGES  = "t10k-images-idx3-ubyte.gz"
    const TESTLABELS  = "t10k-labels-idx1-ubyte.gz"

    const SETTINGS = DownloadSettings(
        "http://yann.lecun.com/exdb/mnist/",
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
        [TRAINIMAGES, TRAINLABELS, TESTIMAGES, TESTLABELS]
    )

    download(dir = DEFAULT_DIR; kw...) =
        download_helper(SETTINGS, dir; kw...)

    include(joinpath("Reader","Reader.jl"))
    include("interface.jl")
    include("utils.jl")
end
