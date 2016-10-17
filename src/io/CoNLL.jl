export CoNLL
module CoNLL

function read(path::String, col::Union{Int,Tuple{Vararg{Int}},Range,Vector{Int}})
    doc = []
    sent = []
    lines = open(readlines, path)
    for line in lines
        line = chomp(line)
        if length(line) == 0
            length(sent) > 0 && push!(doc, sent)
            sent = []
        else
            items = split(line, '\t')
            if length(col) == 0
                data = Vector{String}(items)
            elseif typeof(col) == Int
                data = String(items[col])
            else
                data = map(c -> String(items[c]), col)
            end
            push!(sent, data)
        end
    end
    length(sent) > 0 && push!(doc, sent)
    T = typeof(doc[1][1])
    Vector{Vector{T}}(doc)
end
read(path::String) = read(path, Int[])

end
