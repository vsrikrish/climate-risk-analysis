# This file was generated, do not modify it.

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

student_grades = [89, 90, 95, 100, 100, 78, 99, 98, 100, 95]
function class_average(grades)
  average_grade = mean(student_grades)
  return average_grade
end

try #hide
@show average_grade;
catch err; showerror(stderr, err); end  #hide

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

