function __init__smsspam()

    DEPNAME = "SMSSpamCollection"
    LINK = "https://raw.githubusercontent.com/mohitgupta-omg/Kaggle-SMS-Spam-Collection-Dataset-/master/"
    LINK = "https://archive.ics.uci.edu/ml/machine-learning-databases/00228/"
    DOCS = "https://archive.ics.uci.edu/ml/datasets/SMS+Spam+Collection#"
    DATA = "smsspamcollection.zip"

    register(DataDep(
        DEPNAME,
        """
        Dataset: The SMS Spam Collection v.1
        Website: $DOCS
        """,
        LINK .* [DATA],
        "1587ea43e58e82b14ff1f5425c88e17f8496bfcdb67a583dbff9eefaf9963ce3",
        post_fetch_method = unpack
    ))
end


"""
    SMSSpamCollection(; dir=nothing)


The SMS Spam Collection v.1 (hereafter the corpus) is a set of SMS tagged messages 
that have been collected for SMS Spam research. It contains one set of SMS messages
in English of 5,574 messages, tagged acording being ham (legitimate) or spam.
The corpus has a total of 4,827 SMS legitimate messages (86.6%) and a total of 747 (13.4%) spam messages.

The corpus has been collected by Tiago Agostinho de Almeida (http://www.dt.fee.unicamp.br/~tiago) 
and José María Gómez Hidalgo (http://www.esp.uem.es/jmgomez).

```julia-repl
julia> using MLDatasets: SMSSpamCollection

julia> targets = SMSSpamCollection.targets();

julia> summary(targets)
"5574-element Vector{Any}"

julia> targets[1]
"ham"

julia> summary(features)
"5574-element Vector{Any}"
"""
struct SMSSpamCollection <: SupervisedDataset
    metadata::Dict{String,Any}
    features::Vector{String}
    targets::Vector{String}
end

function SMSSpamCollection(; dir = nothing)
    DEPNAME = "SMSSpamCollection"
    path = datafile(DEPNAME, "SMSSpamCollection", dir)
    spam_data = open(readlines, path)
    spam_data = [split(str, "\t") for str in spam_data]
    @assert all(x -> length(x)==2, spam_data)
    targets = [s[1] for s in spam_data] 
    features = [s[2] for s in spam_data] 
    
    metadata = Dict{String,Any}()
    metadata["n_observations"] = length(features)
    SMSSpamCollection(metadata, features, targets)
end


# DEPRECATED in V0.6
function Base.getproperty(::Type{SMSSpamCollection}, s::Symbol)
    if s == :features
        @warn "SMSSpamCollection.features() is deprecated, use `SMSSpamCollection().features` instead."
        return () -> SMSSpamCollection().features
    elseif s == :targets
        @warn "SMSSpamCollection.targets() is deprecated, use `SMSSpamCollection().targets` instead."
        return () -> SMSSpamCollection().targets
    else 
        return getfield(Titanic, s)
    end
end


