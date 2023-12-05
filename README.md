# Noir Statistical Library (statnr)

## Description

**Noir Statistical Library** is a comprehensive library for statistical computations in the Noir language. It includes functions for basic statistical measures such as mean, median, mode, and range, as well as advanced computations like linear regression, logistic regression, and interquartile range. The library supports operations on both integer (`u64`) and custom floating-point (`Float`) types.

## statnr's relevance in Zero-Knowledge Proofs (ZKP)
ZKP applications often require complex mathematical computations to ensure data privacy while proving the veracity of the information. Here, statnr's extensive suite of statistical functions will be helpful.

## Features

- **Mean Calculation**: Compute the average of a fixed-size array of integers or custom floats.
- **Median Calculation**: Determine the middle value in a sorted array of integers or floats.
- **Mode Calculation**: Find the most frequent value in an array.
- **Range Calculation**: Compute the difference between the maximum and minimum values in an array.
- **Generate a range of integer or float numbers**: Generate a range of numbers using various parameters.
- **Standard Deviation and Variance**: Calculate the spread of a dataset.
- **Quartile Computations**: Determine Q1, Q2, and Q3 values for a dataset.
- **Linear Regression**: Perform simple linear regression analysis.
- **Logistic Regression**: Perform simple logistic regression analysis.
- **Utilities**: Functions for sorting data, finding minimum and maximum values, etc.


### Examples



```noir
//Mean Calculation
let numbers: [u64; 5] = [1, 2, 3, 4, 5];
let average = mean(numbers);
assert(average == 3);


//Median Calculation
let numbers: [Field; 5] = [1, 2, 3, 4, 5];
let median_value = median(numbers);
assert(median_value == 3);


//Linear Regression

let data: [(u64, u64); 10] = [(1, 2), (2, 4), (3, 6), (4, 8), (5, 10), (6, 12), (7, 14), (8, 16), (9, 18), (10, 20)];
let (slope, intercept) = linear_regression(data);
assert(slope == 2);
assert(intercept == 0);

//Generate a range of float numbers    
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

```
## Testing

Each function is accompanied by a suite of tests to ensure correctness and robustness. Run the tests using Noir's built-in testing framework to validate functionality.

## Limitations

The current implementation of some functions is limited to fixed-size arrays. Adjustments are required to handle variable-sized arrays. Floating-point computations are approximations and might not be suitable for highly precise calculations.
