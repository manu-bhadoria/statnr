use dep::std;
use dep::float::{Float, addFloats, mulFloats, divFloats, subFloats, truncate};
use dep::std::option::Option;

// Calculating mean (u64)
pub fn mean(numbers: [u64; 5]) -> u64 {
    let mut sum: u64 = 0;
    for i in 0..5 {
        sum += numbers[i];
    }
    sum / 5
}

// Calculating mean (floats)
pub fn mean_floats(numbers: [Float; 5]) -> Float {
    let zero = Float { sign: 0, mantissa: 0, exponent: 100 };
    let mut sum = zero;

    for i in 0..5 {
        sum = addFloats(sum, numbers[i]);
    }

    let count = Float { sign: 0, mantissa: 5, exponent: 100 };
    let mean = divFloats(sum, count);

    mean
}

// Calculating median
pub fn median(mut numbers: [Field; 5]) -> u64 {
    for i in 0..5 {
        for j in 0..5 - i - 1 {
            if (numbers[j] as u64) > (numbers[j + 1] as u64) {
                let temp = numbers[j];
                numbers[j] = numbers[j + 1];
                numbers[j + 1] = temp;
            }
        }
    }

    let len = 5 as u64; 
    if len % 2 == 0 {
        let middle1 = numbers[(len / 2 - 1)] as u64;
        let middle2 = numbers[(len / 2)] as u64;
        (middle1 + middle2) / 2
    } else {
        numbers[(len / 2)] as u64
    }
}

// Function to compare two Floats and check if the first is less than the second
fn is_less_than(x: Float, y: Float) -> bool {
    let sign_diff = x.sign as u64 != y.sign as u64;
    let x_is_less_sign = x.sign as u64 > y.sign as u64;


    let exp_diff = x.exponent as u64 != y.exponent as u64;
    let x_is_less_exp = x.exponent as u64 < y.exponent as u64;

    let mant_diff = x.mantissa as u64 != y.mantissa as u64;
    let x_is_less_mant = x.mantissa as u64 < y.mantissa as u64;

    let sign_condition = (sign_diff & x_is_less_sign) | (sign_diff == false & (exp_diff & x_is_less_exp));
    let mantissa_condition = (sign_diff == false & exp_diff == false & mant_diff & x_is_less_mant);
    sign_condition | mantissa_condition
}

// Function to compare two Floats and check if the first is greater than the second
fn is_greater_than(x: Float, y: Float) -> bool {
    let sign_diff = x.sign as u64 != y.sign as u64;
    let x_is_greater_sign = x.sign as u64 < y.sign as u64;

    let exp_diff = x.exponent as u64 != y.exponent as u64;
    let x_is_greater_exp = x.exponent as u64 > y.exponent as u64;

    let mant_diff = x.mantissa as u64 != y.mantissa as u64;
    let x_is_greater_mant = x.mantissa as u64 > y.mantissa as u64;

    let sign_condition = (sign_diff & x_is_greater_sign) | (sign_diff == false & (exp_diff & x_is_greater_exp));
    let mantissa_condition = (sign_diff == false & exp_diff == false & mant_diff & x_is_greater_mant);
    sign_condition | mantissa_condition
}

// is_less_than_floats
fn is_less_than_floats(x: Float, y: Float) -> bool {
    let x_sign = x.sign as u64;
    let y_sign = y.sign as u64;
    let x_exponent = x.exponent as u64;
    let y_exponent = y.exponent as u64;
    let x_mantissa = x.mantissa as u64;
    let y_mantissa = y.mantissa as u64;

    if x_sign != y_sign {
        x_sign > y_sign
    } else if x_exponent != y_exponent {
        x_exponent < y_exponent
    } else {
        x_mantissa < y_mantissa
    }
}
// is_greater_than_floats

fn is_greater_than_floats(x: Float, y: Float) -> bool {
    let x_sign = x.sign as u64;
    let y_sign = y.sign as u64;
    let x_exponent = x.exponent as u64;
    let y_exponent = y.exponent as u64;
    let x_mantissa = x.mantissa as u64;
    let y_mantissa = y.mantissa as u64;

    if x_sign != y_sign {
        x_sign < y_sign
    } else if x_exponent != y_exponent {
        x_exponent > y_exponent
    } else {
        x_mantissa > y_mantissa
    }
}



// Function to find the minimum value in an array of Floats
pub fn find_min_float(numbers: [Float; 10]) -> Float {
    let mut min = numbers[0];
    for i in 1..10 {
        if is_less_than_floats(numbers[i], min) {
            min = numbers[i];
        }
    }
    min
}

// Function to find the maximum value in an array of Floats
pub fn find_max_float(numbers: [Float; 10]) -> Float {
    let mut max = numbers[0];
    for i in 1..10 {
        if is_greater_than_floats(numbers[i], max) {
            max = numbers[i];
        }
    }
    max
}

// Calculate the median of an array of Floats
pub fn median_floats(mut numbers: [Float; 6]) -> Float {
    for i in 0..6 {
        for j in 0..5 - i {
            if is_less_than_floats(numbers[j + 1], numbers[j]) {
                let temp = numbers[j];
                numbers[j] = numbers[j + 1];
                numbers[j + 1] = temp;
            }
        }
    }
    let len = 6; 
    let is_even_len = len % 2 as u64 == 0;
    let middle_index = len / 2; 

    
    let middle1 = numbers[middle_index - 1]; 
    let middle2 = numbers[middle_index];
    if is_even_len {
        // If the length is even, take the average of the two middle elements
        divFloats(addFloats(middle1, middle2), Float { sign: 0, mantissa: 2, exponent: 100 })
    } else {
        // If the length is odd, return the middle element
        numbers[middle_index]
    }
}

// Calculate the mode of an array of numbers
pub fn mode(numbers: [u64; 5]) -> u64 {
    let mut max_count: u64 = 0;
    let mut mode_value: u64 = 0;

    for i in 0..5 {
        let mut count: u64 = 0;

        for j in 0..5 {
            if numbers[i] == numbers[j] {
                count += 1;
            }
        }

        if count > max_count {
            max_count = count;
            mode_value = numbers[i];
        }
    }

    if max_count > 1 {
        mode_value
    } else {
        // 0 to indicate no mode found
        0
    }
}

