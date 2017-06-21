module Reader
    using GZip
    using BinDeps

    export

        readtrainimages,
        readtestimages,
        readtrainimages,
        readtestlabels,

        download_helper

    # Constants

    const IMAGEOFFSET = 16
    const LABELOFFSET = 8

    const TRAINIMAGES = "train-images-idx3-ubyte.gz"
    const TRAINLABELS = "train-labels-idx1-ubyte.gz"
    const TESTIMAGES  = "t10k-images-idx3-ubyte.gz"
    const TESTLABELS  = "t10k-labels-idx1-ubyte.gz"

    # Includes

    include("readheader.jl")
    include("readimages.jl")
    include("readlabels.jl")
    include("download.jl")
end
