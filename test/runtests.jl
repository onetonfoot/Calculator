using Test, Calculator
import Calculator: Node, tokenize, interpret


@testset "tokenize" begin
    @test all(tokenize("sin(x, 50)") .== ["sin", "(", "x", ",", "50", ")"])
end

@testset "lexer" begin
    import Calculator: Float, Power
    tokens = lexer("2 ^ 3 ^ 4")
    @test all(tokens .== [Float(2.0), Power(), Float(3.0), Power(), Float(4.0)])
end

@testset "parser" begin
    @testset "power" begin
        tokens = lexer("2 ^ 3 ^ 4")
        parser = Parser(tokens)
        ast = parser()
        @test ast == Node(:power, 2.0, Node(:power, 3.0 ,4.0 ))
    end

    @testset "bang" begin
        tokens = lexer("5! + 10")
        parser = Parser(tokens)
        ast = parser()
        interpret(ast) == 130
    end

    @testset "trig" begin
        tokens = lexer("sin(1)")
        parser = Parser(tokens)
        ast = parser()
        @test ast == Node(:sin, 1.0)

        tokens = lexer("cos(1) + sin(10)")
        parser = Parser(tokens)
        ast = parser()
        @test ast == Node(:plus, Node(:cos, 1.0), Node(:sin, 10.0))

        tokens = lexer("cos(1/10) + sin(2^8 + 5)")
        parser = Parser(tokens)
        ast = parser()
        ans = cos(1 / 10) + sin(2^8 + 5)
        @test ans == interpret(ast)
    end
end