// Check if two Floats are equal
fn are_floats_equal(x: Float, y: Float) -> bool {
    (x.sign as u64 == y.sign as u64) &
    (x.exponent as u64 == y.exponent as u64) &
    (x.mantissa as u64 == y.mantissa as u64)
}

// Calculate the mode of an array of Floats
pub fn mode_floats(numbers: [Float; 5]) -> Float {
    let mut max_count: u64 = 0;
    let mut mode_value: Float = Float { sign: 0, mantissa: 0, exponent: 0 }; 

    for i in 0..5 {
        let mut count: u64 = 0;

        for j in 0..5 {
            if are_floats_equal(numbers[i], numbers[j]) {
                count += 1;
            }
        }

        if count > max_count {
            max_count = count;
            mode_value = numbers[i];
        }
    }

    if max_count > 1 {
        mode_value
    } else {
        Float { sign: 1, mantissa: 0, exponent: 0 }
    }
}

// Generate a range of u64 numbers
fn generate_range(start: u64, end: u64, result: [u64; 10], index: u64) -> [u64; 10] {
    let updated_result = if index < 10 & start < end {
        let mut updated = result;
        updated[index] = start;
        updated
    } else {
        result
    };

    let next_index = index + 1;
    let next_start = if start < end { start + 1 } else { start };

    if index < 9 {
        generate_range(next_start, end, updated_result, next_index)
    } else {
        updated_result
    }
}

// Generate a range of u64 numbers
fn range(start: u64, end: u64) -> [u64; 10] {
    let initial_result: [u64; 10] = [0; 10];
    generate_range(start, end, initial_result, 0)
}

// Generate a range of Float numbers
fn generate_range_floats(start: Float, end: Float, step: Float) -> [Float; 10] {
    let mut result: [Float; 10] = [Float { sign: 0, mantissa: 0, exponent: 0 }; 10];
    let mut current = start;
    let mut range_filled = false;

    for i in 0..10 {
        if is_less_than_floats(current, end) & !range_filled {
            result[i] = current;
            current = addFloats(current, step); 
        } else {
            range_filled = true;
            result[i] = Float { sign: 0, mantissa: 0, exponent: 0 };
        }
    }

    result
}


// Calculate the range (difference between the maximum and minimum) of an array of u64 numbers
pub fn calculate_range(numbers: [u64; 10]) -> u64 {
    let mut min = numbers[0];
    let mut max = numbers[0];

    for i in 1..10 {
        if numbers[i] < min {
            min = numbers[i];
        }
        if numbers[i] > max {
            max = numbers[i];
        }
    }

    max - min
}

// Calculate the range (difference between the maximum and minimum) of an array of Floats
pub fn calculate_range_floats(numbers: [Float; 10]) -> Float {
    let min = find_min_float(numbers);    
    let max = find_max_float(numbers);

    subFloats(max, min)
}

// Integer square root approximation
fn isqrt(n: u64) -> u64 {
    if n <= 1 {
        n
    } else {
        let mut xk = n;
        let mut xk1 = (xk + n / xk) / 2;

        for _ in 0..5 {
            xk = xk1;
            xk1 = (xk + n / xk) / 2;
        }

        xk
    }
}

// Function to approximate the log base 2
fn log2_approximation(value: u64) -> u64 {
    let mut count = 0;
    let mut temp = value;
    for _ in 0..64 { 
        if temp <= 1 {
            count = temp; 
        }
        temp /= 2;
        count += 1;
    }
    count 
}

// Iterative method to approximate square root
fn sqrt_approximation(value: u64) -> u64 {
    let mut guess = if value > 0 { value / 2 } else { 0 };
    let mut next_guess = (guess + value / guess) / 2;

    for _ in 0..10 {
        if next_guess >= guess {
            guess = next_guess; 
        } else {
            guess = next_guess;
            next_guess = (guess + value / guess) / 2;
        }
    }

    guess
}

// Calculate the square root of a Float
fn sqrt_float(x: Float) -> Float {
    let mut result = Float { sign: 0, mantissa: 0, exponent: 100 }; 
    let is_negative_or_zero = (x.sign as u64 != 0) | (x.mantissa as u64 == 0);

    if !is_negative_or_zero {
        let initial_guess_exponent = x.exponent / 2;
        let initial_guess_mantissa = sqrt_approximation(x.mantissa as u64) as Field;
        let mut guess = Float { sign: 0, mantissa: initial_guess_mantissa, exponent: initial_guess_exponent };

        for _ in 0..10 {
            let div_result = divFloats(x, guess);
            let sum_result = addFloats(guess, div_result);
            guess = divFloats(sum_result, Float { sign: 0, mantissa: 2, exponent: 100 });
            guess = truncate(guess); 
        }
        result = guess; 
    }

    result 
}

// Calculate the variance of a u64 set
pub fn variance(numbers: [u64; 5]) -> u64 {
    let mut sum = 0 as u64;
    let mut sum_of_squares = 0 as u64;

    for i in 0..5 {
        sum = sum + numbers[i];
        sum_of_squares = sum_of_squares + numbers[i] * numbers[i]; 
    }

    let mean = sum / 5;
    let mean_of_squares = sum_of_squares / 5;
    let square_of_mean = mean * mean;
    let variance = if mean_of_squares > square_of_mean {
        mean_of_squares - square_of_mean
    } else {
        0 
    };

    variance
}

// Calculate the standard deviation of a u64 set
pub fn standard_deviation(numbers: [u64; 5]) -> u64 {
    let variance_value = variance(numbers);
    isqrt(variance_value) 
}


// Calculate the Q1 (25th percentile) quartile of a sorted dataset
fn quartile_q1(sorted_data: [u64; 10]) -> u64 {
    let n: u64 = 10; 
    let percentile: u64 = 25;
    let index = ((n + 1) * percentile) / 100; 
    let mut q1_value: u64 = 0;
    let mut found = false; // 

    for i in 0..n {
        if i == index {
            q1_value = sorted_data[i];
            found = true; 
        }
        if found {
        }
    }

    q1_value
}

// Calculate the Q2 quartile of a sorted dataset
fn quartile_q2(sorted_data: [u64; 10]) -> u64 {
    let n: u64 = 10;

    let middle1_index = n / 2 - 1;
    let middle2_index = n / 2;

    let middle1 = sorted_data[middle1_index];
    let middle2 = sorted_data[middle2_index];

    (middle1 + middle2) / 2
}

