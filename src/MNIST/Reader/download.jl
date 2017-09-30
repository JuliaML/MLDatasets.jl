baseurl = "http://yann.lecun.com/exdb/mnist/"

set_baseurl(url) = (global baseurl = url)

msg_prompt =  """
    Dataset: THE MNIST DATABASE of handwritten digits
    Authors: Yann LeCun, Corinna Cortes, Christopher J.C. Burges
    Website: http://yann.lecun.com/exdb/mnist/

    [LeCun et al., 1998a]
        Y. LeCun, L. Bottou, Y. Bengio, and P. Haffner.
        "Gradient-based learning applied to document recognition."
        Proceedings of the IEEE, 86(11):2278-2324, November 1998

    The files are available for download at the offical website linked above.
    We can download these files for you if you wish, but that doesn't free
    you from the burden of using the data responsibly and respect copyright.
    The authors of MNIST aren't really explicit about any terms of use,
    so please read the website to make sure you want to download the dataset.
    """

set_msg_prompt(msg) = (global msg_prompt = msg)


msg_notfound(dir, filename, baseurl) = """
            The file \"$filename\" was not found in \"$dir\".
            You can download the dataset at $baseurl, or try again from the REPL in order
            for `MLDatasets` to download it for you.
            """

function downloaded_file(dir, filename)
    path = joinpath(dir, filename)
    if !isfile(path)
        if isinteractive()
            files = filter(file->!isfile(joinpath(dir, file)),
                    [TRAINIMAGES, TRAINLABELS, TESTIMAGES, TESTLABELS])
            warn("The specified directory \"$dir\" is missing the files
                    $(join(map(f->"\"$f\"", files), ", ", " and ")) of the full data set.")

            download_helper(dir, baseurl, files, i_accept_the_terms_of_use=false, msg_prompt=msg_prompt)
        else
            error(msg_notfound(dir, filename, baseurl))
        end
    end
    return path
end
