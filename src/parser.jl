struct Parser
    tokens::Array{Token}
    Parser(tokens) = new(copy(tokens))
end

function (parser::Parser)(rbp=0)
    left = nud!(parser, next!(parser))
    while precedence(peek(parser)) > rbp
        left = led!(parser, left)
    end
    left
end

next!(parser) = isempty(parser.tokens) ? EOF() : popfirst!(parser.tokens)
peek(parser, n = 1) = length(parser.tokens) < n ? EOF() : parser.tokens[n]

function expect!(parser, T)
    token = popfirst!(parser.tokens)
    @assert token isa T "Unexpected token type: got $(typeof(token)) expected $T"
    token
end

function nud!(parser, token::Float)
    if peek(parser) isa Bang #or another postfix operator
        led!(parser, token.value, next!(parser))
    else
        token.value
    end
 end

function nud!(parser, token::LBracket)
    inner = parser()
    expect!(parser, RBracket)
    inner
end

nud!(parser, token::Plus) = parser(precedence(token))
nud!(parser, token::Minus) = Node(:minus, [parser(precedence(token)) ])

#This could be extended to regonise other keywords
function nud!(parser, token::Str)
    expect!(parser, LBracket)
    inner = parser()
    expect!(parser, RBracket)
    Node(Symbol(token.value), [inner])
end

function led!(parser, left)
    token = next!(parser)
    led!(parser, left, token)
end

led!(parser, left, token::Plus) = Node(:plus, [left, parser(precedence(token))])
led!(parser, left, token::Minus) = Node(:minus, [left, parser(precedence(token))])
led!(parser, left, token::Divide) = Node(:divide, [left, parser(precedence(token))])
led!(parser, left, token::Multiply) = Node(:multiply, [left, parser(precedence(token))])
led!(parser, left, token::Power) = Node(:power, [left, parser(precedence(token) - 1)])
led!(parser, left, token::Bang) = Node(:bang, [left])

precedence(token) = 0
precedence(token::Plus) = 20
precedence(token::Minus) = 20
precedence(token::Multiply) = 30
precedence(token::Divide) = 30
precedence(token::Bang) = 30
precedence(token::Power) = 40

struct Node
    head::Symbol
    tail::Array
    Node(head, tail) = new(head, [tail...])
end

Node(head, tail...) = Node(head, collect(tail))
Base.:(==)(x::Node, y::Node) = x.head === y.head && isequal(x.tail, y.tail)
