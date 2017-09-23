msg_notfound(dir, filename) = "The FashionMNIST file \"$filename\" was not found in \"$dir\".
                                You can download the dataset at https://github.com/zalandoresearch/fashion-mnist,
                                or alternatively use FashionMNIST.download_helper(directory) to do it for you."

msg_prompt(dir, files) = """
Interactive session detected. FashionMNIST.download_helper initiated.

Dataset: THE FashionMNIST DATABASE of fashion products
Authors: Han Xiao, Kashif Rasul, Roland Vollgraf
Website: https://github.com/zalandoresearch/fashion-mnist

Paper: Han Xiao, Kashif Rasul, Roland Vollgraf "Fashion-MNIST: a Novel Image Dataset for Benchmarking Machine Learning Algorithms."

The specified directory \"$dir\" is missing the files $(join(map(f->"\"$f\"", files), ", ", " and ")) of the full data set.

The files are available for download at the offical website linked above.
We can download these files for you if you wish.
You want to download the dataset to \"$dir\"? [y/n] """

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
    download_helper(dir; i_accept_the_terms_of_use = true)

Check if the FashionMNIST dataset is contained in the specified `dir`,
or if any of the four files are missing. If `dir` is omitted it
will default to `MLDatasets/datasets/fashion_mnist`.

In the case that any of the four files is missing the user will be presented
with the option to download it to the specified `dir`.
"""
function download_helper(dir; i_accept_the_terms_of_use = true)
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
            mkpath(dir)
            for file in files
                url = "http://fashion-mnist.s3-website.eu-central-1.amazonaws.com/$file"
                path = joinpath(dir, file)
                info("downloading $file from $url to $dir")
                run(download_cmd(url, path))
            end
        else
            error("Unable to download the dataset. Please visit the website at https://github.com/zalandoresearch/fashion-mnist and download the files manually.")
        end
    else
        info("Nothing to do.")
    end
    nothing
end
