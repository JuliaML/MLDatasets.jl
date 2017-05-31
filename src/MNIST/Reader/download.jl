msg_notfound(dir, filename) = "The MNIST file \"$filename\" was not found in \"$dir\". You can download the dataset at http://yann.lecun.com/exdb/mnist/, or alternatively use MNIST.download_helper(directory) to do it for you."

msg_prompt(dir, files) = """
Interactive session detected. MNIST.download_helper initiated.

Dataset: THE MNIST DATABASE of handwritten digits
Authors: Yann LeCun, Corinna Cortes, Christopher J.C. Burges
Website: http://yann.lecun.com/exdb/mnist/

[LeCun et al., 1998a]
    Y. LeCun, L. Bottou, Y. Bengio, and P. Haffner. "Gradient-based learning applied to document recognition." Proceedings of the IEEE, 86(11):2278-2324, November 1998

The specified directory \"$dir\" is missing the files $(join(map(f->"\"$f\"", files), ", ", " and ")) of the full data set.

The files are available for download at the offical website linked above.
We can download these files for you if you wish, but that doesn't free
you from the burden of using the data responsibly and respect copyright.
The authors of MNIST aren't really explicit about any terms of use,
so please read the website to make sure you want to download the dataset.

    http://yann.lecun.com/exdb/mnist/

Did you visit the website and want to download the dataset to \"$dir\"? [y/n] """

function downloaded_file(dir, filename)
    path = joinpath(dir, filename)
    if !isfile(path)
        if isinteractive()
            warn(msg_notfound(dir, filename))
            download_helper(dir)
        else
            error(msg_notfound(dir, filename))
        end
    end
    path
end

"""
    download_helper([dir]; [i_accept_the_terms_of_use = false])

Check if the MNIST dataset is contained in the specified `dir`,
or if any of the four files are missing. If `dir` is omitted it
will default to `MLDatasets/datasets/mnist`.

In the case that any of the four files are missing and
`i_accept_the_terms_of_use=false` the function will raise a
warning or an error depending on if julia is run in an
interactive session. If an interactive session is detected the
user will be presented with information and the option to
download the dataset to the specified `dir`.

If the download should happen automatically, please first visit
the website at http://yann.lecun.com/exdb/mnist, before setting
`i_accept_the_terms_of_use=true`.
"""
function download_helper(dir; i_accept_the_terms_of_use = false)
    files = filter(file->!isfile(joinpath(dir, file)),
                   [TRAINIMAGES, TRAINLABELS, TESTIMAGES, TESTLABELS])
    if !isempty(files)
        if !i_accept_the_terms_of_use && isinteractive()
            print(msg_prompt(dir, files))
            answer = first(readline())
            if answer == 'y'
                i_accept_the_terms_of_use = true
            end
        end
        if i_accept_the_terms_of_use
            mkdir(dir)
            for file in files
                url = "http://yann.lecun.com/exdb/mnist/$file"
                path = joinpath(dir, file)
                info("downloading $file from $url to $dir")
                download_cmd(url, path) |> run
            end
        else
            error("Unable to download the dataset. Please visit the website at http://yann.lecun.com/exdb/mnist and download the files manually.")
        end
    else
        info("Nothing to do.")
    end
    nothing
end
