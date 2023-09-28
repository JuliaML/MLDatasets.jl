function __init__metrla()
    DEPNAME = "TemporalBrains"
    LINK = "http://www-sop.inria.fr/members/Aurora.Rossi/index.html"
    register(ManualDataDep(DEPNAME,
                           """
                           Dataset: $DEPNAME
                           Website : $LINK
                           """))
end

struct TemporalBrains <: AbstractDataset
    graphs::Vector{Graph}
end

function tb_datadir(dir = nothing)
    dir = isnothing(dir) ? datadep"TemporalBrains" : dir
    LINK = "http://www-sop.inria.fr/members/Aurora.Rossi/data/LabelledTBN.zip"
    if length(readdir((dir))) == 0
        DataDeps.fetch_default(LINK, dir)
        currdir = pwd()
        cd(dir) # Needed since `unpack` extracts in working dir
        DataDeps.unpack(joinpath(dir, "LabelledTBN.zip"))
        # conditions when unzipped folder is our required data dir
        cd(currdir)
    end
    @assert isdir(dir)
    return dir
end