// Calculate the Q3 quartile of a sorted dataset
fn quartile_q3(sorted_data: [u64; 10]) -> u64 {
    let lower_index = 7; 
    let upper_index = 8; 
    let lower = sorted_data[lower_index];
    let upper = sorted_data[upper_index];

    
    ((lower + upper) / 2)
}


// Calculate the IQR for a sorted dataset
fn interquartile_range(data: [u64; 10]) -> u64 {
    let sorted_data = sort_data(data); 
    let q1 = quartile_q1(sorted_data);
    let q3 = quartile_q3(sorted_data);

    let iqr = q3 - q1;
    iqr
}

// Sort u64 dataset
fn sort_data(data: [u64; 10]) -> [u64; 10] {
    let mut sorted_data = data;
    let n = sorted_data.len() as u64;

    for i in 0..n - 1 {
        for j in 0..n - i - 1 {
            if sorted_data[j] > sorted_data[j + 1] {
                let temp = sorted_data[j];
                sorted_data[j] = sorted_data[j + 1];
                sorted_data[j + 1] = temp;
            }
        }
    }

    sorted_data
}

// Function to find the minimum value in an array
fn find_min(data: [u64; 10]) -> u64 {
    let mut min_value = data[0]; 

    for i in 0..10 {
        if data[i] < min_value {
            min_value = data[i]; 
        }
    }

    min_value
}

// Function to find the maximum value in an array
fn find_max(data: [u64; 10]) -> u64 {
    let mut max_value = data[0];

    for i in 0..10 {
        if data[i] > max_value {
            max_value = data[i]; 
        }
    }

    max_value
}

// Function for Linear Regression for u64
fn linear_regression(data: [(u64, u64); 10]) -> (u64, u64) {
    let n = data.len() as u64;
    let mut sum_x = 0;
    let mut sum_y = 0;
    let mut sum_xy = 0;
    let mut sum_x2 = 0;

    for i in 0..n {
        sum_x += data[i].0;
        sum_y += data[i].1;
        sum_xy += data[i].0 * data[i].1;
        sum_x2 += data[i].0 * data[i].0;
    }

    // Calculate slope (m) and y-intercept (b) for y = mx + b
    let m = (n * sum_xy - sum_x * sum_y) / (n * sum_x2 - sum_x * sum_x);
    let b = (sum_y - m * sum_x) / n;

    (m, b)
}

// Function for Linear Regression for floats
fn linear_regression_float(x_values: [Float; 5], y_values: [Float; 5]) -> (Float, Float) {
    let n = Float { sign: 0, mantissa: 5, exponent: 100 };

    let mut sum_x = x_values[0];
    let mut sum_y = y_values[0];
    let mut sum_xy = mulFloats(x_values[0], y_values[0]);
    let mut sum_x_square = mulFloats(x_values[0], x_values[0]);

    // Summation logic
    for i in 1..5 {
        sum_x = addFloats(sum_x, x_values[i]);
        sum_y = addFloats(sum_y, y_values[i]);
        sum_xy = addFloats(sum_xy, mulFloats(x_values[i], y_values[i]));
        sum_x_square = addFloats(sum_x_square, mulFloats(x_values[i], x_values[i]));
    }

    // Calculating slope (m) = [N * Σ(xy) - Σx * Σy] / [N * Σ(x^2) - (Σx)^2]
    let numerator_m = subFloats(mulFloats(n, sum_xy), mulFloats(sum_x, sum_y));
    let denominator_m = subFloats(mulFloats(n, sum_x_square), mulFloats(sum_x, sum_x));
    let slope = divFloats(numerator_m, denominator_m);

    // Calculating intercept (b) = [Σy - m * Σx] / N
    let numerator_b = subFloats(sum_y, mulFloats(slope, sum_x));
    let intercept = divFloats(numerator_b, n);

    (slope, intercept)
}

// Function for logistic regression for u64
fn logistic_regression(data: [(u64, u64); 10]) -> u64 {
    let n = data.len() as u64;
    let mut sum_y = 0;

    for i in 0..n {
        sum_y += data[i].1;
    }

    sum_y / n
}



