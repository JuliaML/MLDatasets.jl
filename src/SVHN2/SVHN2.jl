export SVHN2

"""
The Street View House Numbers (SVHN) Dataset

Authors: Yuval Netzer, Tao Wang, Adam Coates, Alessandro Bissacco, Bo Wu, Andrew Y. Ng
Website: http://ufldl.stanford.edu/housenumbers

SVHN was obtained from house numbers in Google Street View
images. As such they are quite diverse in terms of orientation
and image background. Similar to MNIST, SVHN has 10 classes (the
digits 0-9), but unlike MNIST there is more data and the images
are a little bigger (32x32 instead of 28x28) with an additional
RGB color channel. The dataset is split up into three subsets:
73257 digits for training, 26032 digits for testing, and 531131
additional to use as extra training data.

## Interface

- [SVHN2.traindata](@ref)
- [SVHN2.testdata](@ref)
- [SVHN2.extradata](@ref)

## Utilities

- [SVHN2.convert2features](@ref)
- [SVHN2.convert2image](@ref)
"""
module SVHN2
    using DataDeps
    using MAT
    using ImageCore
    using ColorTypes
    using FixedPointNumbers
    using ..bytes_to_type
    using ..datafile
    using ..download_dep
    using ..download_docstring

    export

        traindata,
        testdata,
        extradata,

        convert2image,
        convert2features,

        download

    const DEPNAME = "SVHN2"
    const TRAINDATA = "train_32x32.mat"
    const TESTDATA  = "test_32x32.mat"
    const EXTRADATA = "extra_32x32.mat"
    const CLASSES = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0]

    download(args...; kw...) = download_dep(DEPNAME, args...; kw...)

    include("interface.jl")
    include("utils.jl")

    function __init__()
        RegisterDataDep(
            DEPNAME,
            """
            Dataset: The Street View House Numbers (SVHN) Dataset
            Authors: Yuval Netzer, Tao Wang, Adam Coates, Alessandro Bissacco, Bo Wu, Andrew Y. Ng
            Website: http://ufldl.stanford.edu/housenumbers
            Format: Cropped Digits (Format 2 on the website)
            Note: for non-commercial use only

            [Netzer et al., 2011]
                Yuval Netzer, Tao Wang, Adam Coates, Alessandro Bissacco, Bo Wu, Andrew Y. Ng
                "Reading Digits in Natural Images with Unsupervised Feature Learning"
                NIPS Workshop on Deep Learning and Unsupervised Feature Learning 2011

            The dataset is split up into three subsets: 73257
            digits for training, 26032 digits for testing, and
            531131 additional to use as extra training data.

            The files are available for download at the official
            website linked above. Note that using the data
            responsibly and respecting copyright remains your
            responsibility. For example the website mentions that
            the data is for non-commercial use only. Please read
            the website to make sure you want to download the
            dataset.
            """,
            "http://ufldl.stanford.edu/housenumbers/" .* [TRAINDATA, TESTDATA, EXTRADATA],
        )
    end
end
