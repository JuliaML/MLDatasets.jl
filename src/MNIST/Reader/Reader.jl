module Reader
    using GZip
    using BinDeps
    import ...MLDatasets.download_helper
    export
        readtrainimages,
        readtestimages,
        readtrainimages,
        readtestlabels

    # Constants

    const IMAGEOFFSET = 16
    const LABELOFFSET = 8

    const TRAINIMAGES = "train-images-idx3-ubyte.gz"
    const TRAINLABELS = "train-labels-idx1-ubyte.gz"
    const TESTIMAGES  = "t10k-images-idx3-ubyte.gz"
    const TESTLABELS  = "t10k-labels-idx1-ubyte.gz"

    # Includes

    include("download.jl")
    include("readheader.jl")
    include("readimages.jl")
    include("readlabels.jl")
end
