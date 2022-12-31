<!--This file was generated, do not modify it.-->
## Overview

### Instructions

This homework consists of two parts:
- Problems 1 and 2 involve writing Julia functions to ensure that you have a good grip on basic Julia syntax.
- Problems 3-6 consist of a series of code snippets for you to interpret and debug. For Problems 3-5, you will be asked to identify relevant error(s) and fix the code. For Problem 6, the code works as intended; your goal is to identify the code's purpose by following its logic.

## Problems (Total: 100 Points)

### Problem 1 (15 points)

This problem involves implementing Newton's method for computing square roots; it was shamelessly copied from MIT's [Introduction to Computational Thinking](https://computationalthinking.mit.edu/Spring21/hw0/).

#### Problem 1.1 (10 points)

Implement the following algorithm in a function `newton_sqrt`:

Given $x > 0$:
1. Take a guess $a$.
2. Divide $x$ by $a$.
3. Update $a$ as the average of $x/a$ and $a$.
4. Repeat until $x/a$ is within a tolerance of $\varepsilon$ from $a$..
5. Return $a \approx \sqrt{x}$.

#### Problem 1.2 (5 points)

Use your `newton_sqrt` function to compute $\sqrt{2}$ to within a tolerance of $\varepsilon = 0.01$

### Problem 2 (25 points)

#### Problem 2.1 (10 points)

Load the `Distributions.jl` package (which is provided in the notebook environment) and sample 100 variables from a normal distribution with mean 1 and standard deviation 5, e.g. $x_i \sim N(1, 5)$.

#### Problem 2.2 (10 points)

Write a function `mean_loop` to compute the mean of this vector $\bar{x}$ using a `for` loop.

#### Problem 2.3 (5 points)

Use broadcasting to subtract the mean $\bar{x}$ from each element of your vector of sampled variables.

### Problem 3 (15 points)

You've been tasked with writing code to identify the minimum value in an array. You cannot use a predefined function. Your colleague suggested the function below, but it does not return the minimum value.

````julia:ex1
function minimum(array)
    min_value = 0 # variable which stores minimum value
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

#### Problem 3.1 (5 points)

Describe the logic error.

#### Problem 3.2 (5 points)

Write a fixed version of the function.

#### Problem 3.3 (5 points)

Use your fixed function to find the minimum value of `array_values`.

### Problem 4 (15 points)

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

#### Problem 4.1 (5 points)

Describe the logic and/or syntax error.

#### Problem 4.2 (5 points)

Write a fixed version of the code.

#### Problem 4.3 (5 points)

Use your fixed code to compute the average grade for the class.

### Problem 5 (15 points)

Your team has collected data on the mileage of different car models. You want to calculate the average mileage per gallon (MPG) for the different cars, but your code produces the same value for all of the vehicles, which makes you suspicious.

````julia:ex3
# function to calculate MPG given a tuple of miles and gallons
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

##### Problem 5.1 (5 points)

Describe the logic error.

#### Problem 5.2 (5 points)

Write a fixed version of the code.

#### Problem 5.3 (5 points)

Use your fixed code to compute the MPGs.

### Problem 6 (15 points)

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

#### Problem 6.1 (5 points)

Explain the purpose of `mystery_function`.

#### Problem 6.2 (10 points)

Add comments to each line of code, explaining what it is doing and why.

