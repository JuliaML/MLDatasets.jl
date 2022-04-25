# """
#     readimageheader(io::IO)

# Reads four 32 bit integers at the current position of `io` and
# interprets them as a MNIST-image-file header, which is described
# in detail in the table below

#             ║     First    │  Second  │  Third  │   Fourth
#     ════════╬══════════════╪══════════╪═════════╪════════════
#     offset  ║         0000 │     0004 │    0008 │       0012
#     descr   ║ magic number │ # images │  # rows │  # columns

# These four numbers are returned as a Tuple in the same storage order
# """
function readimageheader(io::IO)
    magic_number = bswap(read(io, UInt32))
    total_items  = bswap(read(io, UInt32))
    nrows = bswap(read(io, UInt32))
    ncols = bswap(read(io, UInt32))
    UInt32(magic_number), Int(total_items), Int(nrows), Int(ncols)
end

# """
#     readimageheader(file::AbstractString)

# Opens and reads the first four 32 bits values of `file` and
# returns them interpreted as an MNIST-image-file header
# """
function readimageheader(file::AbstractString)
    gzopen(readimageheader, file, "r")::Tuple{UInt32,Int,Int,Int}
end

# """
#     readlabelheader(io::IO)

# Reads two 32 bit integers at the current position of `io` and
# interprets them as a MNIST-label-file header, which consists of a
# *magic number* and the *total number of labels* stored in the
# file. These two numbers are returned as a Tuple in the same
# storage order.
# """
function readlabelheader(io::IO)
    magic_number = bswap(read(io, UInt32))
    total_items  = bswap(read(io, UInt32))
    UInt32(magic_number), Int(total_items)
end

# """
#     readlabelheader(file::AbstractString)

# Opens and reads the first two 32 bits values of `file` and
# returns them interpreted as an MNIST-label-file header
# """
function readlabelheader(file::AbstractString)
    gzopen(readlabelheader, file, "r")::Tuple{UInt32,Int}
end
