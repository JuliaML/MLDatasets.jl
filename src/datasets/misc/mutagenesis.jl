function __init__mutagenesis()
    ORIGINAL_LINK = "https://relational.fit.cvut.cz/dataset/Mutagenesis"
    DATA_LINK = "https://raw.githubusercontent.com/CTUAvastLab/datasets/main/mutagenesis"
    DEPNAME = "Mutagenesis"
    DATA = "data.json"
    METADATA = "meta.json"
    
    register(DataDep(
        DEPNAME,
        """
        Dataset: The $DEPNAME dataset.
        Website: $ORIGINAL_LINK
        License: CC0
        """,
        "$DATA_LINK/" .* [DATA, METADATA],
        "80ec1716217135e1f2e0b5a61876c65184e2014e64551103c41e174775ca207c"
    ))
end

"""
    Mutagenesis(; split, dir=nothing)

The `Mutagenesis` dataset comprises 188 molecules trialed for mutagenicity on Salmonella typhimurium, available from
 [relational.fit.cvut.cz](https://relational.fit.cvut.cz/dataset/Mutagenesis) and
 [CTUAvastLab/datasets](https://github.com/CTUAvastLab/datasets/tree/main/mutagenesis).

Set `split` to `:train`, `:val`, `:test`, or `:all`, to select the training, 
validation, test partition respectively or the whole dataset.
The `indexes` field in the result contains the indexes of the partition in the
full dataset.

Website: https://relational.fit.cvut.cz/dataset/Mutagenesis
License: CC0

```julia-repl
julia> using MLDatasets: Mutagenesis

julia> dataset = Mutagenesis(split=:train)
Mutagenesis dataset:
  split : train
  indexes : 100-element Vector{Int64}
  features : 100-element Vector{Dict{Symbol, Any}}
  targets : 100-element Vector{Int64}

julia> dataset[1].features
Dict{Symbol, Any} with 5 entries:
  :lumo  => -1.246
  :inda  => 0
  :logp  => 4.23
  :ind1  => 1
  :atoms => Dict{Symbol, Any}[Dict(:element=>"c", :bonds=>Dict{Symbol, Any}[Dict(:element=>"c", :bond_type=>7, :charge=>-0.117, :atom_type=>22), Dict(:element=>"h", :bond_type=>1, :charge=>0.142, :atom_type=>3)…

julia> dataset[1].targets
1

julia> dataset = Mutagenesis(split=:all)
Mutagenesis dataset:
  split : all
  indexes : 188-element Vector{Int64}
  features : 188-element Vector{Dict{Symbol, Any}}
  targets : 188-element Vector{Int64}
```
"""
struct Mutagenesis <: SupervisedDataset
    metadata::Dict{Symbol, Any}
    split::Symbol
    indexes::Vector{Int}    # indexes of the split in the full dataset
    features::Vector{Dict{Symbol, Any}}
    targets::Vector{Int}
end

function Mutagenesis(; split::Symbol, dir=nothing)
    DEPNAME = "Mutagenesis"
    DATA = "data.json"
    METADATA = "meta.json"

    @assert split ∈ [:train, :val, :test, :all]
    
    data_path = datafile(DEPNAME, DATA, dir)
    metadata_path = datafile(DEPNAME, METADATA, dir)
    samples = open(JSON3.read, data_path)
    metadata = open(JSON3.read, metadata_path)
    labelkey = metadata["label"]
    targets = map(i -> i[labelkey], samples)
    features = map(x->delete!(copy(x), Symbol(labelkey)), samples)
    val_num = metadata["val_samples"]
    test_num = metadata["test_samples"]
    train_idxs = 1:length(samples)-val_num-test_num
    val_idxs = length(samples)-val_num-test_num+1:length(samples)-test_num
    test_idxs = length(samples)-test_num+1:length(samples)
    indexes = split == :train ? train_idxs :
              split == :val ? val_idxs : 
              split == :test ? test_idxs : 1:length(samples) 
    metadata = Dict(metadata)
    metadata[:data_path] = data_path
    metadata[:metadata_path] = metadata_path

    Mutagenesis(metadata, split, indexes, features[indexes], targets[indexes])
end

# deprecated in v0.6
function Base.getproperty(::Type{Mutagenesis}, s::Symbol)
    if s == :traindata
        @warn "Mutagenesis.traindata() is deprecated, use `Mutagenesis(split=:train)` instead."
        return (; dir=nothing) -> begin
                    d = Mutagenesis(; split=:train, dir)
                    d.features, d.targets    
                end
    elseif s == :valdata
        @warn "Mutagenesis.valdata() is deprecated, use `Mutagenesis(split=:val)` instead."
        return (; dir=nothing) -> begin
                    d = Mutagenesis(; split=:val, dir)
                    d.features, d.targets    
                end
    elseif s == :testdata
        @warn "Mutagenesis.testdata() is deprecated, use `Mutagenesis(split=:test)` instead."
        return (; dir=nothing) -> begin
                    d = Mutagenesis(; split=:test, dir)
                    d.features, d.targets    
                end
    else 
        return getfield(Mutagenesis, s)
    end
end
