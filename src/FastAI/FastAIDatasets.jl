module FastAIDatasets



using DataDeps
using FilePathsBase
using FilePathsBase: filename
import FileIO
using FileTrees
using MLDataPattern
using MLDataPattern: splitobs
import LearnBase
using Colors
using FixedPointNumbers

include("fastaidatasets.jl")

function __init__()
    initdatadeps()
end

include("containers.jl")
include("transformations.jl")
include("load.jl")


export
    # reexports from MLDataPattern
    splitobs,
    getobs,
    nobs,

    # container transformations
    mapobs,
    filterobs,
    groupobs,
    joinobs,

    # primitive containers
    FileDataset,
    TableDataset,

    # utilities
    isimagefile,
    loadfile,
    filename,

    # datasets
    DATASETS,
    loadtaskdata,
    datasetpath





end  # module
