var documenterSearchIndex = {"docs": [

{
    "location": "#",
    "page": "Home",
    "title": "Home",
    "category": "page",
    "text": ""
},

{
    "location": "#MLDatasets.jl\'s-Documentation-1",
    "page": "Home",
    "title": "MLDatasets.jl\'s Documentation",
    "category": "section",
    "text": "This package represents a community effort to provide a common interface for accessing common Machine Learning (ML) datasets. In contrast to other data-related Julia packages, the focus of MLDatasets.jl is specifically on downloading, unpacking, and accessing benchmark dataset. Functionality for the purpose of data processing or visualization is only provided to a degree that is special to some dataset.This package is a part of the JuliaML ecosystem. Its functionality is build on top of the package DataDeps.jl."
},

{
    "location": "#Installation-1",
    "page": "Home",
    "title": "Installation",
    "category": "section",
    "text": "To install MLDatasets.jl, start up Julia and type the following code snippet into the REPL. It makes use of the native Julia package manger.Pkg.add(\"MLDatasets\")Additionally, for example if you encounter any sudden issues, or in the case you would like to contribute to the package, you can manually choose to be on the latest (untagged) version.Pkg.checkout(\"MLDatasets\")"
},

{
    "location": "#Basic-Usage-1",
    "page": "Home",
    "title": "Basic Usage",
    "category": "section",
    "text": "The way MLDatasets.jl is organized is that each dataset has its own dedicated sub-module. Where possible, those sub-module share a common interface for interacting with the datasets. For example you can load the training set and the test set of the MNIST database of handwritten digits using the following commands:using MLDatasets\n\ntrain_x, train_y = MNIST.traindata()\ntest_x,  test_y  = MNIST.testdata()To load the data the package looks for the necessary files in various locations (see DataDeps.jl for more information on how to configure such defaults). If the data can\'t be found in any of those locations, then the package will trigger a download dialog to ~/.julia/datadeps/MNIST. To overwrite this on a case by case basis, it is possible to specify a data directory directly in traindata(dir = <directory>) and testdata(dir = <directory>)."
},

{
    "location": "#Available-Datasets-1",
    "page": "Home",
    "title": "Available Datasets",
    "category": "section",
    "text": "Each dataset has its own dedicated sub-module. As such, it makes sense to document their functionality similarly distributed. Find below a list of available datasets and their documentation."
},

{
    "location": "#Image-Classification-1",
    "page": "Home",
    "title": "Image Classification",
    "category": "section",
    "text": "This package provides a variety of common benchmark datasets for the purpose of image classification.Dataset Classes traintensor trainlabels testtensor testlabels\nMNIST 10 28x28x60000 60000 28x28x10000 10000\nFashionMNIST 10 28x28x60000 60000 28x28x10000 10000\nCIFAR-10 10 32x32x3x50000 50000 32x32x3x10000 10000\nCIFAR-100 100 (20) 32x32x3x50000 50000 (x2) 32x32x3x10000 10000 (x2)"
},

{
    "location": "#Language-Modeling-1",
    "page": "Home",
    "title": "Language Modeling",
    "category": "section",
    "text": "Work in progress"
},

{
    "location": "#Index-1",
    "page": "Home",
    "title": "Index",
    "category": "section",
    "text": "Pages = [\"indices.md\"]"
},

{
    "location": "datasets/MNIST/#",
    "page": "MNIST handwritten digits",
    "title": "MNIST handwritten digits",
    "category": "page",
    "text": ""
},

{
    "location": "datasets/MNIST/#MNIST-1",
    "page": "MNIST handwritten digits",
    "title": "The MNIST database of handwritten digits",
    "category": "section",
    "text": "Description from the official website:The MNIST database of handwritten digits, available from this page, has a training set of 60,000 examples, and a test set of 10,000 examples. It is a subset of a larger set available from NIST. The digits have been size-normalized and centered in a fixed-size image.It is a good database for people who want to try learning techniques and pattern recognition methods on real-world data while spending minimal efforts on preprocessing and formatting."
},

{
    "location": "datasets/MNIST/#Contents-1",
    "page": "MNIST handwritten digits",
    "title": "Contents",
    "category": "section",
    "text": "Pages = [\"MNIST.md\"]\nDepth = 3"
},

{
    "location": "datasets/MNIST/#Overview-1",
    "page": "MNIST handwritten digits",
    "title": "Overview",
    "category": "section",
    "text": "The MLDatasets.MNIST sub-module provides a programmatic interface to download, load, and work with the MNIST dataset of handwritten digits.using MLDatasets\n\n# load full training set\ntrain_x, train_y = MNIST.traindata()\n\n# load full test set\ntest_x,  test_y  = MNIST.testdata()The provided functions also allow for optional arguments, such as the directory dir where the dataset is located, or the specific observation indices that one wants to work with. For more information on the interface take a look at the documentation (e.g. ?MNIST.traindata).Function Description\ndownload([dir]) Trigger (interactive) download of the dataset\ntraintensor([T], [indices]; [dir]) Load the training images as an array of eltype T\ntrainlabels([indices]; [dir]) Load the labels for the training images\ntesttensor([T], [indices]; [dir]) Load the test images as an array of eltype T\ntestlabels([indices]; [dir]) Load the labels for the test images\ntraindata([T], [indices]; [dir]) Load images and labels of the training data\ntestdata([T], [indices]; [dir]) Load images and labels of the test dataThis module also provides utility functions to make working with the MNIST dataset in Julia more convenient.Function Description\nconvert2features(array) Convert the MNIST tensor to a flat feature matrix\nconvert2image(array) Convert the MNIST tensor/matrix to a colorant arrayYou can use the function convert2features to convert the given MNIST tensor to a feature matrix (or feature vector in the case of a single image). The purpose of this function is to drop the spatial dimensions such that traditional ML algorithms can process the dataset.julia> MNIST.convert2features(MNIST.traintensor()) # full training data\n784×60000 Array{N0f8,2}:\n[...]To visualize an image or a prediction we provide the function convert2image to convert the given MNIST horizontal-major tensor (or feature matrix) to a vertical-major Colorant array. The values are also color corrected according to the website\'s description, which means that the digits are black on a white background.julia> MNIST.convert2image(MNIST.traintensor(1)) # first training image\n28×28 Array{Gray{N0f8},2}:\n[...]"
},

{
    "location": "datasets/MNIST/#API-Documentation-1",
    "page": "MNIST handwritten digits",
    "title": "API Documentation",
    "category": "section",
    "text": ""
},

{
    "location": "datasets/MNIST/#MLDatasets.MNIST.traintensor",
    "page": "MNIST handwritten digits",
    "title": "MLDatasets.MNIST.traintensor",
    "category": "Function",
    "text": "traintensor([T = N0f8], [indices]; [dir]) -> Array{T}\n\nReturns the MNIST training images corresponding to the given indices as a multi-dimensional array of eltype T.\n\nThe image(s) is/are returned in the native horizontal-major memory layout as a single numeric array. If T <: Integer, then all values will be within 0 and 255, otherwise the values are scaled to be between 0 and 1.\n\nIf the parameter indices is omitted or an AbstractVector, the images are returned as a 3D array (i.e. a Array{T,3}), in which the first dimension corresponds to the pixel rows (x) of the image, the second dimension to the pixel columns (y) of the image, and the third dimension denotes the index of the image.\n\njulia> MNIST.traintensor() # load all training images\n28×28×60000 Array{N0f8,3}:\n[...]\n\njulia> MNIST.traintensor(Float32, 1:3) # first three images as Float32\n28×28×3 Array{Float32,3}:\n[...]\n\nIf indices is an Integer, the single image is returned as Matrix{T} in horizontal-major layout, which means that the first dimension denotes the pixel rows (x), and the second dimension denotes the pixel columns (y) of the image.\n\njulia> MNIST.traintensor(1) # load first training image\n28×28 Array{N0f8,2}:\n[...]\n\nAs mentioned above, the images are returned in the native horizontal-major layout to preserve the original feature ordering. You can use the utility function convert2image to convert an MNIST array into a vertical-major Julia image with the corrected color values.\n\njulia> MNIST.convert2image(MNIST.traintensor(1)) # convert to column-major colorant array\n28×28 Array{Gray{N0f8},2}:\n[...]\n\nThe corresponding resource file(s) of the dataset is/are expected to be located in the specified directory dir. If dir is omitted the directories in DataDeps.default_loadpath will be searched for an existing MNIST subfolder. In case no such subfolder is found, dir will default to ~/.julia/datadeps/MNIST. In the case that dir does not yet exist, a download prompt will be triggered. You can also use MNIST.download([dir]) explicitly for pre-downloading (or re-downloading) the dataset. Please take a look at the documentation of the package DataDeps.jl for more detail and configuration options.\n\n\n\n"
},

{
    "location": "datasets/MNIST/#MLDatasets.MNIST.trainlabels",
    "page": "MNIST handwritten digits",
    "title": "MLDatasets.MNIST.trainlabels",
    "category": "Function",
    "text": "trainlabels([indices]; [dir])\n\nReturns the MNIST trainset labels corresponding to the given indices as an Int or Vector{Int}. The values of the labels denote the digit that they represent. If indices is omitted, all labels are returned.\n\njulia> MNIST.trainlabels() # full training set\n60000-element Array{Int64,1}:\n 5\n 0\n ⋮\n 6\n 8\n\njulia> MNIST.trainlabels(1:3) # first three labels\n3-element Array{Int64,1}:\n 5\n 0\n 4\n\njulia> MNIST.trainlabels(1) # first label\n5\n\nThe corresponding resource file(s) of the dataset is/are expected to be located in the specified directory dir. If dir is omitted the directories in DataDeps.default_loadpath will be searched for an existing MNIST subfolder. In case no such subfolder is found, dir will default to ~/.julia/datadeps/MNIST. In the case that dir does not yet exist, a download prompt will be triggered. You can also use MNIST.download([dir]) explicitly for pre-downloading (or re-downloading) the dataset. Please take a look at the documentation of the package DataDeps.jl for more detail and configuration options.\n\n\n\n"
},

{
    "location": "datasets/MNIST/#MLDatasets.MNIST.traindata",
    "page": "MNIST handwritten digits",
    "title": "MLDatasets.MNIST.traindata",
    "category": "Function",
    "text": "traindata([T = N0f8], [indices]; [dir]) -> Tuple\n\nReturns the MNIST trainingset corresponding to the given indices as a two-element tuple. If indices is omitted the full trainingset is returned. The first element of three return values will be the images as a multi-dimensional array, and the second element the corresponding labels as integers.\n\nThe image(s) is/are returned in the native horizontal-major memory layout as a single numeric array of eltype T. If T <: Integer, then all values will be within 0 and 255, otherwise the values are scaled to be between 0 and 1. The integer values of the labels correspond 1-to-1 the digit that they represent.\n\ntrain_x, train_y = MNIST.traindata() # full datatset\ntrain_x, train_y = MNIST.traindata(2) # only second observation\ntrain_x, train_y = MNIST.traindata(dir=\"./MNIST\") # custom folder\n\nThe corresponding resource file(s) of the dataset is/are expected to be located in the specified directory dir. If dir is omitted the directories in DataDeps.default_loadpath will be searched for an existing MNIST subfolder. In case no such subfolder is found, dir will default to ~/.julia/datadeps/MNIST. In the case that dir does not yet exist, a download prompt will be triggered. You can also use MNIST.download([dir]) explicitly for pre-downloading (or re-downloading) the dataset. Please take a look at the documentation of the package DataDeps.jl for more detail and configuration options.\n\nTake a look at MNIST.traintensor and MNIST.trainlabels for more information.\n\n\n\n"
},

{
    "location": "datasets/MNIST/#Trainingset-1",
    "page": "MNIST handwritten digits",
    "title": "Trainingset",
    "category": "section",
    "text": "MNIST.traintensor\nMNIST.trainlabels\nMNIST.traindata"
},

{
    "location": "datasets/MNIST/#MLDatasets.MNIST.testtensor",
    "page": "MNIST handwritten digits",
    "title": "MLDatasets.MNIST.testtensor",
    "category": "Function",
    "text": "testtensor([T = N0f8], [indices]; [dir]) -> Array{T}\n\nReturns the MNIST test images corresponding to the given indices as a multi-dimensional array of eltype T.\n\nThe image(s) is/are returned in the native horizontal-major memory layout as a single numeric array. If T <: Integer, then all values will be within 0 and 255, otherwise the values are scaled to be between 0 and 1.\n\nIf the parameter indices is omitted or an AbstractVector, the images are returned as a 3D array (i.e. a Array{T,3}), in which the first dimension corresponds to the pixel rows (x) of the image, the second dimension to the pixel columns (y) of the image, and the third dimension denotes the index of the image.\n\njulia> MNIST.testtensor() # load all test images\n28×28×10000 Array{N0f8,3}:\n[...]\n\njulia> MNIST.testtensor(Float32, 1:3) # first three images as Float32\n28×28×3 Array{Float32,3}:\n[...]\n\nIf indices is an Integer, the single image is returned as Matrix{T} in horizontal-major layout, which means that the first dimension denotes the pixel rows (x), and the second dimension denotes the pixel columns (y) of the image.\n\njulia> MNIST.testtensor(1) # load first test image\n28×28 Array{N0f8,2}:\n[...]\n\nAs mentioned above, the images are returned in the native horizontal-major layout to preserve the original feature ordering. You can use the utility function convert2image to convert an MNIST array into a vertical-major Julia image with the corrected color values.\n\njulia> MNIST.convert2image(MNIST.testtensor(1)) # convert to column-major colorant array\n28×28 Array{Gray{N0f8},2}:\n[...]\n\nThe corresponding resource file(s) of the dataset is/are expected to be located in the specified directory dir. If dir is omitted the directories in DataDeps.default_loadpath will be searched for an existing MNIST subfolder. In case no such subfolder is found, dir will default to ~/.julia/datadeps/MNIST. In the case that dir does not yet exist, a download prompt will be triggered. You can also use MNIST.download([dir]) explicitly for pre-downloading (or re-downloading) the dataset. Please take a look at the documentation of the package DataDeps.jl for more detail and configuration options.\n\n\n\n"
},

{
    "location": "datasets/MNIST/#MLDatasets.MNIST.testlabels",
    "page": "MNIST handwritten digits",
    "title": "MLDatasets.MNIST.testlabels",
    "category": "Function",
    "text": "testlabels([indices]; [dir])\n\nReturns the MNIST testset labels corresponding to the given indices as an Int or Vector{Int}. The values of the labels denote the digit that they represent. If indices is omitted, all labels are returned.\n\njulia> MNIST.testlabels() # full test set\n10000-element Array{Int64,1}:\n 7\n 2\n ⋮\n 5\n 6\n\njulia> MNIST.testlabels(1:3) # first three labels\n3-element Array{Int64,1}:\n 7\n 2\n 1\n\njulia> MNIST.testlabels(1) # first label\n7\n\nThe corresponding resource file(s) of the dataset is/are expected to be located in the specified directory dir. If dir is omitted the directories in DataDeps.default_loadpath will be searched for an existing MNIST subfolder. In case no such subfolder is found, dir will default to ~/.julia/datadeps/MNIST. In the case that dir does not yet exist, a download prompt will be triggered. You can also use MNIST.download([dir]) explicitly for pre-downloading (or re-downloading) the dataset. Please take a look at the documentation of the package DataDeps.jl for more detail and configuration options.\n\n\n\n"
},

{
    "location": "datasets/MNIST/#MLDatasets.MNIST.testdata",
    "page": "MNIST handwritten digits",
    "title": "MLDatasets.MNIST.testdata",
    "category": "Function",
    "text": "testdata([T = N0f8], [indices]; [dir]) -> Tuple\n\nReturns the MNIST testset corresponding to the given indices as a two-element tuple. If indices is omitted the full testset is returned. The first element of three return values will be the images as a multi-dimensional array, and the second element the corresponding labels as integers.\n\nThe image(s) is/are returned in the native horizontal-major memory layout as a single numeric array of eltype T. If T <: Integer, then all values will be within 0 and 255, otherwise the values are scaled to be between 0 and 1. The integer values of the labels correspond 1-to-1 the digit that they represent.\n\ntest_x, test_y = MNIST.testdata() # full datatset\ntest_x, test_y = MNIST.testdata(2) # only second observation\ntest_x, test_y = MNIST.testdata(dir=\"./MNIST\") # custom folder\n\nThe corresponding resource file(s) of the dataset is/are expected to be located in the specified directory dir. If dir is omitted the directories in DataDeps.default_loadpath will be searched for an existing MNIST subfolder. In case no such subfolder is found, dir will default to ~/.julia/datadeps/MNIST. In the case that dir does not yet exist, a download prompt will be triggered. You can also use MNIST.download([dir]) explicitly for pre-downloading (or re-downloading) the dataset. Please take a look at the documentation of the package DataDeps.jl for more detail and configuration options.\n\nTake a look at MNIST.testtensor and MNIST.testlabels for more information.\n\n\n\n"
},

{
    "location": "datasets/MNIST/#Testset-1",
    "page": "MNIST handwritten digits",
    "title": "Testset",
    "category": "section",
    "text": "MNIST.testtensor\nMNIST.testlabels\nMNIST.testdata"
},

{
    "location": "datasets/MNIST/#MLDatasets.MNIST.convert2features",
    "page": "MNIST handwritten digits",
    "title": "MLDatasets.MNIST.convert2features",
    "category": "Function",
    "text": "convert2features(array)\n\nConvert the given MNIST tensor to a feature matrix (or feature vector in the case of a single image). The purpose of this function is to drop the spatial dimensions such that traditional ML algorithms can process the dataset.\n\njulia> MNIST.convert2features(MNIST.traintensor()) # full training data\n784×60000 Array{N0f8,2}:\n[...]\n\njulia> MNIST.convert2features(MNIST.traintensor(1)) # first observation\n784-element Array{N0f8,1}:\n[...]\n\n\n\n"
},

{
    "location": "datasets/MNIST/#MLDatasets.MNIST.convert2image",
    "page": "MNIST handwritten digits",
    "title": "MLDatasets.MNIST.convert2image",
    "category": "Function",
    "text": "convert2image(array) -> Array{Gray}\n\nConvert the given MNIST horizontal-major tensor (or feature matrix) to a vertical-major Colorant array. The values are also color corrected according to the website\'s description, which means that the digits are black on a white background.\n\njulia> MNIST.convert2image(MNIST.traintensor()) # full training dataset\n28×28×60000 Array{Gray{N0f8},3}:\n[...]\n\njulia> MNIST.convert2image(MNIST.traintensor(1)) # first training image\n28×28 Array{Gray{N0f8},2}:\n[...]\n\n\n\n"
},

{
    "location": "datasets/MNIST/#Utilities-1",
    "page": "MNIST handwritten digits",
    "title": "Utilities",
    "category": "section",
    "text": "MNIST.convert2features\nMNIST.convert2image"
},

{
    "location": "datasets/MNIST/#MLDatasets.MNIST.Reader.readimages-Tuple{IO,AbstractArray{T,1} where T,Integer,Integer}",
    "page": "MNIST handwritten digits",
    "title": "MLDatasets.MNIST.Reader.readimages",
    "category": "Method",
    "text": "readimages(io::IO, indices::AbstractVector, nrows::Integer, ncols::Integer)\n\nReads the first nrows * ncols bytes for each image index in indices and stores them in a Array{UInt8,3} of size (nrows, ncols, length(indices)) in the same order as denoted by indices.\n\n\n\n"
},

{
    "location": "datasets/MNIST/#MLDatasets.MNIST.Reader.readimages-Tuple{IO,Any}",
    "page": "MNIST handwritten digits",
    "title": "MLDatasets.MNIST.Reader.readimages",
    "category": "Method",
    "text": "readimages(file, [indices])\n\nReads the images denoted by indices from file. The given file can either be specified using an IO-stream or a string that denotes the fully qualified path. The conent of file is assumed to be in the MNIST image-file format, as it is described on the official homepage at http://yann.lecun.com/exdb/mnist/\n\nif indices is an Integer, the single image is returned as Matrix{UInt8} in horizontal major layout, which means that the first dimension denotes the pixel rows (x), and the second dimension denotes the pixel columns (y) of the image.\nif indices is a AbstractVector, the images are returned as a 3D array (i.e. a Array{UInt8,3}), in which the first dimension corresponds to the pixel rows (x) of the image, the second dimension to the pixel columns (y) of the image, and the third dimension denotes the index of the image.\nif indices is ommited all images are returned (as 3D array described above)\n\n\n\n"
},

{
    "location": "datasets/MNIST/#MLDatasets.MNIST.Reader.readimages-Tuple{IO,Integer,Integer,Integer}",
    "page": "MNIST handwritten digits",
    "title": "MLDatasets.MNIST.Reader.readimages",
    "category": "Method",
    "text": "readimages(io::IO, index::Integer, nrows::Integer, ncols::Integer)\n\nJumps to the position of io where the bytes for the index\'th image are located and reads the next nrows * ncols bytes. The read bytes are returned as a Matrix{UInt8} of size (nrows, ncols).\n\n\n\n"
},

{
    "location": "datasets/MNIST/#MLDatasets.MNIST.Reader.readlabels-Tuple{AbstractString,Integer}",
    "page": "MNIST handwritten digits",
    "title": "MLDatasets.MNIST.Reader.readlabels",
    "category": "Method",
    "text": "readlabels(file::AbstractString, [indices])\n\nReads the label denoted by indices from file. The given file is assumed to be in the MNIST label-file format, as it is described on the official homepage at http://yann.lecun.com/exdb/mnist/\n\nif indices is an Integer, the single label is returned as UInt8.\nif indices is a AbstractVector, the labels are returned as a Vector{UInt8}, length length(indices) in the same order as denoted by indices.\nif indices is ommited all all are returned (as Vector{UInt8} as described above)\n\n\n\n"
},

{
    "location": "datasets/MNIST/#MLDatasets.MNIST.Reader.readlabels-Tuple{IO,AbstractArray{T,1} where T}",
    "page": "MNIST handwritten digits",
    "title": "MLDatasets.MNIST.Reader.readlabels",
    "category": "Method",
    "text": "readlabels(io::IO, indices::AbstractVector)\n\nReads the byte for each label-index in indices and stores them in a Vector{UInt8} of length length(indices) in the same order as denoted by indices.\n\n\n\n"
},

{
    "location": "datasets/MNIST/#MLDatasets.MNIST.Reader.readlabels-Tuple{IO,Integer}",
    "page": "MNIST handwritten digits",
    "title": "MLDatasets.MNIST.Reader.readlabels",
    "category": "Method",
    "text": "readlabels(io::IO, index::Integer)\n\nJumps to the position of io where the byte for the index\'th label is located and returns the byte at that position as UInt8\n\n\n\n"
},

{
    "location": "datasets/MNIST/#MLDatasets.MNIST.Reader.readimageheader-Tuple{AbstractString}",
    "page": "MNIST handwritten digits",
    "title": "MLDatasets.MNIST.Reader.readimageheader",
    "category": "Method",
    "text": "readimageheader(file::AbstractString)\n\nOpens and reads the first four 32 bits values of file and returns them interpreted as an MNIST-image-file header\n\n\n\n"
},

{
    "location": "datasets/MNIST/#MLDatasets.MNIST.Reader.readimageheader-Tuple{IO}",
    "page": "MNIST handwritten digits",
    "title": "MLDatasets.MNIST.Reader.readimageheader",
    "category": "Method",
    "text": "readimageheader(io::IO)\n\nReads four 32 bit integers at the current position of io and interprets them as a MNIST-image-file header, which is described in detail in the table below\n\n        ║     First    │  Second  │  Third  │   Fourth\n════════╬══════════════╪══════════╪═════════╪════════════\noffset  ║         0000 │     0004 │    0008 │       0012\ndescr   ║ magic number │ # images │  # rows │  # columns\n\nThese four numbers are returned as a Tuple in the same storage order\n\n\n\n"
},

{
    "location": "datasets/MNIST/#MLDatasets.MNIST.Reader.readlabelheader-Tuple{AbstractString}",
    "page": "MNIST handwritten digits",
    "title": "MLDatasets.MNIST.Reader.readlabelheader",
    "category": "Method",
    "text": "readlabelheader(file::AbstractString)\n\nOpens and reads the first two 32 bits values of file and returns them interpreted as an MNIST-label-file header\n\n\n\n"
},

{
    "location": "datasets/MNIST/#MLDatasets.MNIST.Reader.readlabelheader-Tuple{IO}",
    "page": "MNIST handwritten digits",
    "title": "MLDatasets.MNIST.Reader.readlabelheader",
    "category": "Method",
    "text": "readlabelheader(io::IO)\n\nReads two 32 bit integers at the current position of io and interprets them as a MNIST-label-file header, which consists of a magic number and the total number of labels stored in the file. These two numbers are returned as a Tuple in the same storage order.\n\n\n\n"
},

{
    "location": "datasets/MNIST/#Reader-Sub-module-1",
    "page": "MNIST handwritten digits",
    "title": "Reader Sub-module",
    "category": "section",
    "text": "Modules = [MLDatasets.MNIST.Reader]\nOrder   = [:function]"
},

{
    "location": "datasets/MNIST/#References-1",
    "page": "MNIST handwritten digits",
    "title": "References",
    "category": "section",
    "text": "Authors: Yann LeCun, Corinna Cortes, Christopher J.C. Burges\nWebsite: http://yann.lecun.com/exdb/mnist/\n[LeCun et al., 1998a] Y. LeCun, L. Bottou, Y. Bengio, and P. Haffner. \"Gradient-based learning applied to document recognition.\" Proceedings of the IEEE, 86(11):2278-2324, November 1998"
},

{
    "location": "datasets/FashionMNIST/#",
    "page": "Fashion MNIST",
    "title": "Fashion MNIST",
    "category": "page",
    "text": ""
},

{
    "location": "datasets/FashionMNIST/#FashionMNIST-1",
    "page": "Fashion MNIST",
    "title": "Fashion-MNIST",
    "category": "section",
    "text": "Description from the official websiteFashion-MNIST is a dataset of Zalando\'s article images—consisting of a training set of 60,000 examples and a test set of 10,000 examples. Each example is a 28x28 grayscale image, associated with a label from 10 classes. We intend Fashion-MNIST to serve as a direct drop-in replacement for the original MNIST dataset for benchmarking machine learning algorithms. It shares the same image size and structure of training and testing splits."
},

{
    "location": "datasets/FashionMNIST/#Contents-1",
    "page": "Fashion MNIST",
    "title": "Contents",
    "category": "section",
    "text": "Pages = [\"FashionMNIST.md\"]\nDepth = 3"
},

{
    "location": "datasets/FashionMNIST/#Overview-1",
    "page": "Fashion MNIST",
    "title": "Overview",
    "category": "section",
    "text": "The MLDatasets.FashionMNIST sub-module provides a programmatic interface to download, load, and work with the Fashion-MNIST dataset.using MLDatasets\n\n# load full training set\ntrain_x, train_y = FashionMNIST.traindata()\n\n# load full test set\ntest_x,  test_y  = FashionMNIST.testdata()The provided functions also allow for optional arguments, such as the directory dir where the dataset is located, or the specific observation indices that one wants to work with. For more information on the interface take a look at the documentation (e.g. ?FashionMNIST.traindata).Function Description\ndownload([dir]) Trigger (interactive) download of the dataset\nclassnames() Return the class names as a vector of strings\ntraintensor([T], [indices]; [dir]) Load the training images as an array of eltype T\ntrainlabels([indices]; [dir]) Load the labels for the training images\ntesttensor([T], [indices]; [dir]) Load the test images as an array of eltype T\ntestlabels([indices]; [dir]) Load the labels for the test images\ntraindata([T], [indices]; [dir]) Load images and labels of the training data\ntestdata([T], [indices]; [dir]) Load images and labels of the test dataThis module also provides utility functions to make working with the Fashion-MNIST dataset in Julia more convenient.Function Description\nconvert2features(array) Convert the Fashion-MNIST tensor to a flat feature matrix\nconvert2image(array) Convert the Fashion-MNIST tensor/matrix to a colorant arrayYou can use the function convert2features to convert the given Fashion-MNIST tensor to a feature matrix (or feature vector in the case of a single image). The purpose of this function is to drop the spatial dimensions such that traditional ML algorithms can process the dataset.julia> FashionMNIST.convert2features(FashionMNIST.traintensor()) # full training data\n784×60000 Array{N0f8,2}:\n[...]To visualize an image or a prediction we provide the function convert2image to convert the given Fashion-MNIST horizontal-major tensor (or feature matrix) to a vertical-major Colorant array. The values are also color corrected according to the website\'s description, which means that the digits are black on a white background.julia> FashionMNIST.convert2image(FashionMNIST.traintensor(1)) # first training image\n28×28 Array{Gray{N0f8},2}:\n[...]"
},

{
    "location": "datasets/FashionMNIST/#API-Documentation-1",
    "page": "Fashion MNIST",
    "title": "API Documentation",
    "category": "section",
    "text": ""
},

{
    "location": "datasets/FashionMNIST/#MLDatasets.FashionMNIST.traintensor",
    "page": "Fashion MNIST",
    "title": "MLDatasets.FashionMNIST.traintensor",
    "category": "Function",
    "text": "traintensor([T = N0f8], [indices]; [dir]) -> Array{T}\n\nReturns the Fashion-MNIST training images corresponding to the given indices as a multi-dimensional array of eltype T.\n\nThe image(s) is/are returned in the native horizontal-major memory layout as a single numeric array. If T <: Integer, then all values will be within 0 and 255, otherwise the values are scaled to be between 0 and 1.\n\nIf the parameter indices is omitted or an AbstractVector, the images are returned as a 3D array (i.e. a Array{T,3}), in which the first dimension corresponds to the pixel rows (x) of the image, the second dimension to the pixel columns (y) of the image, and the third dimension denotes the index of the image.\n\njulia> FashionMNIST.traintensor() # load all training images\n28×28×60000 Array{N0f8,3}:\n[...]\n\njulia> FashionMNIST.traintensor(Float32, 1:3) # first three images as Float32\n28×28×3 Array{Float32,3}:\n[...]\n\nIf indices is an Integer, the single image is returned as Matrix{T} in horizontal-major layout, which means that the first dimension denotes the pixel rows (x), and the second dimension denotes the pixel columns (y) of the image.\n\njulia> FashionMNIST.traintensor(1) # load first training image\n28×28 Array{N0f8,2}:\n[...]\n\nAs mentioned above, the images are returned in the native horizontal-major layout to preserve the original feature ordering. You can use the utility function convert2image to convert an FashionMNIST array into a vertical-major Julia image with the corrected color values.\n\njulia> FashionMNIST.convert2image(FashionMNIST.traintensor(1)) # convert to column-major colorant array\n28×28 Array{Gray{N0f8},2}:\n[...]\n\nThe corresponding resource file(s) of the dataset is/are expected to be located in the specified directory dir. If dir is omitted the directories in DataDeps.default_loadpath will be searched for an existing FashionMNIST subfolder. In case no such subfolder is found, dir will default to ~/.julia/datadeps/FashionMNIST. In the case that dir does not yet exist, a download prompt will be triggered. You can also use FashionMNIST.download([dir]) explicitly for pre-downloading (or re-downloading) the dataset. Please take a look at the documentation of the package DataDeps.jl for more detail and configuration options.\n\n\n\n"
},

{
    "location": "datasets/FashionMNIST/#MLDatasets.FashionMNIST.trainlabels",
    "page": "Fashion MNIST",
    "title": "MLDatasets.FashionMNIST.trainlabels",
    "category": "Function",
    "text": "trainlabels([indices]; [dir])\n\nReturns the Fashion-MNIST trainset labels corresponding to the given indices as an Int or Vector{Int}. The values of the labels denote the zero-based class-index that they represent (see FashionMNIST.classnames for the corresponding names). If indices is omitted, all labels are returned.\n\njulia> FashionMNIST.trainlabels() # full training set\n60000-element Array{Int64,1}:\n 9\n 0\n ⋮\n 0\n 5\n\njulia> FashionMNIST.trainlabels(1:3) # first three labels\n3-element Array{Int64,1}:\n 9\n 0\n 0\n\njulia> y = FashionMNIST.trainlabels(1) # first label\n9\n\njulia> FashionMNIST.classnames()[y + 1] # corresponding name\n\"Ankle boot\"\n\nThe corresponding resource file(s) of the dataset is/are expected to be located in the specified directory dir. If dir is omitted the directories in DataDeps.default_loadpath will be searched for an existing FashionMNIST subfolder. In case no such subfolder is found, dir will default to ~/.julia/datadeps/FashionMNIST. In the case that dir does not yet exist, a download prompt will be triggered. You can also use FashionMNIST.download([dir]) explicitly for pre-downloading (or re-downloading) the dataset. Please take a look at the documentation of the package DataDeps.jl for more detail and configuration options.\n\n\n\n"
},

{
    "location": "datasets/FashionMNIST/#MLDatasets.FashionMNIST.traindata",
    "page": "Fashion MNIST",
    "title": "MLDatasets.FashionMNIST.traindata",
    "category": "Function",
    "text": "traindata([T = N0f8], [indices]; [dir]) -> Tuple\n\nReturns the Fashion-MNIST trainingset corresponding to the given indices as a two-element tuple. If indices is omitted the full trainingset is returned. The first element of three return values will be the images as a multi-dimensional array, and the second element the corresponding labels as integers.\n\nThe image(s) is/are returned in the native horizontal-major memory layout as a single numeric array of eltype T. If T <: Integer, then all values will be within 0 and 255, otherwise the values are scaled to be between 0 and 1. The integer values of the labels correspond 1-to-1 the digit that they represent.\n\ntrain_x, train_y = FashionMNIST.traindata() # full datatset\ntrain_x, train_y = FashionMNIST.traindata(2) # only second observation\ntrain_x, train_y = FashionMNIST.traindata(dir=\"./FashionMNIST\") # custom folder\n\nThe corresponding resource file(s) of the dataset is/are expected to be located in the specified directory dir. If dir is omitted the directories in DataDeps.default_loadpath will be searched for an existing FashionMNIST subfolder. In case no such subfolder is found, dir will default to ~/.julia/datadeps/FashionMNIST. In the case that dir does not yet exist, a download prompt will be triggered. You can also use FashionMNIST.download([dir]) explicitly for pre-downloading (or re-downloading) the dataset. Please take a look at the documentation of the package DataDeps.jl for more detail and configuration options.\n\nTake a look at FashionMNIST.traintensor and FashionMNIST.trainlabels for more information.\n\n\n\n"
},

{
    "location": "datasets/FashionMNIST/#Trainingset-1",
    "page": "Fashion MNIST",
    "title": "Trainingset",
    "category": "section",
    "text": "FashionMNIST.traintensor\nFashionMNIST.trainlabels\nFashionMNIST.traindata"
},

{
    "location": "datasets/FashionMNIST/#MLDatasets.FashionMNIST.testtensor",
    "page": "Fashion MNIST",
    "title": "MLDatasets.FashionMNIST.testtensor",
    "category": "Function",
    "text": "testtensor([T = N0f8], [indices]; [dir]) -> Array{T}\n\nReturns the Fashion-MNIST test images corresponding to the given indices as a multi-dimensional array of eltype T.\n\nThe image(s) is/are returned in the native horizontal-major memory layout as a single numeric array. If T <: Integer, then all values will be within 0 and 255, otherwise the values are scaled to be between 0 and 1.\n\nIf the parameter indices is omitted or an AbstractVector, the images are returned as a 3D array (i.e. a Array{T,3}), in which the first dimension corresponds to the pixel rows (x) of the image, the second dimension to the pixel columns (y) of the image, and the third dimension denotes the index of the image.\n\njulia> FashionMNIST.testtensor() # load all test images\n28×28×10000 Array{N0f8,3}:\n[...]\n\njulia> FashionMNIST.testtensor(Float32, 1:3) # first three images as Float32\n28×28×3 Array{Float32,3}:\n[...]\n\nIf indices is an Integer, the single image is returned as Matrix{T} in horizontal-major layout, which means that the first dimension denotes the pixel rows (x), and the second dimension denotes the pixel columns (y) of the image.\n\njulia> FashionMNIST.testtensor(1) # load first test image\n28×28 Array{N0f8,2}:\n[...]\n\nAs mentioned above, the images are returned in the native horizontal-major layout to preserve the original feature ordering. You can use the utility function convert2image to convert an FashionMNIST array into a vertical-major Julia image with the corrected color values.\n\njulia> FashionMNIST.convert2image(FashionMNIST.testtensor(1)) # convert to column-major colorant array\n28×28 Array{Gray{N0f8},2}:\n[...]\n\nThe corresponding resource file(s) of the dataset is/are expected to be located in the specified directory dir. If dir is omitted the directories in DataDeps.default_loadpath will be searched for an existing FashionMNIST subfolder. In case no such subfolder is found, dir will default to ~/.julia/datadeps/FashionMNIST. In the case that dir does not yet exist, a download prompt will be triggered. You can also use FashionMNIST.download([dir]) explicitly for pre-downloading (or re-downloading) the dataset. Please take a look at the documentation of the package DataDeps.jl for more detail and configuration options.\n\n\n\n"
},

{
    "location": "datasets/FashionMNIST/#MLDatasets.FashionMNIST.testlabels",
    "page": "Fashion MNIST",
    "title": "MLDatasets.FashionMNIST.testlabels",
    "category": "Function",
    "text": "testlabels([indices]; [dir])\n\nReturns the Fashion-MNIST testset labels corresponding to the given indices as an Int or Vector{Int}. The values of the labels denote the class-index that they represent (see FashionMNIST.classnames for the corresponding names). If indices is omitted, all labels are returned.\n\njulia> FashionMNIST.testlabels() # full test set\n10000-element Array{Int64,1}:\n 9\n 2\n ⋮\n 1\n 5\n\njulia> FashionMNIST.testlabels(1:3) # first three labels\n3-element Array{Int64,1}:\n 9\n 2\n 1\n\njulia> y = FashionMNIST.testlabels(1) # first label\n9\n\njulia> FashionMNIST.classnames()[y + 1] # corresponding name\n\"Ankle boot\"\n\nThe corresponding resource file(s) of the dataset is/are expected to be located in the specified directory dir. If dir is omitted the directories in DataDeps.default_loadpath will be searched for an existing FashionMNIST subfolder. In case no such subfolder is found, dir will default to ~/.julia/datadeps/FashionMNIST. In the case that dir does not yet exist, a download prompt will be triggered. You can also use FashionMNIST.download([dir]) explicitly for pre-downloading (or re-downloading) the dataset. Please take a look at the documentation of the package DataDeps.jl for more detail and configuration options.\n\n\n\n"
},

{
    "location": "datasets/FashionMNIST/#MLDatasets.FashionMNIST.testdata",
    "page": "Fashion MNIST",
    "title": "MLDatasets.FashionMNIST.testdata",
    "category": "Function",
    "text": "testdata([T = N0f8], [indices]; [dir]) -> Tuple\n\nReturns the Fashion-MNIST testset corresponding to the given indices as a two-element tuple. If indices is omitted the full testset is returned. The first element of three return values will be the images as a multi-dimensional array, and the second element the corresponding labels as integers.\n\nThe image(s) is/are returned in the native horizontal-major memory layout as a single numeric array of eltype T. If T <: Integer, then all values will be within 0 and 255, otherwise the values are scaled to be between 0 and 1. The integer values of the labels correspond 1-to-1 the digit that they represent.\n\ntest_x, test_y = FashionMNIST.testdata() # full datatset\ntest_x, test_y = FashionMNIST.testdata(2) # only second observation\ntest_x, test_y = FashionMNIST.testdata(dir=\"./FashionMNIST\") # custom folder\n\nThe corresponding resource file(s) of the dataset is/are expected to be located in the specified directory dir. If dir is omitted the directories in DataDeps.default_loadpath will be searched for an existing FashionMNIST subfolder. In case no such subfolder is found, dir will default to ~/.julia/datadeps/FashionMNIST. In the case that dir does not yet exist, a download prompt will be triggered. You can also use FashionMNIST.download([dir]) explicitly for pre-downloading (or re-downloading) the dataset. Please take a look at the documentation of the package DataDeps.jl for more detail and configuration options.\n\nTake a look at FashionMNIST.testtensor and FashionMNIST.testlabels for more information.\n\n\n\n"
},

{
    "location": "datasets/FashionMNIST/#Testset-1",
    "page": "Fashion MNIST",
    "title": "Testset",
    "category": "section",
    "text": "FashionMNIST.testtensor\nFashionMNIST.testlabels\nFashionMNIST.testdata"
},

{
    "location": "datasets/FashionMNIST/#MLDatasets.FashionMNIST.classnames",
    "page": "Fashion MNIST",
    "title": "MLDatasets.FashionMNIST.classnames",
    "category": "Function",
    "text": "classnames() -> Vector{String}\n\nReturn the 10 names for the Fashion-MNIST classes as a vector of strings.\n\n\n\n"
},

{
    "location": "datasets/FashionMNIST/#Utilities-1",
    "page": "Fashion MNIST",
    "title": "Utilities",
    "category": "section",
    "text": "See MNIST.convert2features and MNIST.convert2imageFashionMNIST.classnames"
},

{
    "location": "datasets/FashionMNIST/#References-1",
    "page": "Fashion MNIST",
    "title": "References",
    "category": "section",
    "text": "Authors: Han Xiao, Kashif Rasul, Roland Vollgraf\nWebsite: https://github.com/zalandoresearch/fashion-mnist\n[Han Xiao et al. 2017] Han Xiao, Kashif Rasul, and Roland Vollgraf. \"Fashion-MNIST: a Novel Image Dataset for Benchmarking Machine Learning Algorithms.\" arXiv:1708.07747"
},

{
    "location": "datasets/CIFAR10/#",
    "page": "CIFAR-10",
    "title": "CIFAR-10",
    "category": "page",
    "text": ""
},

{
    "location": "datasets/CIFAR10/#CIFAR10-1",
    "page": "CIFAR-10",
    "title": "CIFAR-10",
    "category": "section",
    "text": "Description from the original websiteThe CIFAR-10 and CIFAR-100 are labeled subsets of the 80 million tiny images dataset. They were collected by Alex Krizhevsky, Vinod Nair, and Geoffrey Hinton.The CIFAR-10 dataset consists of 60000 32x32 colour images in 10 classes, with 6000 images per class. There are 50000 training images and 10000 test images."
},

{
    "location": "datasets/CIFAR10/#Contents-1",
    "page": "CIFAR-10",
    "title": "Contents",
    "category": "section",
    "text": "Pages = [\"CIFAR10.md\"]\nDepth = 3"
},

{
    "location": "datasets/CIFAR10/#Overview-1",
    "page": "CIFAR-10",
    "title": "Overview",
    "category": "section",
    "text": "The MLDatasets.CIFAR10 sub-module provides a programmatic interface to download, load, and work with the CIFAR-10 dataset.using MLDatasets\n\n# load full training set\ntrain_x, train_y = CIFAR10.traindata()\n\n# load full test set\ntest_x,  test_y  = CIFAR10.testdata()The provided functions also allow for optional arguments, such as the directory dir where the dataset is located, or the specific observation indices that one wants to work with. For more information on the interface take a look at the documentation (e.g. ?CIFAR10.traindata).Function Description\ndownload([dir]) Trigger interactive download of the dataset\nclassnames() Return the class names as a vector of strings\ntraintensor([T], [indices]; [dir]) Load the training images as an array of eltype T\ntrainlabels([indices]; [dir]) Load the labels for the training images\ntesttensor([T], [indices]; [dir]) Load the test images as an array of eltype T\ntestlabels([indices]; [dir]) Load the labels for the test images\ntraindata([T], [indices]; [dir]) Load images and labels of the training data\ntestdata([T], [indices]; [dir]) Load images and labels of the test dataThis module also provides utility functions to make working with the CIFAR-10 dataset in Julia more convenient.Function Description\nconvert2features(array) Convert the CIFAR-10 tensor to a flat feature matrix\nconvert2image(array) Convert the CIFAR-10 tensor/matrix to a colorant arrayYou can use the function convert2features to convert the given CIFAR-10 tensor to a feature matrix (or feature vector in the case of a single image). The purpose of this function is to drop the spatial dimensions such that traditional ML algorithms can process the dataset.julia> CIFAR10.convert2features(CIFAR10.traintensor()) # full training data\n3072×50000 Array{N0f8,2}:\n[...]To visualize an image or a prediction we provide the function convert2image to convert the given CIFAR10 horizontal-major tensor (or feature matrix) to a vertical-major Colorant array.julia> CIFAR10.convert2image(CIFAR10.traintensor(1)) # first training image\n32×32 Array{RGB{N0f8},2}:\n[...]"
},

{
    "location": "datasets/CIFAR10/#API-Documentation-1",
    "page": "CIFAR-10",
    "title": "API Documentation",
    "category": "section",
    "text": ""
},

{
    "location": "datasets/CIFAR10/#MLDatasets.CIFAR10.traintensor",
    "page": "CIFAR-10",
    "title": "MLDatasets.CIFAR10.traintensor",
    "category": "Function",
    "text": "traintensor([T = N0f8], [indices]; [dir]) -> Array{T}\n\nReturn the CIFAR-10 training images corresponding to the given indices as a multi-dimensional array of eltype T. If the corresponding labels are required as well, it is recommended to use CIFAR10.traindata instead.\n\nThe image(s) is/are returned in the native horizontal-major memory layout as a single numeric array. If T <: Integer, then all values will be within 0 and 255, otherwise the values are scaled to be between 0 and 1.\n\nIf the parameter indices is omitted or an AbstractVector, the images are returned as a 4D array (i.e. a Array{T,4}), in which the first dimension corresponds to the pixel rows (x) of the image, the second dimension to the pixel columns (y) of the image, the third dimension the RGB color channels, and the fourth dimension denotes the index of the image.\n\njulia> CIFAR10.traintensor() # load all training images\n32×32×3×50000 Array{N0f8,4}:\n[...]\n\njulia> CIFAR10.traintensor(Float32, 1:3) # first three images as Float32\n32×32×3×3 Array{Float32,4}:\n[...]\n\nIf indices is an Integer, the single image is returned as Array{T,3} in horizontal-major layout, which means that the first dimension denotes the pixel rows (x), the second dimension denotes the pixel columns (y), and the third dimension the RGB color channels of the image.\n\njulia> CIFAR10.traintensor(1) # load first training image\n32×32×3 Array{N0f8,3}:\n[...]\n\nAs mentioned above, the images are returned in the native horizontal-major layout to preserve the original feature ordering. You can use the utility function convert2image to convert an CIFAR-10 array into a vertical-major Julia image with the appropriate RGB eltype.\n\njulia> CIFAR10.convert2image(CIFAR10.traintensor(1)) # convert to column-major colorant array\n32×32 Array{RGB{N0f8},2}:\n[...]\n\nThe corresponding resource file(s) of the dataset is/are expected to be located in the specified directory dir. If dir is omitted the directories in DataDeps.default_loadpath will be searched for an existing CIFAR10 subfolder. In case no such subfolder is found, dir will default to ~/.julia/datadeps/CIFAR10. In the case that dir does not yet exist, a download prompt will be triggered. You can also use CIFAR10.download([dir]) explicitly for pre-downloading (or re-downloading) the dataset. Please take a look at the documentation of the package DataDeps.jl for more detail and configuration options.\n\n\n\n"
},

{
    "location": "datasets/CIFAR10/#MLDatasets.CIFAR10.trainlabels",
    "page": "CIFAR-10",
    "title": "MLDatasets.CIFAR10.trainlabels",
    "category": "Function",
    "text": "trainlabels([indices]; [dir])\n\nReturns the CIFAR-10 trainset labels corresponding to the given indices as an Int or Vector{Int}. The values of the labels denote the zero-based class-index that they represent (see CIFAR10.classnames for the corresponding names). If indices is omitted, all labels are returned.\n\njulia> CIFAR10.trainlabels() # full training set\n50000-element Array{Int64,1}:\n 6\n 9\n ⋮\n 1\n 1\n\njulia> CIFAR10.trainlabels(1:3) # first three labels\n3-element Array{Int64,1}:\n 6\n 9\n 9\n\njulia> CIFAR10.trainlabels(1) # first label\n6\n\njulia> CIFAR10.classnames()[CIFAR10.trainlabels(1) + 1] # corresponding name\n\"frog\"\n\nThe corresponding resource file(s) of the dataset is/are expected to be located in the specified directory dir. If dir is omitted the directories in DataDeps.default_loadpath will be searched for an existing CIFAR10 subfolder. In case no such subfolder is found, dir will default to ~/.julia/datadeps/CIFAR10. In the case that dir does not yet exist, a download prompt will be triggered. You can also use CIFAR10.download([dir]) explicitly for pre-downloading (or re-downloading) the dataset. Please take a look at the documentation of the package DataDeps.jl for more detail and configuration options.\n\n\n\n"
},

{
    "location": "datasets/CIFAR10/#MLDatasets.CIFAR10.traindata",
    "page": "CIFAR-10",
    "title": "MLDatasets.CIFAR10.traindata",
    "category": "Function",
    "text": "traindata([T = N0f8], [indices]; [dir]) -> Tuple\n\nReturns the CIFAR-10 trainingset corresponding to the given indices as a two-element tuple. If indices is omitted the full trainingset is returned. The first element of three return values will be the images as a multi-dimensional array, and the second element the corresponding labels as integers.\n\nThe image(s) is/are returned in the native horizontal-major memory layout as a single numeric array of eltype T. If T <: Integer, then all values will be within 0 and 255, otherwise the values are scaled to be between 0 and 1. The integer values of the labels correspond 1-to-1 the digit that they represent.\n\ntrain_x, train_y = CIFAR10.traindata() # full datatset\ntrain_x, train_y = CIFAR10.traindata(2) # only second observation\ntrain_x, train_y = CIFAR10.traindata(dir=\"./CIFAR10\") # custom folder\n\nThe corresponding resource file(s) of the dataset is/are expected to be located in the specified directory dir. If dir is omitted the directories in DataDeps.default_loadpath will be searched for an existing CIFAR10 subfolder. In case no such subfolder is found, dir will default to ~/.julia/datadeps/CIFAR10. In the case that dir does not yet exist, a download prompt will be triggered. You can also use CIFAR10.download([dir]) explicitly for pre-downloading (or re-downloading) the dataset. Please take a look at the documentation of the package DataDeps.jl for more detail and configuration options.\n\nTake a look at CIFAR10.traintensor and CIFAR10.trainlabels for more information.\n\n\n\n"
},

{
    "location": "datasets/CIFAR10/#Trainingset-1",
    "page": "CIFAR-10",
    "title": "Trainingset",
    "category": "section",
    "text": "CIFAR10.traintensor\nCIFAR10.trainlabels\nCIFAR10.traindata"
},

{
    "location": "datasets/CIFAR10/#MLDatasets.CIFAR10.testtensor",
    "page": "CIFAR-10",
    "title": "MLDatasets.CIFAR10.testtensor",
    "category": "Function",
    "text": "testtensor([T = N0f8], [indices]; [dir]) -> Array{T}\n\nReturn the CIFAR-10 test images corresponding to the given indices as a multi-dimensional array of eltype T. If the corresponding labels are required as well, it is recommended to use CIFAR10.testdata instead.\n\nThe image(s) is/are returned in the native horizontal-major memory layout as a single numeric array. If T <: Integer, then all values will be within 0 and 255, otherwise the values are scaled to be between 0 and 1.\n\nIf the parameter indices is omitted or an AbstractVector, the images are returned as a 4D array (i.e. a Array{T,4}), in which the first dimension corresponds to the pixel rows (x) of the image, the second dimension to the pixel columns (y) of the image, the third dimension the RGB color channels, and the fourth dimension denotes the index of the image.\n\njulia> CIFAR10.testtensor() # load all training images\n32×32×3×10000 Array{N0f8,4}:\n[...]\n\njulia> CIFAR10.testtensor(Float32, 1:3) # first three images as Float32\n32×32×3×3 Array{Float32,4}:\n[...]\n\nIf indices is an Integer, the single image is returned as Array{T,3} in horizontal-major layout, which means that the first dimension denotes the pixel rows (x), the second dimension denotes the pixel columns (y), and the third dimension the RGB color channels of the image.\n\njulia> CIFAR10.testtensor(1) # load first training image\n32×32×3 Array{N0f8,3}:\n[...]\n\nAs mentioned above, the images are returned in the native horizontal-major layout to preserve the original feature ordering. You can use the utility function convert2image to convert an CIFAR-10 array into a vertical-major Julia image with the appropriate RGB eltype.\n\njulia> CIFAR10.convert2image(CIFAR10.testtensor(1)) # convert to column-major colorant array\n32×32 Array{RGB{N0f8},2}:\n[...]\n\nThe corresponding resource file(s) of the dataset is/are expected to be located in the specified directory dir. If dir is omitted the directories in DataDeps.default_loadpath will be searched for an existing CIFAR10 subfolder. In case no such subfolder is found, dir will default to ~/.julia/datadeps/CIFAR10. In the case that dir does not yet exist, a download prompt will be triggered. You can also use CIFAR10.download([dir]) explicitly for pre-downloading (or re-downloading) the dataset. Please take a look at the documentation of the package DataDeps.jl for more detail and configuration options.\n\n\n\n"
},

{
    "location": "datasets/CIFAR10/#MLDatasets.CIFAR10.testlabels",
    "page": "CIFAR-10",
    "title": "MLDatasets.CIFAR10.testlabels",
    "category": "Function",
    "text": "testlabels([indices]; [dir])\n\nReturns the CIFAR-10 testset labels corresponding to the given indices as an Int or Vector{Int}. The values of the labels denote the zero-based class-index that they represent (see CIFAR10.classnames for the corresponding names). If indices is omitted, all labels are returned.\n\njulia> CIFAR10.testlabels() # full training set\n10000-element Array{Int64,1}:\n 3\n 8\n ⋮\n 1\n 7\n\njulia> CIFAR10.testlabels(1:3) # first three labels\n3-element Array{Int64,1}:\n 3\n 8\n 8\n\njulia> CIFAR10.testlabels(1) # first label\n3\n\njulia> CIFAR10.classnames()[CIFAR10.testlabels(1) + 1] # corresponding name\n\"cat\"\n\nThe corresponding resource file(s) of the dataset is/are expected to be located in the specified directory dir. If dir is omitted the directories in DataDeps.default_loadpath will be searched for an existing CIFAR10 subfolder. In case no such subfolder is found, dir will default to ~/.julia/datadeps/CIFAR10. In the case that dir does not yet exist, a download prompt will be triggered. You can also use CIFAR10.download([dir]) explicitly for pre-downloading (or re-downloading) the dataset. Please take a look at the documentation of the package DataDeps.jl for more detail and configuration options.\n\n\n\n"
},

{
    "location": "datasets/CIFAR10/#MLDatasets.CIFAR10.testdata",
    "page": "CIFAR-10",
    "title": "MLDatasets.CIFAR10.testdata",
    "category": "Function",
    "text": "testdata([T = N0f8], [indices]; [dir]) -> Tuple\n\nReturns the CIFAR-10 testset corresponding to the given indices as a two-element tuple. If indices is omitted the full testset is returned. The first element of three return values will be the images as a multi-dimensional array, and the second element the corresponding labels as integers.\n\nThe image(s) is/are returned in the native horizontal-major memory layout as a single numeric array of eltype T. If T <: Integer, then all values will be within 0 and 255, otherwise the values are scaled to be between 0 and 1. The integer values of the labels correspond 1-to-1 the digit that they represent.\n\ntrain_x, train_y = CIFAR10.testdata() # full datatset\ntrain_x, train_y = CIFAR10.testdata(2) # only second observation\ntrain_x, train_y = CIFAR10.testdata(dir=\"./CIFAR10\") # custom folder\n\nThe corresponding resource file(s) of the dataset is/are expected to be located in the specified directory dir. If dir is omitted the directories in DataDeps.default_loadpath will be searched for an existing CIFAR10 subfolder. In case no such subfolder is found, dir will default to ~/.julia/datadeps/CIFAR10. In the case that dir does not yet exist, a download prompt will be triggered. You can also use CIFAR10.download([dir]) explicitly for pre-downloading (or re-downloading) the dataset. Please take a look at the documentation of the package DataDeps.jl for more detail and configuration options.\n\nTake a look at CIFAR10.testtensor and CIFAR10.testlabels for more information.\n\n\n\n"
},

{
    "location": "datasets/CIFAR10/#Testset-1",
    "page": "CIFAR-10",
    "title": "Testset",
    "category": "section",
    "text": "CIFAR10.testtensor\nCIFAR10.testlabels\nCIFAR10.testdata"
},

{
    "location": "datasets/CIFAR10/#MLDatasets.CIFAR10.classnames",
    "page": "CIFAR-10",
    "title": "MLDatasets.CIFAR10.classnames",
    "category": "Function",
    "text": "classnames() -> Vector{String}\n\nReturn the 10 names for the CIFAR10 classes as a vector of strings.\n\n\n\n"
},

{
    "location": "datasets/CIFAR10/#MLDatasets.CIFAR10.convert2features",
    "page": "CIFAR-10",
    "title": "MLDatasets.CIFAR10.convert2features",
    "category": "Function",
    "text": "convert2features(array)\n\nConvert the given CIFAR-10 tensor to a feature matrix (or feature vector in the case of a single image). The purpose of this function is to drop the spatial dimensions such that traditional ML algorithms can process the dataset.\n\njulia> CIFAR10.convert2features(CIFAR10.traintensor(Float32)) # full training data\n3072×50000 Array{Float32,2}:\n[...]\n\njulia> CIFAR10.convert2features(CIFAR10.traintensor(Float32,1)) # first observation\n3072-element Array{Float32,1}:\n[...]\n\n\n\n"
},

{
    "location": "datasets/CIFAR10/#MLDatasets.CIFAR10.convert2image",
    "page": "CIFAR-10",
    "title": "MLDatasets.CIFAR10.convert2image",
    "category": "Function",
    "text": "convert2image(array) -> Array{RGB}\n\nConvert the given CIFAR-10 horizontal-major tensor (or feature vector/matrix) to a vertical-major RGB array.\n\njulia> CIFAR10.convert2image(CIFAR10.traintensor()) # full training dataset\n32×32×50000 Array{RGB{N0f8},3}:\n[...]\n\njulia> CIFAR10.convert2image(CIFAR10.traintensor(1)) # first training image\n32×32 Array{RGB{N0f8},2}:\n[...]\n\n\n\n"
},

{
    "location": "datasets/CIFAR10/#Utilities-1",
    "page": "CIFAR-10",
    "title": "Utilities",
    "category": "section",
    "text": "CIFAR10.classnames\nCIFAR10.convert2features\nCIFAR10.convert2image"
},

{
    "location": "datasets/CIFAR10/#References-1",
    "page": "CIFAR-10",
    "title": "References",
    "category": "section",
    "text": "Authors: Alex Krizhevsky, Vinod Nair, Geoffrey Hinton\nWebsite: https://www.cs.toronto.edu/~kriz/cifar.html\n[Krizhevsky, 2009] Alex Krizhevsky. \"Learning Multiple Layers of Features from Tiny Images\", Tech Report, 2009."
},

{
    "location": "datasets/CIFAR100/#",
    "page": "CIFAR-100",
    "title": "CIFAR-100",
    "category": "page",
    "text": ""
},

{
    "location": "datasets/CIFAR100/#CIFAR100-1",
    "page": "CIFAR-100",
    "title": "CIFAR-100",
    "category": "section",
    "text": "Description from the original websiteThe CIFAR-10 and CIFAR-100 are labeled subsets of the 80 million tiny images dataset. They were collected by Alex Krizhevsky, Vinod Nair, and Geoffrey Hinton.This dataset is just like the CIFAR-10, except it has 100 classes containing 600 images each. There are 500 training images and 100 testing images per class. The 100 classes in the CIFAR-100 are grouped into 20 superclasses. Each image comes with a \"fine\" label (the class to which it belongs) and a \"coarse\" label (the superclass to which it belongs)."
},

{
    "location": "datasets/CIFAR100/#Contents-1",
    "page": "CIFAR-100",
    "title": "Contents",
    "category": "section",
    "text": "Pages = [\"CIFAR100.md\"]\nDepth = 3"
},

{
    "location": "datasets/CIFAR100/#Overview-1",
    "page": "CIFAR-100",
    "title": "Overview",
    "category": "section",
    "text": "The MLDatasets.CIFAR100 sub-module provides a programmatic interface to download, load, and work with the CIFAR-100 dataset.using MLDatasets\n\n# load full training set\ntrain_x, train_y_coarse, train_y_fine = CIFAR100.traindata()\n\n# load full test set\ntest_x, test_y_coarse, test_y_fine  = CIFAR100.testdata()The provided functions also allow for optional arguments, such as the directory dir where the dataset is located, or the specific observation indices that one wants to work with. For more information on the interface take a look at the documentation (e.g. ?CIFAR100.traindata).Function Description\ndownload([dir]) Trigger interactive download of the dataset\nclassnames_coarse() Return the 20 super-class names as a vector of strings\nclassnames_fine() Return the 100 class names as a vector of strings\ntraintensor([T], [indices]; [dir]) Load the training images as an array of eltype T\ntrainlabels([indices]; [dir]) Load the labels for the training images\ntesttensor([T], [indices]; [dir]) Load the test images as an array of eltype T\ntestlabels([indices]; [dir]) Load the labels for the test images\ntraindata([T], [indices]; [dir]) Load images and labels of the training data\ntestdata([T], [indices]; [dir]) Load images and labels of the test dataThis module also provides utility functions to make working with the CIFAR-100 dataset in Julia more convenient.Function Description\nconvert2features(array) Convert the CIFAR-100 tensor to a flat feature matrix\nconvert2image(array) Convert the CIFAR-100 tensor/matrix to a colorant arrayYou can use the function convert2features to convert the given CIFAR-100 tensor to a feature matrix (or feature vector in the case of a single image). The purpose of this function is to drop the spatial dimensions such that traditional ML algorithms can process the dataset.julia> CIFAR100.convert2features(CIFAR100.traintensor()) # full training data\n3072×50000 Array{N0f8,2}:\n[...]To visualize an image or a prediction we provide the function convert2image to convert the given CIFAR-100 horizontal-major tensor (or feature matrix) to a vertical-major Colorant array.julia> CIFAR100.convert2image(CIFAR100.traintensor(1)) # first training image\n32×32 Array{RGB{N0f8},2}:\n[...]"
},

{
    "location": "datasets/CIFAR100/#API-Documentation-1",
    "page": "CIFAR-100",
    "title": "API Documentation",
    "category": "section",
    "text": ""
},

{
    "location": "datasets/CIFAR100/#MLDatasets.CIFAR100.traintensor",
    "page": "CIFAR-100",
    "title": "MLDatasets.CIFAR100.traintensor",
    "category": "Function",
    "text": "traintensor([T = N0f8], [indices]; [dir]) -> Array{T}\n\nReturn the CIFAR-100 training images corresponding to the given indices as a multi-dimensional array of eltype T. If the corresponding labels are required as well, it is recommended to use CIFAR100.traindata instead.\n\nThe image(s) is/are returned in the native horizontal-major memory layout as a single numeric array. If T <: Integer, then all values will be within 0 and 255, otherwise the values are scaled to be between 0 and 1.\n\nIf the parameter indices is omitted or an AbstractVector, the images are returned as a 4D array (i.e. a Array{T,4}), in which the first dimension corresponds to the pixel rows (x) of the image, the second dimension to the pixel columns (y) of the image, the third dimension the RGB color channels, and the fourth dimension denotes the index of the image.\n\njulia> CIFAR100.traintensor() # load all training images\n32×32×3×50000 Array{N0f8,4}:\n[...]\n\njulia> CIFAR100.traintensor(Float32, 1:3) # first three images as Float32\n32×32×3×3 Array{Float32,4}:\n[...]\n\nIf indices is an Integer, the single image is returned as Array{T,3} in horizontal-major layout, which means that the first dimension denotes the pixel rows (x), the second dimension denotes the pixel columns (y), and the third dimension the RGB color channels of the image.\n\njulia> CIFAR100.traintensor(1) # load first training image\n32×32×3 Array{N0f8,3}:\n[...]\n\nAs mentioned above, the images are returned in the native horizontal-major layout to preserve the original feature ordering. You can use the utility function convert2image to convert an CIFAR-100 array into a vertical-major Julia image with the appropriate RGB eltype.\n\njulia> CIFAR100.convert2image(CIFAR100.traintensor(1)) # convert to column-major colorant array\n32×32 Array{RGB{N0f8},2}:\n[...]\n\nThe corresponding resource file(s) of the dataset is/are expected to be located in the specified directory dir. If dir is omitted the directories in DataDeps.default_loadpath will be searched for an existing CIFAR100 subfolder. In case no such subfolder is found, dir will default to ~/.julia/datadeps/CIFAR100. In the case that dir does not yet exist, a download prompt will be triggered. You can also use CIFAR100.download([dir]) explicitly for pre-downloading (or re-downloading) the dataset. Please take a look at the documentation of the package DataDeps.jl for more detail and configuration options.\n\n\n\n"
},

{
    "location": "datasets/CIFAR100/#MLDatasets.CIFAR100.trainlabels",
    "page": "CIFAR-100",
    "title": "MLDatasets.CIFAR100.trainlabels",
    "category": "Function",
    "text": "trainlabels([indices]; [dir]) -> Yc, Yf\n\nReturn the CIFAR-100 trainset labels (coarse and fine) corresponding to the given indices as a tuple of two Int or two Vector{Int}. The variables returned are the coarse label(s) (Yc) and the fine label(s) (Yf) respectively.\n\nYc, Yf = CIFAR100.trainlabels(); # full training set\n\nThe values of the labels denote the zero-based class-index that they represent (see CIFAR100.classnames_coarse and CIFAR100.classnames_fine for the corresponding names). If indices is omitted, all labels are returned.\n\njulia> Yc, Yf = CIFAR100.trainlabels(1:3) # first three labels\n([11, 15, 4], [19, 29, 0])\n\njulia> yc, yf = CIFAR100.trainlabels(1) # first label\n(11, 19)\n\njulia> CIFAR100.classnames_coarse()[yc + 1] # corresponding superclass name\n\"large_omnivores_and_herbivores\"\n\njulia> CIFAR100.classnames_fine()[yf + 1] # corresponding class name\n\"cattle\"\n\nThe corresponding resource file(s) of the dataset is/are expected to be located in the specified directory dir. If dir is omitted the directories in DataDeps.default_loadpath will be searched for an existing CIFAR100 subfolder. In case no such subfolder is found, dir will default to ~/.julia/datadeps/CIFAR100. In the case that dir does not yet exist, a download prompt will be triggered. You can also use CIFAR100.download([dir]) explicitly for pre-downloading (or re-downloading) the dataset. Please take a look at the documentation of the package DataDeps.jl for more detail and configuration options.\n\n\n\n"
},

{
    "location": "datasets/CIFAR100/#MLDatasets.CIFAR100.traindata",
    "page": "CIFAR-100",
    "title": "MLDatasets.CIFAR100.traindata",
    "category": "Function",
    "text": "traindata([T = N0f8], [indices]; [dir]) -> X, Yc, Yf\n\nReturns the CIFAR-100 trainset corresponding to the given indices as a three-element tuple. If indices is omitted the full trainingset is returned. The first element of three return values (X) will be the images as a multi-dimensional array, the second element (Yc) the corresponding coarse labels as integers, and the third element (Yf) the fine labels respectively.\n\nThe image(s) is/are returned in the native horizontal-major memory layout as a single numeric array of eltype T. If T <: Integer, then all values will be within 0 and 255, otherwise the values are scaled to be between 0 and 1. The integer values of the labels correspond 1-to-1 the digit that they represent.\n\nX, Yc, Yf = CIFAR100.traindata() # full datatset\nX, Yc, Yf = CIFAR100.traindata(dir=\"./CIFAR100\") # custom folder\nx, yc, yf = CIFAR100.traindata(2) # only second observation\n\nThe corresponding resource file(s) of the dataset is/are expected to be located in the specified directory dir. If dir is omitted the directories in DataDeps.default_loadpath will be searched for an existing CIFAR100 subfolder. In case no such subfolder is found, dir will default to ~/.julia/datadeps/CIFAR100. In the case that dir does not yet exist, a download prompt will be triggered. You can also use CIFAR100.download([dir]) explicitly for pre-downloading (or re-downloading) the dataset. Please take a look at the documentation of the package DataDeps.jl for more detail and configuration options.\n\nTake a look at CIFAR100.traintensor and CIFAR100.trainlabels for more information.\n\n\n\n"
},

{
    "location": "datasets/CIFAR100/#Trainingset-1",
    "page": "CIFAR-100",
    "title": "Trainingset",
    "category": "section",
    "text": "CIFAR100.traintensor\nCIFAR100.trainlabels\nCIFAR100.traindata"
},

{
    "location": "datasets/CIFAR100/#MLDatasets.CIFAR100.testtensor",
    "page": "CIFAR-100",
    "title": "MLDatasets.CIFAR100.testtensor",
    "category": "Function",
    "text": "testtensor([T = N0f8], [indices]; [dir]) -> Array{T}\n\nReturn the CIFAR-100 test images corresponding to the given indices as a multi-dimensional array of eltype T. If the corresponding labels are required as well, it is recommended to use CIFAR100.testdata instead.\n\nThe image(s) is/are returned in the native horizontal-major memory layout as a single numeric array. If T <: Integer, then all values will be within 0 and 255, otherwise the values are scaled to be between 0 and 1.\n\nIf the parameter indices is omitted or an AbstractVector, the images are returned as a 4D array (i.e. a Array{T,4}), in which the first dimension corresponds to the pixel rows (x) of the image, the second dimension to the pixel columns (y) of the image, the third dimension the RGB color channels, and the fourth dimension denotes the index of the image.\n\njulia> CIFAR100.testtensor() # load all training images\n32×32×3×10000 Array{N0f8,4}:\n[...]\n\njulia> CIFAR100.testtensor(Float32, 1:3) # first three images as Float32\n32×32×3×3 Array{Float32,4}:\n[...]\n\nIf indices is an Integer, the single image is returned as Array{T,3} in horizontal-major layout, which means that the first dimension denotes the pixel rows (x), the second dimension denotes the pixel columns (y), and the third dimension the RGB color channels of the image.\n\njulia> CIFAR100.testtensor(1) # load first training image\n32×32×3 Array{N0f8,3}:\n[...]\n\nAs mentioned above, the images are returned in the native horizontal-major layout to preserve the original feature ordering. You can use the utility function convert2image to convert an CIFAR-100 array into a vertical-major Julia image with the appropriate RGB eltype.\n\njulia> CIFAR100.convert2image(CIFAR100.testtensor(1)) # convert to column-major colorant array\n32×32 Array{RGB{N0f8},2}:\n[...]\n\nThe corresponding resource file(s) of the dataset is/are expected to be located in the specified directory dir. If dir is omitted the directories in DataDeps.default_loadpath will be searched for an existing CIFAR100 subfolder. In case no such subfolder is found, dir will default to ~/.julia/datadeps/CIFAR100. In the case that dir does not yet exist, a download prompt will be triggered. You can also use CIFAR100.download([dir]) explicitly for pre-downloading (or re-downloading) the dataset. Please take a look at the documentation of the package DataDeps.jl for more detail and configuration options.\n\n\n\n"
},

{
    "location": "datasets/CIFAR100/#MLDatasets.CIFAR100.testlabels",
    "page": "CIFAR-100",
    "title": "MLDatasets.CIFAR100.testlabels",
    "category": "Function",
    "text": "testlabels([indices]; [dir]) -> Yc, Yf\n\nReturn the CIFAR-100 testset labels (coarse and fine) corresponding to the given indices as a tuple of two Int or two Vector{Int}. The variables returned are the coarse label(s) (Yc) and the fine label(s) (Yf) respectively.\n\nYc, Yf = CIFAR100.testlabels(); # full training set\n\nThe values of the labels denote the zero-based class-index that they represent (see CIFAR100.classnames_coarse and CIFAR100.classnames_fine for the corresponding names). If indices is omitted, all labels are returned.\n\njulia> Yc, Yf = CIFAR100.testlabels(1:3) # first three labels\n([10, 10, 0], [49, 33, 72])\n\njulia> yc, yf = CIFAR100.testlabels(1) # first label\n(10, 49)\n\njulia> CIFAR100.classnames_coarse()[yc + 1] # corresponding superclass name\n\"large_natural_outdoor_scenes\"\n\njulia> CIFAR100.classnames_fine()[yf + 1] # corresponding class name\n\"mountain\"\n\nThe corresponding resource file(s) of the dataset is/are expected to be located in the specified directory dir. If dir is omitted the directories in DataDeps.default_loadpath will be searched for an existing CIFAR100 subfolder. In case no such subfolder is found, dir will default to ~/.julia/datadeps/CIFAR100. In the case that dir does not yet exist, a download prompt will be triggered. You can also use CIFAR100.download([dir]) explicitly for pre-downloading (or re-downloading) the dataset. Please take a look at the documentation of the package DataDeps.jl for more detail and configuration options.\n\n\n\n"
},

{
    "location": "datasets/CIFAR100/#MLDatasets.CIFAR100.testdata",
    "page": "CIFAR-100",
    "title": "MLDatasets.CIFAR100.testdata",
    "category": "Function",
    "text": "testdata([T = N0f8], [indices]; [dir]) -> X, Yc, Yf\n\nReturns the CIFAR-100 testset corresponding to the given indices as a three-element tuple. If indices is omitted the full testset is returned. The first element of three return values (X) will be the images as a multi-dimensional array, the second element (Yc) the corresponding coarse labels as integers, and the third element (Yf) the fine labels respectively.\n\nThe image(s) is/are returned in the native horizontal-major memory layout as a single numeric array of eltype T. If T <: Integer, then all values will be within 0 and 255, otherwise the values are scaled to be between 0 and 1. The integer values of the labels correspond 1-to-1 the digit that they represent.\n\nX, Yc, Yf = CIFAR100.testdata() # full datatset\nX, Yc, Yf = CIFAR100.testdata(dir=\"./CIFAR100\") # custom folder\nx, yc, yf = CIFAR100.testdata(2) # only second observation\n\nThe corresponding resource file(s) of the dataset is/are expected to be located in the specified directory dir. If dir is omitted the directories in DataDeps.default_loadpath will be searched for an existing CIFAR100 subfolder. In case no such subfolder is found, dir will default to ~/.julia/datadeps/CIFAR100. In the case that dir does not yet exist, a download prompt will be triggered. You can also use CIFAR100.download([dir]) explicitly for pre-downloading (or re-downloading) the dataset. Please take a look at the documentation of the package DataDeps.jl for more detail and configuration options.\n\nTake a look at CIFAR100.testtensor and CIFAR100.testlabels for more information.\n\n\n\n"
},

{
    "location": "datasets/CIFAR100/#Testset-1",
    "page": "CIFAR-100",
    "title": "Testset",
    "category": "section",
    "text": "CIFAR100.testtensor\nCIFAR100.testlabels\nCIFAR100.testdata"
},

{
    "location": "datasets/CIFAR100/#MLDatasets.CIFAR100.classnames_coarse",
    "page": "CIFAR-100",
    "title": "MLDatasets.CIFAR100.classnames_coarse",
    "category": "Function",
    "text": "classnames_coarse(; [dir]) -> Vector{String}\n\nReturn the 20 names for the CIFAR100 superclasses as a vector of strings. Note that these strings are read from the actual resource file.\n\nThe corresponding resource file(s) of the dataset is/are expected to be located in the specified directory dir. If dir is omitted the directories in DataDeps.default_loadpath will be searched for an existing CIFAR100 subfolder. In case no such subfolder is found, dir will default to ~/.julia/datadeps/CIFAR100. In the case that dir does not yet exist, a download prompt will be triggered. You can also use CIFAR100.download([dir]) explicitly for pre-downloading (or re-downloading) the dataset. Please take a look at the documentation of the package DataDeps.jl for more detail and configuration options.\n\n\n\n"
},

{
    "location": "datasets/CIFAR100/#MLDatasets.CIFAR100.classnames_fine",
    "page": "CIFAR-100",
    "title": "MLDatasets.CIFAR100.classnames_fine",
    "category": "Function",
    "text": "classnames_fine(; [dir]) -> Vector{String}\n\nReturn the 100 names for the CIFAR100 classes as a vector of strings. Note that these strings are read from the actual resource file.\n\nThe corresponding resource file(s) of the dataset is/are expected to be located in the specified directory dir. If dir is omitted the directories in DataDeps.default_loadpath will be searched for an existing CIFAR100 subfolder. In case no such subfolder is found, dir will default to ~/.julia/datadeps/CIFAR100. In the case that dir does not yet exist, a download prompt will be triggered. You can also use CIFAR100.download([dir]) explicitly for pre-downloading (or re-downloading) the dataset. Please take a look at the documentation of the package DataDeps.jl for more detail and configuration options.\n\n\n\n"
},

{
    "location": "datasets/CIFAR100/#Utilities-1",
    "page": "CIFAR-100",
    "title": "Utilities",
    "category": "section",
    "text": "See CIFAR10.convert2features and CIFAR10.convert2imageCIFAR100.classnames_coarse\nCIFAR100.classnames_fine"
},

{
    "location": "datasets/CIFAR100/#References-1",
    "page": "CIFAR-100",
    "title": "References",
    "category": "section",
    "text": "Authors: Alex Krizhevsky, Vinod Nair, Geoffrey Hinton\nWebsite: https://www.cs.toronto.edu/~kriz/cifar.html\n[Krizhevsky, 2009] Alex Krizhevsky. \"Learning Multiple Layers of Features from Tiny Images\", Tech Report, 2009."
},

{
    "location": "indices/#",
    "page": "Indices",
    "title": "Indices",
    "category": "page",
    "text": ""
},

{
    "location": "indices/#Functions-1",
    "page": "Indices",
    "title": "Functions",
    "category": "section",
    "text": "Order   = [:function]"
},

{
    "location": "indices/#Types-1",
    "page": "Indices",
    "title": "Types",
    "category": "section",
    "text": "Order   = [:type]"
},

{
    "location": "LICENSE/#",
    "page": "LICENSE",
    "title": "LICENSE",
    "category": "page",
    "text": ""
},

{
    "location": "LICENSE/#LICENSE-1",
    "page": "LICENSE",
    "title": "LICENSE",
    "category": "section",
    "text": "Markdown.parse_file(joinpath(@__DIR__, \"../LICENSE\"))"
},

]}
