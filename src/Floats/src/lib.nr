use dep::std;

struct Float {
    sign: Field,
    mantissa: Field,
    exponent: Field,
}

global precision: Field = 7;

fn relu(x: Float) -> Float {
    if x.sign as u64 == 1 { Float { sign: 0, mantissa: 0, exponent: 100 } } else { x }
}

fn truncate(num: Float) -> Float {
    let lookup: [Field; 25] = [1, 10, 100, 1000, 10000, 100000, 1000000, 10000000, 100000000, 1000000000, 10000000000, 100000000000, 1000000000000, 10000000000000, 100000000000000, 1000000000000000, 10000000000000000, 100000000000000000, 1000000000000000000, 10000000000000000000, 100000000000000000000, 1000000000000000000000, 10000000000000000000000, 100000000000000000000000, 1000000000000000000000000];
    let maxValue: Field = 10.pow_32(precision);
    let mut decValue: Field = 1;
    let mut logValue: Field = 0;
    for i in 0..25 {
        if num.mantissa as u64 >= lookup[i] as u64 {
            decValue = lookup[i];
            logValue = i;
        }
    }
    decValue *= 10;
    logValue += 1;
    let mut res: Float = Float { sign: num.sign, mantissa: num.mantissa, exponent: num.exponent };
    if logValue as u64 > precision as u64 {
        let diff = (decValue / maxValue) as u64;
        res = Float { sign: num.sign, mantissa: (num.mantissa as u64 / diff) as Field, exponent: num.exponent + (logValue - precision) };
    }
    if res.mantissa == 0 {
        res = Float { sign: res.sign, mantissa: 0, exponent: 100 };
    }
    res
}

fn mulFloats(x: Float, y: Float) -> Float {
    let mant = x.mantissa * y.mantissa;
    let exp = x.exponent + y.exponent;
    let sign: Field = if x.sign != y.sign { 1 } else { 0 };
    truncate(Float { sign, mantissa: mant, exponent: exp })
}

fn divFloats(x: Float, y: Float) -> Float {
    assert(y.mantissa as u64 != 0, "Division by zero");
    let exp1 = x.exponent as u64;
    let exp2 = y.exponent as u64;
    let mut mant1 = x.mantissa as u64;
    let mant2 = y.mantissa as u64;
    let exponent_diff = if exp1 > exp2 { exp1 - exp2 } else { 0 };
    if exponent_diff == 1 { mant1 *= 10; } else if exponent_diff == 2 { mant1 *= 100; } else if exponent_diff == 3 { mant1 *= 1000; }
    let new_mant = mant1 / mant2;
    let new_exp = if exp1 > exp2 { 100 + exponent_diff } else { 100 };
    let sign: Field = if x.sign != y.sign { 1 } else { 0 };
    truncate(Float { sign, mantissa: new_mant as Field, exponent: new_exp as Field })
}

fn addFloats(x: Float, y: Float) -> Float {
    let mut mant_1 = x.mantissa;
    let mut mant_2 = y.mantissa;
    let mut exp_1 = x.exponent;
    let mut exp_2 = y.exponent;
    let mut diff: Field = if exp_1 as u64 > exp_2 as u64 { exp_1 - exp_2 } else { exp_2 - exp_1 };
    let pow10: Field = 10.pow_32(diff);
    if x.exponent as u64 < y.exponent as u64 { mant_2 *= pow10; exp_1 = x.exponent; } else { mant_1 *= pow10; exp_1 = y.exponent; }
    let mut sum_mant = mant_1 + mant_2;
    let mut sign = x.sign;
    if x.sign != y.sign { if mant_1 as u64 > mant_2 as u64 { sum_mant = mant_1 - mant_2; } else { sum_mant = mant_2 - mant_1; sign = y.sign; } }
    truncate(Float { sign, mantissa: sum_mant, exponent: exp_1 })
}

fn subFloats(x: Float, y: Float) -> Float {
    addFloats(x, Float { sign: 1 - y.sign, mantissa: y.mantissa, exponent: y.exponent })
}

