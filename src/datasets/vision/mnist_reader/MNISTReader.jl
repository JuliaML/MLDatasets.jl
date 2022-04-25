module MNISTReader
    using GZip
    using BinDeps

    export
        readimages,
        readlabels

    # Constants

    const IMAGEOFFSET = 16
    const LABELOFFSET = 8

    # Includes

    include("readheader.jl")
    include("readimages.jl")
    include("readlabels.jl")
end
