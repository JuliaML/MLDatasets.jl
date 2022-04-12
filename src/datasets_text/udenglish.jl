export UD_English

"""
    UD_English

Dataset: Universal Dependencies - English Dependency Treebank Universal Dependencies English Web Treebank
Authors: Natalia Silveira and Timothy Dozat and
            Marie-Catherine de Marneffe and Samuel
            Bowman and Miriam Connor and John Bauer and
            Christopher D. Manning
Website: https://github.com/UniversalDependencies/UD_English-EWT

A Gold Standard Universal Dependencies Corpus for
English, built over the source material of the
English Web Treebank LDC2012T13
(https://catalog.ldc.upenn.edu/LDC2012T13).
"""
module UD_English

    using DataDeps
    using ..MLDatasets
    using ..MLDatasets: datafile, download_dep

    export

        traindata,
        testdata,

        download

    const DEPNAME = "UD_English"
    const TRAINFILE = "en_ewt-ud-train.conllu"
    const DEVFILE   = "en_ewt-ud-dev.conllu"
    const TESTFILE  = "en_ewt-ud-test.conllu"

    download(args...; kw...) = download_dep(DEPNAME, args...; kw...)

    traindata(; dir = nothing) = traindata(dir)
    devdata(; dir = nothing)   = devdata(dir)
    testdata(; dir = nothing)  = testdata(dir)

    traindata(dir) = readdata(dir, TRAINFILE)
    devdata(dir)   = readdata(dir, DEVFILE)
    testdata(dir)  = readdata(dir, TESTFILE)

    function readdata(dir, filename)
        path = datafile(DEPNAME, filename, dir)
        conll_read(path)
    end

    function conll_read(f, path::String)
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
                items = Vector{String}(split(line,'\t'))
                push!(sent, f(items))
            end
        end
        length(sent) > 0 && push!(doc, sent)
        T = typeof(doc[1][1])
        Vector{Vector{T}}(doc)
    end
    
    conll_read(path::String) = read(identity, path)
    

    function __init__()
        register(DataDep(
            DEPNAME,
            """
            Dataset: Universal Dependencies - English Dependency Treebank Universal Dependencies English Web Treebank
            Authors: Natalia Silveira and Timothy Dozat and
                     Marie-Catherine de Marneffe and Samuel
                     Bowman and Miriam Connor and John Bauer and
                     Christopher D. Manning
            Website: https://github.com/UniversalDependencies/UD_English-EWT

            A Gold Standard Universal Dependencies Corpus for
            English, built over the source material of the
            English Web Treebank LDC2012T13
            (https://catalog.ldc.upenn.edu/LDC2012T13).

            You are encouraged to cite this paper if you use the
            Universal Dependencies English Web Treebank:

                @inproceedings{silveira14gold,
                    year = {2014},
                    author = {Natalia Silveira and Timothy Dozat
                        and Marie-Catherine de Marneffe and Samuel
                        Bowman and Miriam Connor and John Bauer and
                        Christopher D. Manning},
                    title = {A Gold Standard Dependency Corpus for {E}nglish},
                    booktitle = {Proceedings of the Ninth
                        International Conference on Language Resources
                        and Evaluation (LREC-2014)}
                }

            The files are available for download at the github
            repository linked above. Note that using the data
            responsibly and respecting copyright remains your
            responsibility. Copyright and License is discussed in
            detail on the Website.
            """,
            "https://raw.githubusercontent.com/UniversalDependencies/UD_English-EWT/master/" .* [TRAINFILE, DEVFILE, TESTFILE],
            "e08d57e95264ac97ca861261e3119e093c054453c5dfc583e2402459504d93b7"
        ))
    end
end
