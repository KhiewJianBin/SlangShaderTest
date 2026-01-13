
//The first slang function.
//Notice that we pass 4 floats into the function.
//we will use this function to generate a bunch of points
//for the quadratic.
float quadratic(float x, float a, float b, float c){
    return (a * x * x) + (b * x) + c;
}

// Define a struct in slang to store our quadratic coefficients.
struct QuadraticCoeffs {
    float a; // coefficient for x²
    float b; // coefficient for x
    float c; // constant term
};

float quadratic_v2(float x, QuadraticCoeffs coeffs) {
    return (coeffs.a * x * x) + (coeffs.b * x) + coeffs.c;
}

struct QuadraticInput {
    float a; // coefficient for x²
    float b; // coefficient for x
    float c; // constant term
    float x;
}

struct QuadraticOutput {
    float y_a;
    float y_b;
    float y_c;
    float y;
}

 void  quadratic_v3(QuadraticInput input, out QuadraticOutput output) {
    output.y_a = input.x * input.x * input.a;
    output.y_b = input.x * input.b;
    output.y_c = input.c;
    output.y = output.y_a + output.y_b + output.y_c;
 }

 [Differentiable]
 float quadratic_v4(float a, float b, float c, float x) {
     return (a * x * x) + (b * x) + c;
 }