fn test_add_floats() {
    let float1 = Float { sign: 0, mantissa: 10000, exponent: 100 };
    let float2 = Float { sign: 0, mantissa: 20000, exponent: 100 };
    let result = addFloats(float1, float2);
    assert(result.mantissa as u64 == 30000);
    let float1 = Float { sign: 0, mantissa: 10000, exponent: 101 };
    let float2 = Float { sign: 0, mantissa: 20000, exponent: 100 };
    let result = addFloats(float1, float2);
    assert(result.mantissa as u64 == 120000);
    let float1 = Float { sign: 0, mantissa: 30000, exponent: 100 };
    let float2 = Float { sign: 1, mantissa: 10000, exponent: 100 };
    let result = addFloats(float1, float2);
    assert(result.mantissa as u64 == 20000);
    let float1 = Float { sign: 0, mantissa: 10000, exponent: 100 };
    let float2 = Float { sign: 0, mantissa: 0, exponent: 100 };
    let result = addFloats(float1, float2);
    assert(result.mantissa as u64 == 10000);
}

fn test_sub_floats() {
    let float1 = Float { sign: 0, mantissa: 30000, exponent: 100 };
    let float2 = Float { sign: 0, mantissa: 10000, exponent: 100 };
    let result = subFloats(float1, float2);
    assert(result.mantissa as u64 == 20000);
    let float1 = Float { sign: 0, mantissa: 10000, exponent: 100 };
    let float2 = Float { sign: 0, mantissa: 30000, exponent: 100 };
    let result = subFloats(float1, float2);
    assert(result.mantissa as u64 == 20000);
    assert(result.sign == 1);
    let float1 = Float { sign: 0, mantissa: 20000, exponent: 100 };
    let float2 = Float { sign: 0, mantissa: 20000, exponent: 100 };
    let result = subFloats(float1, float2);
    assert(result.mantissa as u64 == 0);
}

fn test_mul_floats() {
    let float1 = Float { sign: 0, mantissa: 1000, exponent: 100 };
    let float2 = Float { sign: 0, mantissa: 2000, exponent: 100 };
    let result = mulFloats(float1, float2);
    assert(result.mantissa as u64 == 2000000);
    let float1 = Float { sign: 0, mantissa: 3000, exponent: 100 };
    let float2 = Float { sign: 1, mantissa: 2000, exponent: 100 };
    let result = mulFloats(float1, float2);
    assert(result.sign == 1);
    let float1 = Float { sign: 0, mantissa: 10000, exponent: 100 };
    let float2 = Float { sign: 0, mantissa: 0, exponent: 100 };
    let result = mulFloats(float1, float2);
    assert(result.mantissa as u64 == 0);
}

fn test_div_floats() {
    let float1 = Float { sign: 0, mantissa: 10000, exponent: 100 };
    let float2 = Float { sign: 0, mantissa: 5000, exponent: 100 };
    let result = divFloats(float1, float2);
    assert(result.mantissa as u64 == 2);
    assert(result.exponent as u64 == 100);
    let float1 = Float { sign: 0, mantissa: 10000, exponent: 101 };
    let float2 = Float { sign: 0, mantissa: 5000, exponent: 100 };
    let result = divFloats(float1, float2);
    assert(result.mantissa as u64 == 20);
    assert(result.exponent as u64 == 101);
    let float1 = Float { sign: 0, mantissa: 30000, exponent: 100 };
    let float2 = Float { sign: 0, mantissa: 30000, exponent: 100 };
    let result = divFloats(float1, float2);
    assert(result.mantissa as u64 == 3333333);
    assert(result.exponent as u64 == 100);
    let float1 = Float { sign: 0, mantissa: 10000, exponent: 100 };
    let float2 = Float { sign: 1, mantissa: 5000, exponent: 100 };
    let result = divFloats(float1, float2);
    assert(result.mantissa as u64 == 2);
    assert(result.sign == 1);
    assert(result.exponent as u64 == 100);
}


fn main() {
    test_add_floats();
    test_sub_floats();
    test_mul_floats();
    test_div_floats();
}   