fn main() {
    // Test: Mean with uniform values
    {
        let numbers: [u64; 5] = [10, 10, 10, 10, 10];
        let result = mean(numbers);
        assert(result == 10);
    }

    // Test: Mean with zero values
    {
        let numbers: [u64; 5] = [0, 0, 0, 0, 0];
        let result = mean(numbers);
        assert(result == 0);
    }

    // Test: Mean with mixed values
    {
        let numbers: [u64; 5] = [1, 2, 3, 4, 5];
        let result = mean(numbers);
        assert(result == 3);
    }

    // Test: Mean with uniform float values
    {
        let float_array = [Float { sign: 0, mantissa: 10000, exponent: 100 }; 5];
        let result = mean_floats(float_array);
        assert(result.mantissa == 10000);
    }

    // Test: Mean with varying float values
    {
        let float_array = [
            Float { sign: 0, mantissa: 10000, exponent: 100 },
            Float { sign: 0, mantissa: 20000, exponent: 100 },
            Float { sign: 0, mantissa: 30000, exponent: 100 },
            Float { sign: 0, mantissa: 40000, exponent: 100 },
            Float { sign: 0, mantissa: 50000, exponent: 100 },
        ];
        let result = mean_floats(float_array);
        assert(result.mantissa == 30000);

    }

    // Test: Mean with varying float values
    {
        let varying_floats = [
            Float { sign: 0, mantissa: 10000, exponent: 100 },
            Float { sign: 0, mantissa: 20000, exponent: 100 },
            Float { sign: 0, mantissa: 30000, exponent: 100 },
            Float { sign: 0, mantissa: 40000, exponent: 100 },
            Float { sign: 0, mantissa: 50000, exponent: 100 },
        ];
        let result = mean_floats(varying_floats);
        assert(result.mantissa == 30000);
    }

    // Test: Mean with negative and positive float values
    {
        let mixed_signs = [
            Float { sign: 1, mantissa: 10000, exponent: 100 }, 
            Float { sign: 0, mantissa: 20000, exponent: 100 }, 
            Float { sign: 0, mantissa: 30000, exponent: 100 }, 
            Float { sign: 1, mantissa: 40000, exponent: 100 }, 
            Float { sign: 0, mantissa: 50000, exponent: 100 }, 
        ];
        let result = mean_floats(mixed_signs);
        assert(result.mantissa == 10000);
    }

    // Test: Mean with all zeroes
    {
        let all_zeroes = [Float { sign: 0, mantissa: 0, exponent: 100 }; 5];
        let result = mean_floats(all_zeroes);
        assert(result.mantissa == 0);
    }

    // Test: Median with uniform values
    {
        let numbers: [Field; 5] = [10, 10, 10, 10, 10];
        let result = median(numbers);
        assert(result == 10);
    }

    // Test: Median with zero values
    {
        let numbers: [Field; 5] = [0, 0, 0, 0, 0];
        let result = median(numbers);
        assert(result == 0);
    }

    // Test: Median with mixed values
    {
        let numbers: [Field; 5] = [1, 2, 3, 4, 5];
        let result = median(numbers);
        assert(result == 3);
    }

    // Test: Median with mixed values and unsorted array
    {
        let numbers: [Field; 5] = [5, 3, 1, 4, 2];
        let result = median(numbers);
        assert(result == 3);
    }

    // Test: Comparing two positive Floats with different mantissas (IS_LESS_THAN)
    {
        let x = Float { sign: 0, mantissa: 10000, exponent: 100 };
        let y = Float { sign: 0, mantissa: 20000, exponent: 100 };
        let result = is_less_than(x, y);
        assert(result == true);
    }

    // Test: Comparing two Floats with different signs
    {
        let x = Float { sign: 1, mantissa: 10000, exponent: 100 };
        let y = Float { sign: 0, mantissa: 10000, exponent: 100 };
        let result = is_less_than(x, y);
        assert(result == true);
    }

    // Test: Comparing two Floats with different exponents
    {
        let x = Float { sign: 0, mantissa: 10000, exponent: 99 };
        let y = Float { sign: 0, mantissa: 10000, exponent: 100 };
        let result = is_less_than(x, y);
        assert(result == true);
    }

    // Test: Comparing two positive Floats with different mantissas (IS_GREATER_THAN)
    {
        let x = Float { sign: 0, mantissa: 20000, exponent: 100 };
        let y = Float { sign: 0, mantissa: 10000, exponent: 100 };
        let result = is_greater_than(x, y);
        assert(result == true);
    }

    // Test: Comparing two Floats with different signs
    {
        let x = Float { sign: 0, mantissa: 10000, exponent: 100 };
        let y = Float { sign: 1, mantissa: 10000, exponent: 100 };
        let result = is_greater_than(x, y);
        assert(result == true);
    }

    // Test: Comparing two Floats with different exponents
    {
        let x = Float { sign: 0, mantissa: 10000, exponent: 101 };
        let y = Float { sign: 0, mantissa: 10000, exponent: 100 };
        let result = is_greater_than(x, y);
        assert(result == true);
    }
    // Test: Find minimum with uniform float values
    {
        let float_array = [Float { sign: 0, mantissa: 10000, exponent: 100 }; 10];
        let result = find_min_float(float_array);
        assert(result.mantissa == 10000);
    }

    // Test: Find minimum with varying float values
    {
        let float_array = [
            Float { sign: 0, mantissa: 50000, exponent: 100 },
            Float { sign: 0, mantissa: 40000, exponent: 100 },
            Float { sign: 0, mantissa: 30000, exponent: 100 },
            Float { sign: 0, mantissa: 20000, exponent: 100 },
            Float { sign: 0, mantissa: 10000, exponent: 100 },
            Float { sign: 0, mantissa: 60000, exponent: 100 },
            Float { sign: 0, mantissa: 70000, exponent: 100 },
            Float { sign: 0, mantissa: 80000, exponent: 100 },
            Float { sign: 0, mantissa: 90000, exponent: 100 },
            Float { sign: 0, mantissa: 100000, exponent: 100 },
        ];
        let result = find_min_float(float_array);
        assert(result.mantissa == 10000);
    }

    // Test: Find minimum with varying float values
    {
        let float_array = [
            Float { sign: 0, mantissa: 10000, exponent: 20 }, 
            Float { sign: 0, mantissa: 20000, exponent: 100 }, 
            Float { sign: 0, mantissa: 30000, exponent: 100 }, 
            Float { sign: 0, mantissa: 40000, exponent: 10 }, 
            Float { sign: 0, mantissa: 50000, exponent: 100 }, 
            Float { sign: 0, mantissa: 60000, exponent: 10 }, 
            Float { sign: 0, mantissa: 70000, exponent: 100 }, 
            Float { sign: 0, mantissa: 80000, exponent: 100 }, 
            Float { sign: 0, mantissa: 90000, exponent: 200 }, 
            Float { sign: 0, mantissa: 100000, exponent: 100 },
        ];
        let result = find_min_float(float_array);
        assert(result.mantissa == 40000);
        assert(result.exponent == 10);

    }

    // Test: Find minimum with all zeroes
    {
        let float_array = [Float { sign: 0, mantissa: 0, exponent: 100 }; 10];
        let result = find_min_float(float_array);
        assert(result.mantissa == 0);
    }

    // Test: Find maximum with uniform float values
    {
        let float_array = [Float { sign: 0, mantissa: 10000, exponent: 100 }; 10];
        let result = find_max_float(float_array);
        assert(result.mantissa == 10000);
    }

    // Test: Find maximum with varying float values
    {
        let float_array = [
            Float { sign: 0, mantissa: 10000, exponent: 100 },
            Float { sign: 0, mantissa: 20000, exponent: 100 },
            Float { sign: 0, mantissa: 30000, exponent: 100 },
            Float { sign: 0, mantissa: 40000, exponent: 100 },
            Float { sign: 0, mantissa: 50000, exponent: 100 },
            Float { sign: 0, mantissa: 60000, exponent: 100 },
            Float { sign: 0, mantissa: 70000, exponent: 100 },
            Float { sign: 0, mantissa: 80000, exponent: 100 },
            Float { sign: 0, mantissa: 90000, exponent: 100 },
            Float { sign: 0, mantissa: 100000, exponent: 100 },
        ];
        let result = find_max_float(float_array);
        assert(result.mantissa == 100000);
    }

    // Test: Find maximum with varying float values and different exponents
    {
        let float_array = [
            Float { sign: 0, mantissa: 10000, exponent: 20 }, 
            Float { sign: 0, mantissa: 20000, exponent: 100 },
            Float { sign: 0, mantissa: 30000, exponent: 100 },
            Float { sign: 0, mantissa: 40000, exponent: 10 },
            Float { sign: 0, mantissa: 50000, exponent: 100 },
            Float { sign: 0, mantissa: 60000, exponent: 10 },
            Float { sign: 0, mantissa: 70000, exponent: 100 },
            Float { sign: 0, mantissa: 80000, exponent: 100 },
            Float { sign: 0, mantissa: 90000, exponent: 200 },
            Float { sign: 0, mantissa: 100000, exponent: 100 },
        ];
        let result = find_max_float(float_array);
        assert(result.mantissa == 90000);
        assert(result.exponent == 200);

    }

    // Test: Find maximum with all zeroes
    {
        let float_array = [Float { sign: 0, mantissa: 0, exponent: 100 }; 10];
        let result = find_max_float(float_array);
        assert(result.mantissa == 0);
    }

    // Test: Median with uniform float values
    {
        let float_array = [Float { sign: 0, mantissa: 10000, exponent: 100 }; 6];
        let result = median_floats(float_array);
        assert(result.mantissa == 10000);
    }

    // Test: Median with varying float values
    {
        let float_array = [
            Float { sign: 0, mantissa: 10000, exponent: 100 },
            Float { sign: 0, mantissa: 20000, exponent: 100 },
            Float { sign: 0, mantissa: 30000, exponent: 100 },
            Float { sign: 0, mantissa: 40000, exponent: 100 },
            Float { sign: 0, mantissa: 50000, exponent: 100 },
            Float { sign: 0, mantissa: 60000, exponent: 100 },
        ];
        let result = median_floats(float_array);
        assert(result.mantissa == 35000);
    }

    // Test: Median with varying float values (unsorted)
    {
        let float_array = [
            Float { sign: 0, mantissa: 60000, exponent: 100 },
            Float { sign: 0, mantissa: 10000, exponent: 100 },
            Float { sign: 0, mantissa: 50000, exponent: 100 },
            Float { sign: 0, mantissa: 20000, exponent: 100 },
            Float { sign: 0, mantissa: 40000, exponent: 100 },
            Float { sign: 0, mantissa: 30000, exponent: 100 },
        ];
        let result = median_floats(float_array);
        assert(result.mantissa == 35000);
    }

    // Test: Median with negative and positive float values
    {
        let float_array = [
            Float { sign: 1, mantissa: 10000, exponent: 100 }, // -10000
            Float { sign: 0, mantissa: 20000, exponent: 100 }, // +20000
            Float { sign: 0, mantissa: 30000, exponent: 100 }, // +30000
            Float { sign: 1, mantissa: 40000, exponent: 100 }, // -40000
            Float { sign: 0, mantissa: 50000, exponent: 100 }, // +50000
            Float { sign: 0, mantissa: 60000, exponent: 100 }, // +60000
        ];
        let result = median_floats(float_array);
        assert(result.mantissa == 25000);
    }

    // Test: Median with all zeroes
    {
        let float_array = [Float { sign: 0, mantissa: 0, exponent: 100 }; 6];
        let result = median_floats(float_array);
        assert(result.mantissa == 0);
    }

    // Test: Mode with a clear mode
    {
        let numbers: [u64; 5] = [1, 2, 2, 3, 4];
        let result = mode(numbers);
        assert(result == 2);
    }

    // Test: Mode with no mode (all unique values)
    {
        let numbers: [u64; 5] = [1, 2, 3, 4, 5];
        let result = mode(numbers);
        assert(result == 0);
    }

    // Test: Mode with all elements the same
    {
        let numbers: [u64; 5] = [5, 5, 5, 5, 5];
        let result = mode(numbers);
        assert(result == 5);
    }

    // Test: Mode with multiple modes (return the first one encountered)
    {
        let numbers: [u64; 5] = [1, 1, 2, 2, 3];
        let result = mode(numbers);
        assert(result == 1);
    }

    // Test: Equal Floats (same sign, exponent, and mantissa)
    {
        let x = Float { sign: 0, mantissa: 10000, exponent: 100 };
        let y = Float { sign: 0, mantissa: 10000, exponent: 100 };
        let result = are_floats_equal(x, y);
        assert(result);
    }

    // Test: Different signs
    {
        let x = Float { sign: 1, mantissa: 10000, exponent: 100 };
        let y = Float { sign: 0, mantissa: 10000, exponent: 100 };
        let result = are_floats_equal(x, y);
        assert(!result);
    }

    // Test: Different exponents
    {
        let x = Float { sign: 0, mantissa: 10000, exponent: 100 };
        let y = Float { sign: 0, mantissa: 10000, exponent: 99 };
        let result = are_floats_equal(x, y);
        assert(!result);
    }

    // Test: Different mantissas
    {
        let x = Float { sign: 0, mantissa: 10000, exponent: 100 };
        let y = Float { sign: 0, mantissa: 20000, exponent: 100 };
        let result = are_floats_equal(x, y);
        assert(!result);
    }

    // Test: All fields different
    {
        let x = Float { sign: 0, mantissa: 10000, exponent: 100 };
        let y = Float { sign: 1, mantissa: 20000, exponent: 99 };
        let result = are_floats_equal(x, y);
        assert(!result);
    }

    // Test: Mode with a clear mode
    {
        let float_array = [
            Float { sign: 0, mantissa: 10000, exponent: 100 },
            Float { sign: 0, mantissa: 20000, exponent: 100 },
            Float { sign: 0, mantissa: 10000, exponent: 100 },
            Float { sign: 0, mantissa: 30000, exponent: 100 },
            Float { sign: 0, mantissa: 10000, exponent: 100 },
        ];
        let result = mode_floats(float_array);
        assert(are_floats_equal(result, Float { sign: 0, mantissa: 10000, exponent: 100 }));
    }

    // Test: Mode with no mode (all unique values)
    {
        let float_array = [
            Float { sign: 0, mantissa: 10000, exponent: 100 },
            Float { sign: 0, mantissa: 20000, exponent: 100 },
            Float { sign: 0, mantissa: 30000, exponent: 100 },
            Float { sign: 0, mantissa: 40000, exponent: 100 },
            Float { sign: 0, mantissa: 50000, exponent: 100 },
        ];
        let result = mode_floats(float_array);
        assert(are_floats_equal(result, Float { sign: 1, mantissa: 0, exponent: 0 }));
    }

    // Test: Mode with multiple modes (return the first one encountered)
    {
        let float_array = [
            Float { sign: 0, mantissa: 10000, exponent: 100 },
            Float { sign: 0, mantissa: 20000, exponent: 100 },
            Float { sign: 0, mantissa: 10000, exponent: 100 },
            Float { sign: 0, mantissa: 20000, exponent: 100 },
            Float { sign: 0, mantissa: 30000, exponent: 100 },
        ];
        let result = mode_floats(float_array);
        assert(are_floats_equal(result, Float { sign: 0, mantissa: 10000, exponent: 100 }));
    }

    // Test: Mode with all elements the same
    {
        let float_array = [Float { sign: 0, mantissa: 10000, exponent: 100 }; 5];
        let result = mode_floats(float_array);
        assert(are_floats_equal(result, Float { sign: 0, mantissa: 10000, exponent: 100 }));
    }

    // Test: Generate range within the size limit
    {
        let result = generate_range(1, 5, [0; 10], 0);
        let expected = [1, 2, 3, 4, 0, 0, 0, 0, 0, 0];
        assert(result == expected);
    }

    // Test: Generate range that exceeds the size limit
    {
        let result = generate_range(1, 15, [0; 10], 0);
        let expected = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
        assert(result == expected);
    }

    // Test: Generate range with start greater than end
    {
        let result = generate_range(10, 5, [0; 10], 0);
        let expected = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
        assert(result == expected);
    }

    // Test: Generate empty range
    {
        let result = generate_range(5, 5, [0; 10], 10);
        let expected = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
        assert(result == expected);
    }
  
    // Test: Generate range with positive step
    {
        let start = Float { sign: 0, mantissa: 10000, exponent: 100 };
        let end = Float { sign: 0, mantissa: 60000, exponent: 100 };
        let step = Float { sign: 0, mantissa: 10000, exponent: 100 };

        let result = generate_range_floats(start, end, step);
        let expected = [
            Float { sign: 0, mantissa: 10000, exponent: 100 },
            Float { sign: 0, mantissa: 20000, exponent: 100 },
            Float { sign: 0, mantissa: 30000, exponent: 100 },
            Float { sign: 0, mantissa: 40000, exponent: 100 },
            Float { sign: 0, mantissa: 50000, exponent: 100 },
            Float { sign: 0, mantissa: 0, exponent: 0 },
            Float { sign: 0, mantissa: 0, exponent: 0 }, 
            Float { sign: 0, mantissa: 0, exponent: 0 },
            Float { sign: 0, mantissa: 0, exponent: 0 },
            Float { sign: 0, mantissa: 0, exponent: 0 },
        ];
        
        for i in 0..10 {
            assert(are_floats_equal(result[i], expected[i]));
        }
    }



    // Test: Generate range where end is reached before filling array
    {
        let start = Float { sign: 0, mantissa: 10000, exponent: 100 };
        let end = Float { sign: 0, mantissa: 30000, exponent: 100 };
        let step = Float { sign: 0, mantissa: 10000, exponent: 100 };

        let result = generate_range_floats(start, end, step);
        let expected = [
            Float { sign: 0, mantissa: 10000, exponent: 100 },
            Float { sign: 0, mantissa: 20000, exponent: 100 },
            Float { sign: 0, mantissa: 0, exponent: 0 },
            Float { sign: 0, mantissa: 0, exponent: 0 }, 
            Float { sign: 0, mantissa: 0, exponent: 0 },
            Float { sign: 0, mantissa: 0, exponent: 0 },
            Float { sign: 0, mantissa: 0, exponent: 0 },
            Float { sign: 0, mantissa: 0, exponent: 0 },
            Float { sign: 0, mantissa: 0, exponent: 0 },
            Float { sign: 0, mantissa: 0, exponent: 0 },
        ];

        for i in 0..10 {
            assert(are_floats_equal(result[i], expected[i]));
        }
    }

    // Test: Normal range within 10 elements
    {
        let result = range(1, 6);
        let expected = [1, 2, 3, 4, 5, 0, 0, 0, 0, 0];
        assert(result == expected);
    }

    // Test: Start is greater than end
    {
        let result = range(5, 3);
        let expected = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
        assert(result == expected);
    }

    // Test: Range exceeds 10 elements
    {
        let result = range(1, 15);
        let expected = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
        assert(result == expected);
    }

    // Test: Normal case with mixed values
    {
        let numbers: [u64; 10] = [10, 2, 30, 4, 50, 6, 70, 8, 90, 1];
        let result = calculate_range(numbers);
        assert(result == 89);
    }

    // Test: All values are the same
    {
        let numbers: [u64; 10] = [20, 20, 20, 20, 20, 20, 20, 20, 20, 20];
        let result = calculate_range(numbers);
        assert(result == 0);
    }

    // Test: Increasing values
    {
        let numbers: [u64; 10] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
        let result = calculate_range(numbers);
        assert(result == 9);
    }

    // Test: Single non-zero value
    {
        let numbers: [u64; 10] = [0, 0, 0, 0, 0, 50, 0, 0, 0, 0];
        let result = calculate_range(numbers);
        assert(result == 50);
    }

    // Test: Normal case with mixed positive and negative values
    {
        let numbers = [
            Float { sign: 0, mantissa: 10000, exponent: 100 },
            Float { sign: 0, mantissa: 20000, exponent: 100 }, 
            Float { sign: 0, mantissa: 30000, exponent: 100 },
            Float { sign: 0, mantissa: 40000, exponent: 100 }, 
            Float { sign: 0, mantissa: 50000, exponent: 100 }, 
            Float { sign: 0, mantissa: 60000, exponent: 100 }, 
            Float { sign: 0, mantissa: 70000, exponent: 100 }, 
            Float { sign: 0, mantissa: 80000, exponent: 100 },
            Float { sign: 0, mantissa: 90000, exponent: 100 }, 
            Float { sign: 0, mantissa: 100000, exponent: 100 }, 
        ];
        let result = calculate_range_floats(numbers);
        let expected = Float { sign: 0, mantissa: 90000, exponent: 100 };
        assert(are_floats_equal(result, expected));
    }

    // Test: All values are the same
    {
        let numbers = [Float { sign: 0, mantissa: 20000, exponent: 100 }; 10];
        let result = calculate_range_floats(numbers);
        let expected = Float { sign: 1, mantissa: 0, exponent: 100 }; 
        assert(are_floats_equal(result, expected));
    }

    // Test: Increasing values
    {
        let numbers = [
            Float { sign: 0, mantissa: 10000, exponent: 100 },
            Float { sign: 0, mantissa: 20000, exponent: 100 },
            Float { sign: 0, mantissa: 30000, exponent: 100 },
            Float { sign: 0, mantissa: 40000, exponent: 100 },
            Float { sign: 0, mantissa: 50000, exponent: 100 },
            Float { sign: 0, mantissa: 60000, exponent: 100 },
            Float { sign: 0, mantissa: 70000, exponent: 100 },
            Float { sign: 0, mantissa: 80000, exponent: 100 },
            Float { sign: 0, mantissa: 90000, exponent: 100 },
            Float { sign: 0, mantissa: 100000, exponent: 100 },
        ];
        let result = calculate_range_floats(numbers);
        let expected = Float { sign: 0, mantissa: 90000, exponent: 100 }; 
        assert(are_floats_equal(result, expected));
    }

    // Test: Square root of a perfect square
    {
        let result = isqrt(16);
        assert(result == 4);
    }

    // Test: Square root of a non-perfect square
    {
        let result = isqrt(20);
        assert(result == 4);
    }

    // Test: Square root of 0
    {
        let result = isqrt(0);
        assert(result == 0);
    }

    // Test: Square root of 1
    {
        let result = isqrt(1);
        assert(result == 1);
    }

    // Test: Calculate variance for uniform values
    {
        let numbers: [u64; 5] = [10, 10, 10, 10, 10];
        let result = variance(numbers);
        assert(result == 0);
    }

    // Test: Calculate variance for distinct values
    {
        let numbers: [u64; 5] = [1, 2, 3, 4, 5];
        let result = variance(numbers);
        let expected_variance = 2; 
        assert(result == expected_variance);
    }

    // Test: Calculate variance for all zeros
    {
        let numbers: [u64; 5] = [0, 0, 0, 0, 0];
        let result = variance(numbers);
        assert(result == 0);
    }
    // Test: Calculate standarad deviation for uniform values
    {
        let numbers: [u64; 5] = [10, 10, 10, 10, 10];
        let result = standard_deviation(numbers);
        assert(result == 0);
    }

    // Test: Calculate standarad deviation for distinct values
    {
        let numbers: [u64; 5] = [1, 2, 3, 4, 5];
        let result = standard_deviation(numbers);
        let expected_std_dev = isqrt(2);
        assert(result == expected_std_dev);
    }

    // Test: Calculate standarad deviation for a mix of high and low values
    {
        let numbers: [u64; 5] = [1, 10, 20, 30, 40];
        let result = standard_deviation(numbers);
        let expected_std_dev = 14; 
        assert(result == expected_std_dev);
    }

    // Test: Calculate standarad deviation for all zeros
    {
        let numbers: [u64; 5] = [0, 0, 0, 0, 0];
        let result = standard_deviation(numbers);
        assert(result == 0);
    }
    
    // Test: Calcuate Q1 for distinct, ascending values
    {
        let sorted_data: [u64; 10] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
        let result = quartile_q1(sorted_data);
        let expected = 3; 
        assert(result == expected);
    }

    // Test: Calcuate Q1 for mix of identical and distinct values
    {
        let sorted_data: [u64; 10] = [1, 1, 2, 2, 3, 3, 4, 5, 6, 7];
        let result = quartile_q1(sorted_data);
        let expected = 2; // 25th percentile (Q1) of sorted array
        assert(result == expected);
    }

    // Test: Calcuate Q1 for all zeros
    {
        let sorted_data: [u64; 10] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
        let result = quartile_q1(sorted_data);
        let expected = 0; // 25th percentile (Q1) is 0
        assert(result == expected);
    }

    // Test: Calcuate Q1 for all the same numbers
    {
        let sorted_data: [u64; 10] = [5, 5, 5, 5, 5, 5, 5, 5, 5, 5];
        let result = quartile_q1(sorted_data);
        let expected = 5;
        assert(result == expected);
    }

    // Test: Calcuate Q2 for distinct, ascending values
    {
        let sorted_data: [u64; 10] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
        let result = quartile_q2(sorted_data);
        let expected = (5 + 6) / 2; 
        assert(result == expected);
    }

    // Test: Calcuate Q2 for distinct values in non-ascending order
    {
        let sorted_data: [u64; 10] = [10, 9, 8, 7, 6, 5, 4, 3, 2, 1];
        let result = quartile_q2(sorted_data);
        let expected = (5 + 6) / 2;
        assert(result == expected);
    }

    // Test: Calcuate Q2 for some identical values
    {
        let sorted_data: [u64; 10] = [1, 2, 3, 4, 4, 4, 5, 6, 7, 8];
        let result = quartile_q2(sorted_data);
        let expected = (4 + 4) / 2; 
        assert(result == expected);
    }

    // Test: Calcuate Q2 for all zeros
    {
        let sorted_data: [u64; 10] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
        let result = quartile_q2(sorted_data);
        let expected = 0; 
        assert(result == expected);
    }

    // Test: Calcuate Q2 for all the same numbers
    {
        let sorted_data: [u64; 10] = [5, 5, 5, 5, 5, 5, 5, 5, 5, 5];
        let result = quartile_q2(sorted_data);
        let expected = 5; 
        assert(result == expected);
    }


    // Test: Calcuate Q3 for distinct, ascending values
    {
        let sorted_data: [u64; 10] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
        let result = quartile_q3(sorted_data);
        let expected = (8 + 9) / 2;
        assert(result == expected);
    }

    // Test: Calcuate Q3 for mix of identical and distinct values
    {
        let sorted_data: [u64; 10] = [1, 2, 3, 4, 4, 5, 5, 6, 7, 8];
        let result = quartile_q3(sorted_data);
        let expected = (6 + 7) / 2; 
        assert(result == expected);
    }

    // Test: Calcuate Q3 for all zeros
    {
        let sorted_data: [u64; 10] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
        let result = quartile_q3(sorted_data);
        let expected = 0;
        assert(result == expected);
    }

    // Test: Calcuate Q3 for all the same number
    {
        let sorted_data: [u64; 10] = [5, 5, 5, 5, 5, 5, 5, 5, 5, 5];
        let result = quartile_q3(sorted_data);
        let expected = 5; 
        assert(result == expected);
    }

    // Test: Calculate IQR for distinct, ascending values
    {
        let data: [u64; 10] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
        let result = interquartile_range(data);
        let expected = 5; 
        assert(result == expected);
    }

    // Test: Calculate IQR for mix of identical and distinct values
    {
        let data: [u64; 10] = [1, 2, 2, 3, 3, 4, 5, 6, 6, 7];
        let result = interquartile_range(data);
        let expected = 4;
        assert(result == expected);
    }

    // Test: Calculate IQR for all zeros
    {
        let data: [u64; 10] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
        let result = interquartile_range(data);
        let expected = 0;
        assert(result == expected);
    }

    // Test: Calculate IQR for all the same numbers
    {
        let data: [u64; 10] = [5, 5, 5, 5, 5, 5, 5, 5, 5, 5];
        let result = interquartile_range(data);
        let expected = 0;
        assert(result == expected);
    }

    // Test: Unsorted array with distinct values
    {
        let data: [u64; 10] = [10, 9, 8, 7, 6, 5, 4, 3, 2, 1];
        let result = sort_data(data);
        let expected: [u64; 10] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]; 
        assert(result == expected);
    }

    // Test: Already sorted array
    {
        let data: [u64; 10] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
        let result = sort_data(data);
        let expected: [u64; 10] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
        assert(result == expected);
    }

    // Test: Reverse sorted array
    {
        let data: [u64; 10] = [10, 9, 8, 7, 6, 5, 4, 3, 2, 1];
        let result = sort_data(data);
        let expected: [u64; 10] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
        assert(result == expected);
    }

    // Test: All zeros
    {
        let data: [u64; 10] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
        let result = sort_data(data);
        let expected: [u64; 10] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
        assert(result == expected);
    }

    // Test: Mix of identical and distinct values
    {
        let data: [u64; 10] = [5, 3, 5, 2, 5, 1, 5, 4, 5, 5];
        let result = sort_data(data);
        let expected: [u64; 10] = [1, 2, 3, 4, 5, 5, 5, 5, 5, 5];
        assert(result == expected);
    }

    // Test: Calculating minimum for distinct values, minimum not the first element
    {
        let data: [u64; 10] = [10, 9, 8, 7, 6, 5, 4, 3, 2, 1];
        let result = find_min(data);
        let expected = 1;
        assert(result == expected);
    }

    // Test: Calculating minimum where all values are the same
    {
        let data: [u64; 10] = [5, 5, 5, 5, 5, 5, 5, 5, 5, 5];
        let result = find_min(data);
        let expected = 5; 
        assert(result == expected);
    }

    // Test: Calculating minimum in a mixed array with identical and distinct values
    {
        let data: [u64; 10] = [3, 7, 2, 8, 5, 2, 2, 4, 6, 1];
        let result = find_min(data);
        let expected = 1;
        assert(result == expected);
    }

    // Test: Calculating minimum where all values are zeros
    {
        let data: [u64; 10] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
        let result = find_min(data);
        let expected = 0;
        assert(result == expected);
    }

    // Test: Calculating maximum for distinct values, minimum not the first element
    {
        let data: [u64; 10] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
        let result = find_max(data);
        let expected = 10;
        assert(result == expected);
    }

    // Test: Calculating maximum where all values are the same
    {
        let data: [u64; 10] = [5, 5, 5, 5, 5, 5, 5, 5, 5, 5];
        let result = find_max(data);
        let expected = 5; 
        assert(result == expected);
    }

    // Test: Calculating maximum in a mixed array with identical and distinct values
    {
        let data: [u64; 10] = [3, 7, 2, 8, 5, 9, 2, 4, 6, 1];
        let result = find_max(data);
        let expected = 9; 
        assert(result == expected);
    }

    // Test: Calculating maximum where All zeros
    {
        let data: [u64; 10] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
        let result = find_max(data);
        let expected = 0; 
        assert(result == expected);
    }

    // Test: Simple linear relationship y = 2x
    {
        let data: [(u64, u64); 10] = [(1, 2), (2, 4), (3, 6), (4, 8), (5, 10), (6, 12), (7, 14), (8, 16), (9, 18), (10, 20)];
        let (m, b) = linear_regression(data);
        assert(m == 2);
        assert(b == 0);

    }

    // Test: Linear relationship y = 3x + 1
    {
        let data: [(u64, u64); 10] = [(1, 4), (2, 7), (3, 10), (4, 13), (5, 16), (6, 19), (7, 22), (8, 25), (9, 28), (10, 31)];
        let (m, b) = linear_regression(data);
        assert(m == 3);
        assert(b == 1);

    }

    // Test: Linear regression where all points are same
    {
        let data: [(u64, u64); 10] = [(5, 5), (5, 5), (5, 5), (5, 5), (5, 5), (5, 5), (5, 5), (5, 5), (5, 5), (5, 5)];
        let (m, b) = linear_regression(data);
        assert(m == 0);
    }
    
    // Test: Logistic regression where set is All zeros
    {
        let data: [(u64, u64); 10] = [(1, 0); 10];
        let result = logistic_regression(data);
        assert(result == 0);
    }

    // Test: Logistic regression for uniform non-zero values
    {
        let data: [(u64, u64); 10] = [(2, 5); 10];
        let result = logistic_regression(data);
        assert(result == 5);
    }

    // Test: Logistic regression for mixed values
    {
        let data: [(u64, u64); 10] = [(3, 1), (4, 2), (5, 3), (6, 4), (7, 5), (8, 6), (9, 7), (10, 8), (11, 9), (12, 10)];
        let result = logistic_regression(data);
        assert(result == 5);
    }

    // Test: Logistic regression for single non-zero value
    {
        let data: [(u64, u64); 10] = [(1, 0), (2, 0), (3, 0), (4, 0), (5, 0), (6, 0), (7, 0), (8, 0), (9, 0), (10, 10)];
        let result = logistic_regression(data);
        assert(result == 1);
    }

    // Test: Logistic regression for increasing values
    {
        let data: [(u64, u64); 10] = [(1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10)];
        let result = logistic_regression(data);
        assert(result == 5);
    }
}


