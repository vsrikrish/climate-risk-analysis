# This file was generated, do not modify it. # hide
# initialize variables, as this code works by iterating over each coin flip and adding
let payoff = 0, count = 0

    # loop over coin flips and compute payoff: this code is pretty literal with the rules of the game other than just using `rand()` to produce the heads vs. tails coin outcome.
    for i in 1:10
        U = rand()
        if U < 0.5
            count += 1
        else
            count = 0
        end
        if count == 3
            payoff = 1
        end
    end
    @show payoff;
end