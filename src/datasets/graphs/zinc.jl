function __init__zinc()
    DEPNAME    = "ZINC"
    DOCS       = "https://pubs.acs.org/doi/abs/10.1021/acs.jcim.5b00559"
    SPLIT_LINK = "https://raw.githubusercontent.com/graphdeeplearning/" *
                 "benchmarking-gnns/master/data/molecules"
    # NOTE for maintainer: NPZ files are currently hosted on the contributor's fork.
    # Please re-upload to JuliaML/MLDatasets.jl releases and update this link on merge.
    NPZ_LINK   = "https://github.com/Uneeb808/MLDatasets.jl/" *
                 "releases/download/zinc-data"

    register(DataDep(
        DEPNAME,
        """
        Dataset: ZINC Molecular Graph Dataset
        Website: $DOCS

        ~250,000 molecular graphs for graph-level regression of penalized logP
        (y = logP - SAS - cycles). Includes a 12k benchmark subset used in
        "Benchmarking Graph Neural Networks" (Dwivedi et al. 2020).

        Please cite:
          Irwin et al. (2012)         https://pubs.acs.org/doi/abs/10.1021/acs.jcim.5b00559
          Gomez-Bombarelli et al.     https://arxiv.org/abs/1610.02415
          Dwivedi et al. (2020)       https://arxiv.org/abs/2003.00982
        """,
        [
            "$NPZ_LINK/train.npz",
            "$NPZ_LINK/val.npz",
            "$NPZ_LINK/test.npz",
            "$SPLIT_LINK/train.index",
            "$SPLIT_LINK/val.index",
            "$SPLIT_LINK/test.index",
        ],
        [
            "139abb0fb3ce4305c2c04e3c6f55e771022bcf392b4dbb7fb315690f56cd2a96",
            "e2d5dad38bd2bff0e2559b463420fd570d290c80910f58b90bd3c7bead8c1149",
            "27b61afc6a660871cd7054bc0a29e6240d9c25290e3ebf1a4bf0d320aa906327",
            "575d6acd72ac207a95947e2bdd16411ef6fc3faa88c2f55a2c496ea43022a6d8",
            "fe48c38157f0d38e7fc441903a143392eda080511a79e8fb8f60f5c1b0a9c164",
            "6aa50d98976044fb36089afef5b4c991b429ca1c8e009d33a0319e42a2d9b525",
        ]
    ))
end


"""
    ZINC(; split=:train, subset=false, dir=nothing)

The ZINC dataset from the [ZINC database](https://pubs.acs.org/doi/abs/10.1021/acs.jcim.5b00559)
and the [Automatic Chemical Design](https://arxiv.org/abs/1610.02415) paper.

~250,000 molecular graphs with a penalized logP regression target
(`y = logP - SAS - cycles`). The 12k benchmark subset follows the
[Benchmarking GNNs](https://arxiv.org/abs/2003.00982) paper split.

# Arguments
- `split`  : `:train`, `:val`, or `:test`. (default: `:train`)
- `subset` : Load the 12k benchmark subset instead of the full 250k. (default: `false`)
- `dir`    : Custom data directory. Uses DataDeps default if not set.

# Features
- Node features: atom type, integer in `[1, 28]` → `g.node_data.features`
- Edge features: bond type, integer in `[1, 4]`  → `g.edge_data.bond_type`
- Graph target:  penalized logP, Float32          → `d.graph_data.targets[i]`

# Examples

```julia
data = ZINC(split=:train, subset=true)
g, y = data[1]
println(g.num_nodes)           # number of atoms
println(g.node_data.features)  # atom types (1-indexed)
println(g.edge_data.bond_type) # bond types (1-indexed)
println(y)                     # penalized logP

graphs, targets = data[:]      # all at once
batch = data[1:32]             # minibatch
```

# Dataset statistics

Full variant:

| Split | Graphs  | Avg nodes | Avg edges |
|-------|---------|-----------|-----------|
| train | 220,011 | ~23.2     | ~49.8     |
| val   |  24,445 | ~23.2     | ~49.8     |
| test  |   5,000 | ~23.2     | ~49.8     |

Subset (benchmark) variant:

| Split | Graphs |
|-------|--------|
| train | 10,000 |
| val   |  1,000 |
| test  |  1,000 |
"""
struct ZINC <: AbstractDataset
    metadata::Dict{String, Any}
    graphs::Vector{Graph}
    graph_data::NamedTuple
