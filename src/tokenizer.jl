using MLStyle

function tokenize(string)

    idx = 1
    tokens = []

    while idx <= length(string)
        @match string[idx] begin
            token && if occursin(token, "+*/^(),!") end => begin
                idx +=1
                push!(tokens, "$token");
            end

            # These two functions are exactly the same
            # so could be abstracted into one

            #This doesn't handle floats correctly
            token && if isdigit(token) end => begin
                peek_idx = idx + 1
                while peek_idx <= length(string)
                    if !isdigit(string[peek_idx])
                        break
                    else
                        peek_idx +=1
                    end
                end
                token = string[idx:peek_idx-1]
                push!(tokens, token)
                idx = peek_idx
            end

            #logic should be in a function
            token && if isletter(token) end => begin
                peek_idx = idx + 1
                while peek_idx <= length(string)
                    if !isletter(string[peek_idx])
                        break
                    else
                        peek_idx +=1
                    end
                end
                token = string[idx:peek_idx-1]
                push!(tokens, token)
                idx = peek_idx
            end

            token && if isspace(token) end => begin
                idx+=1
            end
            token => begin
                error("Unknown token $token")
            end
        end
    end
    tokens
end

function is_letter()

end

issomething(T) = x -> !isnothing(tryparse(T, "$x"))
isint = issomething(Int)
isfloat = issomething(Float64)
isnumber(x) = isint(x) || isfloat(x)
