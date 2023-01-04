<!--This file was generated, do not modify it.-->
## Overview

### Instructions

- Problems 1-4 consist of a series of code snippets for you to interpret and debug. For Problems 1-3, you will be asked to identify relevant error(s) and fix the code. For Problem 4, the code works as intended; your goal is to identify the code's purpose by following its logic.
- Problem 5 asks you to rewrite a "script" into a function, which you will then use to conduct an experiment.

## Problems (Total: 100 Points)

### Problem 1 (20 points)

You've been tasked with writing code to identify the minimum value in an array. You cannot use a predefined function. Your colleague suggested the function below, but it does not return the minimum value.

````julia:ex1
function minimum(array)
    min_value = 0
    for i in 1:length(array)
        if array[i] < min_value
            min_value = array[i]
        end
    end
    return min_value
end

array_values = [89, 90, 95, 100, 100, 78, 99, 98, 100, 95]
@show minimum(array_values);
````

#### Problem 1.1 (10 points)

Describe the logic error.

#### Problem 1.2 (5 points)

Write a fixed version of the function.

#### Problem 1.3 (5 points)

Use your fixed function to find the minimum value of `array_values`.

### Problem 2 (20 points)

Your team is trying to compute the average grade for your class, but the following code produces an error.

````julia:ex2
student_grades = [89, 90, 95, 100, 100, 78, 99, 98, 100, 95]
function class_average(grades)
  average_grade = mean(student_grades)
  return average_grade
end

try # hide
@show average_grade;
catch err; showerror(stderr, err); end  # hide
````

#### Problem 2.1 (10 points)

Describe the logic and/or syntax error.

#### Problem 2.2 (5 points)

Write a fixed version of the code.

#### Problem 2.3 (5 points)

Use your fixed code to compute the average grade for the class.

### Problem 3 (20 points)

Your team has collected data on the mileage of different car models. You want to calculate the average mileage per gallon (MPG) for the different cars, but your code produces the same value for all of the vehicles, which makes you suspicious.

````julia:ex3
function calculate_MPG((miles, gallons))
    return miles / gallons
end

car_miles =  [(334, 11), (289, 15), (306, 12), (303, 20), (350, 20), (294, 14)]

mpg = zeros(length(car_miles))

for i in 1:length(car_miles)
    miles = car_miles[1][1]
    gallon = car_miles[1][2]
    mpg[i] = calculate_MPG((miles, gallon))
end
@show mpg;
````

##### Problem 3.1 (10 points)

Describe the logic error.

#### Problem 3.2 (5 points)

Write a fixed version of the code.

#### Problem 3.3 (5 points)

Use your fixed code to compute the MPGs.

### Problem 4 (20 points)

You've been handed some code to analyze. The original coder was not very considerate of other potential users: the function is called `mystery_function` and there are no comments explaining the purpose of the code. It appears to take in an array and return some numbers, and you've been assured that the code works as intended.

````julia:ex4
function mystery_function(values)
    y = []
    for v in values
        if !(v in y)
            append!(y, v)
        end
    end
    return y
end

list_of_values = [1, 2, 3, 4, 3, 4, 2, 1]
@show mystery_function(list_of_values);
````

#### Problem 4.1 (10 points)

Explain the purpose of `mystery_function`.

#### Problem 4.2 (10 points)

Add comments to the code, explaining why and how it works. Refer to ["Best Practices for Writing Code Comments"](https://stackoverflow.blog/2021/12/23/best-practices-for-writing-code-comments/), and remember that bad comments can be just as bad as no comments at all. You do not need to add comments to every line (in fact, this is very bad practice), but you should note the *purpose* of every "section" of code, and add comments explaining any code sequences that you don't immediately understand.

### Problem 5 (20 points)

You and your classmate are trying to determine the expected payoff of the following game:
- Flip a coin (which has probability $p$ of heads) 10 times;
- If 3 consecutive heads occur one or more times, pay 1 dollar;
- If not, pay nothing.

Your classmate has written the following code, which correctly simulates one realization of this game with a fair coin.

````julia:ex5
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
````

However, you would like to conduct multiple trials to compute the expected payoff, and might want to look at coins which are not fair ($p = 0.5$). To minimize copying-and-pasting code, you decide to turn this script into a function.

#### Problem 5.1 (10 points)

Rewrite the above code in a function which accepts two arguments: the number of trials $N$ and the probability of heads $p$, and returns the expected payoff.

#### Problem 5.2 (10 points)

Use your function to compare the expected payoff after 1000 trials of this game with a fair coin vs. a coin which has a 70% probability of heads.

