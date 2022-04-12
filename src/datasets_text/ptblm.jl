export PTBLM

"""
    PTBLM

The PTBLM dataset consists of Penn Treebank sentences
for language modeling, available from tomsercu/lstm.
The unknown words are replaced with <unk> so that the
total vocaburary size becomes 10000.
"""
module PTBLM

    using DataDeps
    using ..MLDatasets: datafile, download_dep

    export

        traindata,
        testdata,

        download

    const DEPNAME = "PTBLM"
    const TRAINFILE = "ptb.train.txt"
    const TESTFILE  = "ptb.test.txt"

    download(args...; kw...) = download_dep(DEPNAME, args...; kw...)

    traindata(; dir = nothing) = traindata(dir)
    testdata(; dir = nothing) = testdata(dir)

    function traindata(dir)
        path = datafile(DEPNAME, TRAINFILE, dir)
        xs = readdata(path)
        ys = makeys(xs)
        xs, ys
    end

    function testdata(dir)
        path = datafile(DEPNAME, TESTFILE, dir)
        xs = readdata(path)
        ys = makeys(xs)
        xs, ys
    end

    function readdata(path)
        lines = open(readlines, path)
        map(l -> Vector{String}(split(chomp(l))), lines)
    end

    function makeys(xs::Vector{Vector{String}})
        map(xs) do x
            y = copy(x)
            popfirst!(y)
            push!(y, "<eos>")
        end
    end

    function __init__()
        register(DataDep(
            DEPNAME,
            """
            Dataset: Penn Treebank sentences for language modeling
            Website: https://github.com/tomsercu/lstm

            -----------------------------------------------------
            WARNING: EXPERIMENTAL STATUS
            Please be aware that this dataset is from a secondary
            source. The provided interface by this package is not
            as developed as those for other datasets. We would
            welcome any contribution to provide this dataset in a
            more mature manner.
            ------------------------------------------------------

            The PTBLM dataset consists of Penn Treebank sentences
            for language modeling, available from tomsercu/lstm.
            The unknown words are replaced with <unk> so that the
            total vocaburary size becomes 10000.

            The files are available for download at the github
            repository linked above. Note that using the data
            responsibly and respecting copyright remains your
            responsibility.
            """,
            "https://raw.githubusercontent.com/tomsercu/lstm/master/data/" .* [TRAINFILE, TESTFILE],
            "218f4e6c7288bb5efeb03cc4cb8ae9c04ecd8462ebfba8e13e3549fab69dc25f",
        ))
    end
end
