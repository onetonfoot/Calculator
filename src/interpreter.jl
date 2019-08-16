include("parser.jl")

function interpret(node::Node)
    @match node.head begin
        :plus => (+)(interpret.(node.tail)...)
        :minus => (-)(interpret.(node.tail)...)
        :multiply => (*)(interpret.(node.tail)...)
        :divide => (/)(interpret.(node.tail)...)
        :power => (^)(interpret.(node.tail)...)
        :sin => sin(interpret.(node.tail)...)
        :cos => cos(interpret.(node.tail)...)
        :tan => tan(interpret.(node.tail)...)
        :bang => factorial(Int(node.tail[1]))
        op => error("Unknown operation $op")
    end
end

interpret(x::Number) = x
