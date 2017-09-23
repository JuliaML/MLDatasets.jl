import BinDeps

"""
    download_helper(dir, baseurl, files;
                    i_accept_the_terms_of_use = false,
                    msg_prompt = "")

Download in`dir` the `files` from address `baseurl`.

In order to proceed with the download `i_accept_the_terms_of_use=true` is required,
or  you will be prompted for confirmation (interactive mode only).
"""
function download_helper(dir, baseurl, files;
        i_accept_the_terms_of_use = false,
        msg_prompt = "")

    if !isempty(files)
        if !i_accept_the_terms_of_use && isinteractive()
            msg_prompt *= "\nDo you want to download the dataset from $baseurl to \"$dir\"? [y/n] "
            print(msg_prompt)
            answer = first(readline())
            if answer == 'y'
                i_accept_the_terms_of_use = true
            end
        end
        if i_accept_the_terms_of_use
            mkpath(dir)
            for file in files
                url = baseurl*"$file"
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
end
