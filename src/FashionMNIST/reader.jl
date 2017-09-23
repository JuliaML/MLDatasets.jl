import ..MNIST.Reader

Reader.set_msg_prompt("""
    Dataset: THE FashionMNIST DATABASE of fashion products
    Authors: Han Xiao, Kashif Rasul, Roland Vollgraf
    Website: https://github.com/zalandoresearch/fashion-mnist

    Paper: Han Xiao, Kashif Rasul, Roland Vollgraf "Fashion-MNIST: a Novel Image Dataset for Benchmarking Machine Learning Algorithms."

    The files are available for download at the offical website linked above.
    """)

Reader.set_baseurl("http://fashion-mnist.s3-website.eu-central-1.amazonaws.com/")
