export CoNLL
module CoNLL

function read(f, path::String)
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
read(path::String) = read(identity, path)

end
