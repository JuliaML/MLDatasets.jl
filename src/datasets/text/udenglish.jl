function __init__udenglish()
    DEPNAME = "UD_English"
    TRAINFILE = "en_ewt-ud-train.conllu"
    DEVFILE   = "en_ewt-ud-dev.conllu"
    TESTFILE  = "en_ewt-ud-test.conllu"

    register(DataDep(
        DEPNAME,
        """
        Dataset: Universal Dependencies - English Dependency Treebank Universal Dependencies English Web Treebank
        Authors: Natalia Silveira and Timothy Dozat and
                 Marie-Catherine de Marneffe and Samuel
                 Bowman and Miriam Connor and John Bauer and
                 Christopher D. Manning
        Website: https://github.com/UniversalDependencies/UD_English-EWT


        The files are available for download at the github
        repository linked above. Note that using the data
        responsibly and respecting copyright remains your
        responsibility. Copyright and License is discussed in
        detail on the Website.
        """,
        "https://raw.githubusercontent.com/UniversalDependencies/UD_English-EWT/master/" .* [TRAINFILE, DEVFILE, TESTFILE],
        "e26845c3c78140e15d82a425388bcc58016d511616e5c2669a2e580e8ae586c0"
        ))
end

"""
    UD_English(; split=:train, dir=nothing)
    UD_English(split=; [dir])

A Gold Standard Universal Dependencies Corpus for
English, built over the source material of the
English Web Treebank LDC2012T13
(https://catalog.ldc.upenn.edu/LDC2012T13).

The corpus comprises 254,825 words and 16,621 sentences, 
taken from five genres of web media: weblogs, newsgroups, emails, reviews, and Yahoo! answers. 
See the LDC2012T13 documentation for more details on the sources of the sentences. 
The trees were automatically converted into Stanford Dependencies and then hand-corrected to Universal Dependencies. 
All the basic dependency annotations have been single-annotated, a limited portion of them have been double-annotated, 
and subsequent correction has been done to improve consistency. Other aspects of the treebank, such as Universal POS, 
features and enhanced dependencies, has mainly been done automatically, with very limited hand-correction.


Authors: Natalia Silveira and Timothy Dozat and
            Marie-Catherine de Marneffe and Samuel
            Bowman and Miriam Connor and John Bauer and
            Christopher D. Manning
Website: https://github.com/UniversalDependencies/UD_English-EWT
"""
struct UD_English <: UnsupervisedDataset
    metadata::Dict{String,Any}
    split::Symbol
    features::Vector{Vector{Vector{String}}}
end

UD_English(; split=:train, dir=nothing) = UD_English(split; dir)

function UD_English(split::Symbol; dir=nothing)
    DEPNAME = "UD_English"
    TRAINFILE = "en_ewt-ud-train.conllu"
    DEVFILE   = "en_ewt-ud-dev.conllu"
    TESTFILE  = "en_ewt-ud-test.conllu"

    @assert split ∈ [:train, :test, :dev]
    
    
    FILE = split == :train ? TRAINFILE : 
           split == :test ? TESTFILE :
           split === :dev ? DEVFILE : error()

    path = datafile(DEPNAME, FILE, dir)

    doc = []
    sent = []
    lines = open(readlines, path)
    for line in lines
        line = chomp(line)
        if length(line) == 0
            length(sent) > 0 && push!(doc, sent)
            sent = []
        elseif line[1] == '#' # comment line
            continue
        else
            items = Vector{String}(Base.split(line,'\t'))
            push!(sent, items)
        end
    end
    length(sent) > 0 && push!(doc, sent)
    T = typeof(doc[1][1])
    features = Vector{Vector{T}}(doc)

    metadata = Dict{String,Any}("n_observations" => length(features))
    return UD_English(metadata, split, features)
end
