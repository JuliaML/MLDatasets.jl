import BinDeps
using DataDeps

function with_accept(f, manual_overwrite)
    auto_accept = if manual_overwrite == nothing
        get(ENV, "DATADEPS_ALWAY_ACCEPT", false)
    else
        manual_overwrite
    end
    withenv(f, "DATADEPS_ALWAY_ACCEPT" => string(auto_accept))
end

function datadir(depname, dir = nothing; i_accept_the_terms_of_use = nothing)
    with_accept(i_accept_the_terms_of_use) do
        if dir == nothing
            # use DataDeps defaults
            @datadep_str depname
        else
            # use user-provided dir
            if isdir(dir)
                dir
            else
                !DataDeps.env_bool("DATADEPS_DISABLE_DOWNLOAD") || error("DATADEPS_DISABLE_DOWNLOAD enviroment variable set. Can not trigger download.")
                DataDeps.download(DataDeps.registry[depname], dir)
                dir
            end
        end
    end::String
end

function datafile(depname, filename, dir = nothing; recurse = true, kw...)
    path = joinpath(datadir(depname, dir; kw...), filename)
    if !isfile(path)
        warn("The file \"$path\" does not exist, even though the dataset-specific folder does. This is an unusual situation that may have been caused by a manual creation of an empty folder, or manual deletion of the given file \"$filename\".")
        info("Retriggering DataDeps.jl for \"$depname\" to \"$dir\".")
        download_dep(depname, dir; kw...)
        if recurse
            datafile(depname, filename, dir; recurse = false, kw...)
        else
            error("The file \"$path\" still does not exist. One possible explaination could be a spelling error in the name of the requested file.")
        end
    else
        path
    end::String
end

function download_dep(depname,
                      dir = DataDeps.determine_save_path(depname);
                      i_accept_the_terms_of_use = nothing)
    with_accept(i_accept_the_terms_of_use) do
        DataDeps.download(DataDeps.registry[depname], dir)
        nothing
    end
end
