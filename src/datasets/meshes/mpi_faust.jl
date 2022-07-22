function __init__faust()
    DEPNAME = "MPI-FAUST"
    DOCS = "http://faust.is.tue.mpg.de/"

    register(ManualDataDep(
        DEPNAME,
        """
        Dataset: $DEPNAME.
        Website: $DOCS
        """,
    ))
end

struct FAUST <: AbstractDataset
    scans::Vector
    registrations::Vector
    labels::Vector{Vector{Bool}}
    metadata::Dict{String, Any}
end

function FAUST(split=:train; dir=nothing)
    isnothing(dir) && (dir = datadep"MPI-FAUST")

    @assert split ∈ [:train, :test] "Only train and test splits are present in the dataset."

    registrations = []
    scans = []
    labels = []
    if split == :train
        trainig_dir = joinpath(dir, "training")
        reg_dir = joinpath(trainig_dir, "registrations")
        scan_dir = joinpath(trainig_dir, "scans")
        gt_dir = joinpath(trainig_dir, "ground_truth_vertices")
        for i in range(0, 99)
            reg_file = @sprintf("tr_reg_%03d.ply", i)
            scan_file = @sprintf("tr_scan_%03d.ply", i)
            gt_file = @sprintf("tr_gt_%03d.txt", i)
            scan = load(joinpath(scan_dir, scan_file))
            registration = load(joinpath(reg_dir, reg_file))
            gt = open(joinpath(gt_dir, gt_file)) do file
                s = readlines(file)
                map(x-> x == "1", s)
            end
            push!(scans, scan)
            push!(registrations, registration)
            push!(labels, gt)
        end
        return FAUST(scans, registrations, labels, Dict())
    end

    scan_dir = joinpath(dir, "test", "scans")
    for i in range(0, 199)
        scan_file = @sprintf("test_scan_%03d.ply", i)
        scan = load(joinpath(scan_dir, scan_file))
        push!(scans, scan)
    end
    interfile = joinpath(dir, "test", "challenge_pairs", "inter_challenge.txt")
    intrafile = joinpath(dir, "test", "challenge_pairs", "intra_challenge.txt")
    inter_pairs = read_challenge_file(interfile)
    intra_pairs = read_challenge_file(intrafile)
    metadata = Dict("Inter_Pairs" => inter_pairs, "Intra_Pairs" => intra_pairs)
    return FAUST(scans, registrations, labels, metadata)
end

function read_challenge_file(filename::String)::Vector{Tuple{Int, Int}}
    pairs = open(filename) do file
        s = readlines(file)
        map(x -> Tuple(parse.(Int, (split(x, "_")))), s)
    end
    return pairs
end