end


function ZINC(; split = :train, subset = false, dir = nothing)
    @assert split in [:train, :val, :test] "split must be :train, :val, or :test"

    root      = isnothing(dir) ? datadep"ZINC" : dir
    split_str = String(split)
    data_dir  = _zinc_data_dir(root)

    npz_path = joinpath(data_dir, "$split_str.npz")
    isfile(npz_path) || error("Cannot find $npz_path. Ensure the ZINC data downloaded correctly.")

    data = NPZ.npzread(npz_path)

    # everything is stored as flat 1D arrays; node_counts/edge_counts tell us
    # where each molecule starts and ends
    atom_types_flat = data["atom_types"]
    edge_src_flat   = data["edge_src"]
    edge_dst_flat   = data["edge_dst"]
    bond_attrs_flat = data["bond_attrs"]
    node_counts     = data["node_counts"]
    edge_counts     = data["edge_counts"]
    targets_all     = data["targets"]

    node_offsets = vcat(0, cumsum(Int.(node_counts)))
    edge_offsets = vcat(0, cumsum(Int.(edge_counts)))

    # for subset=true, read the official benchmark index file (0-based → 1-based)
    indices = if subset
        index_path = joinpath(root, "$split_str.index")
        isfile(index_path) || (index_path = joinpath(data_dir, "$split_str.index"))
        _read_index_file(index_path)
    else
        collect(1:length(targets_all))
    end

    graphs  = Vector{Graph}(undef, length(indices))
    targets = Vector{Float32}(undef, length(indices))

    for (out_idx, mol_idx) in enumerate(indices)
        ns = node_offsets[mol_idx] + 1;  ne = node_offsets[mol_idx + 1]
        es = edge_offsets[mol_idx] + 1;  ee = edge_offsets[mol_idx + 1]

        # Python uses 0-based atom/bond indices, Julia uses 1-based
        atom_type  = Int.(atom_types_flat[ns:ne]) .+ 1
        src        = Int.(edge_src_flat[es:ee])   .+ 1
        dst        = Int.(edge_dst_flat[es:ee])   .+ 1
        bond_attrs = Int.(bond_attrs_flat[es:ee])

        graphs[out_idx] = Graph(
            num_nodes  = length(atom_type),
            edge_index = (src, dst),
            node_data  = (features  = atom_type,),
            edge_data  = (bond_type = bond_attrs,),
        )

        targets[out_idx] = targets_all[mol_idx]
    end

    metadata = Dict{String, Any}(
        "split"          => split,
        "subset"         => subset,
        "variant"        => subset ? "subset" : "full",
        "num_graphs"     => length(graphs),
        "num_atom_types" => 28,
        "num_bond_types" => 4,
        "task"           => "graph regression",
        "target"         => "penalized logP  (logP - SAS - cycles)",
    )

    return ZINC(metadata, graphs, (targets = targets,))
end


Base.length(d::ZINC) = length(d.graphs)

function Base.getindex(d::ZINC, ::Colon)
    return (; d.graphs, d.graph_data.targets)
end

function Base.getindex(d::ZINC, i)
    return getobs((; d.graphs, d.graph_data.targets), i)
end

function Base.show(io::IO, ::MIME"text/plain", d::ZINC)
    recur_io = IOContext(io, :compact => false)
    print(io, "ZINC $(d.metadata["variant"]) - $(d.metadata["split"]):")
    for f in fieldnames(ZINC)
        startswith(string(f), "_") && continue
        print(recur_io, "\n  $(leftalign(string(f), 12))  =>    $(_summary(getfield(d, f)))")
    end
end


# finds where the npz files live — handles fresh DataDeps download (root)
# and local dev with original pickle layout (molecules/ subfolder)
function _zinc_data_dir(root::String)
    isfile(joinpath(root, "train.npz")) && return root
    candidate = joinpath(root, "molecules")
    isdir(candidate) && return candidate
    error("Cannot locate ZINC data under $root.")
end

# index files are comma-separated 0-based ints, convert to 1-based for Julia
function _read_index_file(path::String)::Vector{Int}
    return parse.(Int, split(strip(read(path, String)), ",")) .+ 1
end