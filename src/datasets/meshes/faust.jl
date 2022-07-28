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

"""
    FAUST(split=:train; dir=nothing)

The MPI FAUST dataset (2014).

FAUST contains 300 real, high-resolution human scans of 10 different subjects in 30 different poses,
with automatically computed ground-truth correspondences.

Each scan is a high-resolution, triangulated, non-watertight mesh acquired with a 3D multi-stereo system.

FAUST is subdivided into a training and a test set. The training set includes 100 scans (10 per subject)
with their corresponding ground-truth alignments. The test set includes 200 scans. The FAUST benchmark defines
100 preselected scan pairs, partitioned into two classes – 60 requiring intra-subject matching,
40 requiring inter-subject matching.

The dataset required to be downloaded manually from the [website](http://faust.is.tue.mpg.de/)
and extracted in the correct location. For information about where to place the dataset, refer to the example section.


# Dataset Variables

- `scans`: Vector of non-watertight scans in the form of `Mesh`.
- `registrations`: Vector of registrations corresponding to each scan in `scans`. \
`registrations` like `scans` are also in the form of `Mesh`.
- `labels`: For each scan in the training set, we provide the boolean Vector of length equal to the \
number of vertices in the corresponding scan. \
It represents which vertices were reliably registered by the corresponding registration.
- `metadata`: A dictionary containing additional information on the dataset. \
Currently only `:test` split has metadata containing information about the registrations required \
for the inter and intra challenge proposed by the author.

# Examples

## Loading the dataset

```julia-repl
julia> using MLDatasets

julia> dataset = FAUST()
[ Info: This program requested access to the data dependency MPI-FAUST
[ Info: It could not be found on your system. It requires manual installation.
┌ Info: Please install it to one of the directories in the DataDeps load path: /home/user/.julia/packages/DataDeps/EDWdQ/deps/data/MPI-FAUST,
│ /home/user/.julia/datadeps/MPI-FAUST,
│ /home/user/.julia/juliaup/julia-1.7.3+0.x86/local/share/julia/datadeps/MPI-FAUST,
│ /home/user/.julia/juliaup/julia-1.7.3+0.x86/share/julia/datadeps/MPI-FAUST,
│ /home/user/datadeps/MPI-FAUST,
│ /scratch/datadeps/MPI-FAUST,
│ /staging/datadeps/MPI-FAUST,
│ /usr/share/datadeps/MPI-FAUST,
└ or /usr/local/share/datadeps/MPI-FAUST
[ Info: by following the instructions:
┌ Info: Dataset: MPI-FAUST.
└ Website: http://faust.is.tue.mpg.de/
Once installed please enter 'y' reattempt loading, or 'a' to abort
[y/a]
```
Now download and extract the dataset into one of the given locations. For unix link systems, an example command can be
```bash
unzip -q <path-to-filename</filename.zip ~/.julia/datadeps
```
The corresponding folder tree should look like
```
├── test
│   ├── challenge_pairs
│   └── scans
└── training
    ├── ground_truth_vertices
    ├── registrations
    └── scans
```
Press `y` to re-attept loading.
```julia-repl
dataset FAUST:
  scans          =>    100-element Vector{Any}
  registrations  =>    100-element Vector{Any}
  labels         =>    100-element Vector{Vector{Bool}}
  metadata       =>    Dict{String, Any} with 0 entries
```

## Load train and test split

```julia-repl
julia> train_faust = FAUST(:train)
dataset FAUST:
  scans          =>    100-element Vector{Any}
  registrations  =>    100-element Vector{Any}
  labels         =>    100-element Vector{Vector{Bool}}
  metadata       =>    Dict{String, Any} with 0 entries
julia> test_faust = FAUST(:test)
dataset FAUST:
  scans          =>    100-element Vector{Any}
  registrations  =>    100-element Vector{Any}
  labels         =>    100-element Vector{Vector{Bool}}
  metadata       =>    Dict{String, Any} with 0 entries
```

## Scan, registrations and ground-truth

```julia-repl
julia> dataset = FAUST(); # defaults to train split
julia> scan = dataset.scans[1] # pick one scan
Mesh{3, Float32, Triangle}:
 Triangle(Float32[-0.0045452323, 0.08537669, 0.22134435], Float32[-0.0030340434, 0.08542955, 0.22206494],
Float32[-0.0042151767, 0.08697654, 0.22171047])
 Triangle(Float32[-0.05358432, 0.08490027, 0.17748278], Float32[-0.05379858, 0.083174236, 0.17670263],
Float32[-0.052645437, 0.08346437, 0.17816517])
.
.
.
 Triangle(Float32[-0.07851, -1.0956081, 0.07093428], Float32[-0.06905176, -1.0986279, 0.07775441],
Float32[-0.069199145, -1.0928112, 0.06812464])

julia> registration = dataset.registrations[1] # The corresponding registration
Mesh{3, Float32, Triangle}:
 Triangle(Float32[0.12491254, 0.51199615, 0.29041073], Float32[0.11376736, 0.5156298, 0.3007352],
Float32[0.119374536, 0.50043654, 0.29687837])
 Triangle(Float32[0.119374536, 0.50043654, 0.29687837], Float32[0.11376736, 0.5156298, 0.3007352],
Float32[0.10888693, 0.5008964, 0.30557302])
.
.
.
 Triangle(Float32[0.033744745, 0.030968456, 0.2359996], Float32[0.058017172, 0.044458304, 0.23422624],
Float32[0.03615713, 0.04858183, 0.23596591])

julia> label = dataset.labels[1] # The ground-truth/labels for each vertices in scan
176387-element Vector{Bool}:
 1
 1
 1
 .
 .
 .
 0
 0
 0
```

# Refereneces

1. [MPI Faust Website](http://faust.is.tue.mpg.de/)

2. Bogo, Federica & Romero, Javier & Loper, Matthew & Black, Michael. (2014). FAUST: Dataset
and evaluation for 3D mesh registration. Proceedings of the IEEE Computer Society Conference
on Computer Vision and Pattern Recognition. 10.1109/CVPR.2014.491.
"""
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
