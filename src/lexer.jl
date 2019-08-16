using MLStyle

include("tokenizer.jl")

abstract type Token end

#Seems this like a job for a macro...
struct EOF <: Token end
struct LBracket <: Token end
struct RBracket <: Token end
struct Comma <: Token end
struct Minus <: Token end
struct Plus <: Token end
struct Divide <: Token end
struct Multiply <: Token end
struct Power <: Token end
struct Bang <: Token end

struct Float <: Token
    value
end

struct Str <: Token
    value
end

function lexer(s)
    tokens = tokenize(s)
    map(tokens) do token
        token = "$token"
        @match token begin
            "+" => Plus()
            "-" => Minus()
            "*" => Multiply()
            "/" => Divide()
            "(" => LBracket()
            ")" => RBracket()
            "^" => Power()
            "!" => Bang()
            x && if isnumber(x) end => begin
                Float(parse(Float64, x))
            end
            x => Str(x)
        end
    end
end

:!
