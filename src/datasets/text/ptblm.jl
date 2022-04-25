
function __init__ptblm()
    DEPNAME = "PTBLM"
    TRAINFILE = "ptb.train.txt"
    TESTFILE  = "ptb.test.txt"

    register(DataDep(
        DEPNAME,
        """
        Dataset: Penn Treebank sentences for language modeling
        Website: https://github.com/tomsercu/lstm

        The files are available for download at the github
        repository linked above. Note that using the data
        responsibly and respecting copyright remains your
        responsibility.
        """,
        "https://raw.githubusercontent.com/tomsercu/lstm/master/data/" .* [TRAINFILE, TESTFILE],
        "218f4e6c7288bb5efeb03cc4cb8ae9c04ecd8462ebfba8e13e3549fab69dc25f",
    ))
end

"""
    PTBLM(; split=:train, dir=nothing)
    PTBLM(split; [dir])

The PTBLM dataset consists of Penn Treebank sentences
for language modeling, available from https://github.com/tomsercu/lstm.
The unknown words are replaced with <unk> so that the
total vocaburary size becomes 10000.
"""
struct PTBLM <: SupervisedDataset
    metadata::Dict{String, Any}
    split::Symbol
    features::Vector{Vector{String}}
    targets::Vector{Vector{String}}
end

PTBLM(; split=:train, dir=nothing) = PTBLM(split; dir)

function PTBLM(split::Symbol; dir=nothing)
    DEPNAME = "PTBLM"
    @assert split ∈ [:train, :test]
    FILE = split == :train ? "ptb.train.txt" : "ptb.test.txt"
    path = datafile(DEPNAME, FILE, dir)

    lines = open(readlines, path)
    @assert all(x -> x isa String, lines)
    features = map(l -> Vector{String}(Base.split(chomp(l))), lines)

    targets = map(features) do x
        y = copy(x)
        popfirst!(y)
        push!(y, "<eos>")
    end

    metadata = Dict{String,Any}("n_observations" => length(features))
    return PTBLM(metadata, split, features, targets)
end


# DEPRECATED INTERFACE, REMOVE IN v0.7 (or 0.6.x)
function Base.getproperty(::Type{PTBLM}, s::Symbol)
    if s === :traindata
        @warn "PTBLM.traindata() is deprecated, use `PTBLM(split=:train)[]` instead." maxlog=2
        function traindata(; dir=nothing)
            PTBLM(; split=:train, dir)[]
        end
        return traindata
    elseif s === :testdata
        @warn "PTBLM.testdata() is deprecated, use `PTBLM(split=:test)[]` instead."  maxlog=2
        function testdata(; dir=nothing)
            PTBLM(; split=:test, dir)[]
        end
        return testdata
    else
        return getfield(PTBLM, s)
    end
end
