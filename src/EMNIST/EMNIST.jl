export EMNIST
module EMNIST
using DataDeps
using BinDeps
using FixedPointNumbers
using MAT: matopen, matread
using ..MLDatasets: bytes_to_type, datafile, download_dep, download_docstring

    const DEPNAME = "EMNIST"

    download(args...; kw...) = download_dep(DEPNAME, args...; kw...)

    function __init__()
        register(DataDep(
            DEPNAME,
            """
            Dataset: The EMNIST Dataset
            Authors: Gregory Cohen, Saeed Afshar, Jonathan Tapson, and Andre van Schaik
            Website: https://www.nist.gov/itl/products-and-services/emnist-dataset

            [Cohen et al., 2017]
                Cohen, G., Afshar, S., Tapson, J., & van Schaik, A. (2017).
                EMNIST: an extension of MNIST to handwritten letters.
                Retrieved from http://arxiv.org/abs/1702.05373

            The EMNIST dataset is a set of handwritten character digits derived from the
            NIST Special Database 19 (https://www.nist.gov/srd/nist-special-database-19)
            and converted to a 28x28 pixel image format and dataset structure that directly
            matches the MNIST dataset (http://yann.lecun.com/exdb/mnist/). Further information
            on the dataset contents and conversion process can be found in the paper available
            at https://arxiv.org/abs/1702.05373v1.

            The files are available for download at the official
            website linked above. Note that using the data
            responsibly and respecting copyright remains your
            responsibility. For example the website mentions that
            the data is for non-commercial use only. Please read
            the website to make sure you want to download the
            dataset.
            """,
            "http://www.itl.nist.gov/iaui/vip/cs_links/EMNIST/matlab.zip",
            "e1fa805cdeae699a52da0b77c2db17f6feb77eed125f9b45c022e7990444df95",
            post_fetch_method = file -> (run(BinDeps.unpack_cmd(file,dirname(file),".zip","")); rm(file))
        ))
    end

    module Balanced
        using DataDeps
        using BinDeps
        using FixedPointNumbers
        using MAT: matopen, matread
        using ...MLDatasets: bytes_to_type, datafile, download_dep, download_docstring

        const DEPNAME = "EMNIST"
        const FILENAME = "matlab/emnist-balanced.mat"

        function traindata(; dir = nothing)
            path = datafile(DEPNAME, FILENAME, dir)
            vars = matread(path)
            return reshape(vars["dataset"]["train"]["images"],:,28,28)
        end

        function testdata(; dir = nothing)
            path = datafile(DEPNAME, FILENAME, dir)
            vars = matread(path)
            return reshape(vars["dataset"]["test"]["images"],:,28,28)
        end

        function trainlabels(; dir = nothing)
            path = datafile(DEPNAME, FILENAME, dir)
            vars = matread(path)
            return vars["dataset"]["train"]["labels"]
        end

        function testlabels(; dir = nothing)
            path = datafile(DEPNAME, FILENAME, dir)
            vars = matread(path)
            return vars["dataset"]["test"]["labels"]
        end
    end

    module ByClass
        using DataDeps
        using BinDeps
        using FixedPointNumbers
        using MAT: matopen, matread
        using ...MLDatasets: bytes_to_type, datafile, download_dep, download_docstring
        
        const DEPNAME = "EMNIST"
        const FILENAME = "matlab/emnist-byclass.mat"

        function traindata(; dir = nothing)
            path = datafile(DEPNAME, FILENAME, dir)
            vars = matread(path)
            return reshape(vars["dataset"]["train"]["images"],:,28,28)
        end

        function testdata(; dir = nothing)
            path = datafile(DEPNAME, FILENAME, dir)
            vars = matread(path)
            return reshape(vars["dataset"]["test"]["images"],:,28,28)
        end

        function trainlabels(; dir = nothing)
            path = datafile(DEPNAME, FILENAME, dir)
            vars = matread(path)
            return vars["dataset"]["train"]["labels"]
        end

        function testlabels(; dir = nothing)
            path = datafile(DEPNAME, FILENAME, dir)
            vars = matread(path)
            return vars["dataset"]["test"]["labels"]
        end
    end

    module ByMerge
        using DataDeps
        using BinDeps
        using FixedPointNumbers
        using MAT: matopen, matread
        using ...MLDatasets: bytes_to_type, datafile, download_dep, download_docstring
        
        const DEPNAME = "EMNIST"
        const FILENAME = "matlab/emnist-bymerge.mat"

        function traindata(; dir = nothing)
            path = datafile(DEPNAME, FILENAME, dir)
            vars = matread(path)
            return reshape(vars["dataset"]["train"]["images"],:,28,28)
        end

        function testdata(; dir = nothing)
            path = datafile(DEPNAME, FILENAME, dir)
            vars = matread(path)
            return reshape(vars["dataset"]["test"]["images"],:,28,28)
        end

        function trainlabels(; dir = nothing)
            path = datafile(DEPNAME, FILENAME, dir)
            vars = matread(path)
            return vars["dataset"]["train"]["labels"]
        end

        function testlabels(; dir = nothing)
            path = datafile(DEPNAME, FILENAME, dir)
            vars = matread(path)
            return vars["dataset"]["test"]["labels"]
        end
    end

    module Digits
        using DataDeps
        using BinDeps
        using FixedPointNumbers
        using MAT: matopen, matread
        using ...MLDatasets: bytes_to_type, datafile, download_dep, download_docstring
        
        const DEPNAME = "EMNIST"
        const FILENAME = "matlab/emnist-digits.mat"

        function traindata(; dir = nothing)
            path = datafile(DEPNAME, FILENAME, dir)
            vars = matread(path)
            return reshape(vars["dataset"]["train"]["images"],:,28,28)
        end

        function testdata(; dir = nothing)
            path = datafile(DEPNAME, FILENAME, dir)
            vars = matread(path)
            return reshape(vars["dataset"]["test"]["images"],:,28,28)
        end

        function trainlabels(; dir = nothing)
            path = datafile(DEPNAME, FILENAME, dir)
            vars = matread(path)
            return vars["dataset"]["train"]["labels"]
        end

        function testlabels(; dir = nothing)
            path = datafile(DEPNAME, FILENAME, dir)
            vars = matread(path)
            return vars["dataset"]["test"]["labels"]
        end
    end

    module Letters
        using DataDeps
        using BinDeps
        using FixedPointNumbers
        using MAT: matopen, matread
        using ...MLDatasets: bytes_to_type, datafile, download_dep, download_docstring
        
        const DEPNAME = "EMNIST"
        const FILENAME = "matlab/emnist-letters.mat"

        function traindata(; dir = nothing)
            path = datafile(DEPNAME, FILENAME, dir)
            vars = matread(path)
            return reshape(vars["dataset"]["train"]["images"],:,28,28)
        end

        function testdata(; dir = nothing)
            path = datafile(DEPNAME, FILENAME, dir)
            vars = matread(path)
            return reshape(vars["dataset"]["test"]["images"],:,28,28)
        end

        function trainlabels(; dir = nothing)
            path = datafile(DEPNAME, FILENAME, dir)
            vars = matread(path)
            return vars["dataset"]["train"]["labels"]
        end

        function testlabels(; dir = nothing)
            path = datafile(DEPNAME, FILENAME, dir)
            vars = matread(path)
            return vars["dataset"]["test"]["labels"]
        end
    end

    module MNIST
        using DataDeps
        using BinDeps
        using FixedPointNumbers
        using MAT: matopen, matread
        using ...MLDatasets: bytes_to_type, datafile, download_dep, download_docstring
        
        const DEPNAME = "EMNIST"
        const FILENAME = "matlab/emnist-mnist.mat"

        function traindata(; dir = nothing)
            path = datafile(DEPNAME, FILENAME, dir)
            vars = matread(path)
            return reshape(vars["dataset"]["train"]["images"],:,28,28)
        end

        function testdata(; dir = nothing)
            path = datafile(DEPNAME, FILENAME, dir)
            vars = matread(path)
            return reshape(vars["dataset"]["test"]["images"],:,28,28)
        end

        function trainlabels(; dir = nothing)
            path = datafile(DEPNAME, FILENAME, dir)
            vars = matread(path)
            return vars["dataset"]["train"]["labels"]
        end

        function testlabels(; dir = nothing)
            path = datafile(DEPNAME, FILENAME, dir)
            vars = matread(path)
            return vars["dataset"]["test"]["labels"]
        end
    end
end
