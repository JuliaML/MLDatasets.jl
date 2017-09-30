import BinDeps

struct DownloadSettings
    url::String
    prompt::String
    files::Vector{String}
end

function downloaded_file(settings::DownloadSettings, dir, filename)
    path = joinpath(dir, filename)
    if !isfile(path)
        if isinteractive()
            download_helper(dir, settings.url, settings.files,
                            i_accept_the_terms_of_use = false,
                            prompt = settings.prompt)
        else
            error("The file \"$filename\" was not found in \"$dir\". ",
                  "You can download the dataset at $(settings.url), ",
                  "or try again from the REPL in order for ",
                  "`MLDatasets` to download it for you.")
        end
    end
    path
end

"""
    download_helper(dir, baseurl, files; [i_accept_the_terms_of_use = false], [prompt])

Check if the `files` are present in the specified `dir`, or if
any of the files are missing. In the case that any of the `files`
are missing and `i_accept_the_terms_of_use=false` the function
will raise a warning or an error depending on if julia is run in
an interactive session. If an interactive session is detected the
user will be presented with `prompt` and the option to
download the dataset to the specified `dir`.
"""
function download_helper(
        dir::AbstractString,
        baseurl::AbstractString,
        files::AbstractVector;
        i_accept_the_terms_of_use = false,
        prompt = error("Please provide a \"prompt\" for the given dataset"))
    missing = filter(file->!isfile(joinpath(dir, file)), files)
    if !isempty(missing)
        info("The specified directory \"$dir\" is missing the files ",
             join(map(f->"\"$f\"", missing), ", ", " and "),
             "of the full data set.")
        if !i_accept_the_terms_of_use && isinteractive()
            prompt = "\n" * prompt * "\nDo you want to download the dataset from $baseurl to \"$dir\"? [y/n] "
            print(prompt)
            answer = first(readline())
            if answer == 'y'
                i_accept_the_terms_of_use = true
            end
        end
        if i_accept_the_terms_of_use
            mkpath(dir)
            for file in missing
                url = baseurl * "$file"
                path = joinpath(dir, file)
                info("downloading $file from $url to $dir")
                run(BinDeps.download_cmd(url, path))
            end
        else
            error("Unable to download the dataset. Please visit $baseurl and download the files manually.")
        end
    else
        info("Nothing to do.")
    end
    nothing
end

function download_helper(settings::DownloadSettings,
                         dir::AbstractString;
                         kw...)
    download_helper(dir, settings.url, settings.files;
                    prompt = settings.prompt, kw...)
end
