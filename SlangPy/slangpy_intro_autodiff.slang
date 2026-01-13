
struct DataPoint : IDifferentiable
{
    float x;
    float y;
};

struct QuadraticParams : IDifferentiable
{
    float a; // coefficient for x²
    float b; // coefficient for x
    float c; // constant term

    [Differentiable]
    float evaluate(float x) {
        return (a * x * x) + (b * x) + c;
    }
};


//Differentiable loss function (Mean Squared Error)
//We run this in a single thread for ease of explanation.
[Differentiable]
float computeLoss(QuadraticParams params,
    uint point_count,
    RWStructuredBuffer<DataPoint> dataPoints
)
{
    float totalLoss = 0.0f;

    //MaxIters
    //Becuase we are terminating this loop
    //based on a variable point_count, we 
    //need to specify the maximum iterations
    //we could want to run.
    [MaxIters(256)]
    for (uint i = 0; i < point_count; i++)
    {
        //Take each datapoint
        DataPoint point = dataPoints[i];

        //compute the error of each point
        //with respect to the input features
        //and the current guess of the coefficients
        float predicted = params.evaluate(point.x);
        float error = predicted - point.y;

        //Accumulate the error.
        totalLoss += error * error;
    }

    //Take the mean.
    return totalLoss * float(1.0/point_count);
}

[shader("compute")]
[numthreads(32, 1, 1)]
void test_quadratic(
    uint3 dispatchThreadID: SV_DispatchThreadID,
    RWStructuredBuffer<DataPoint> dataPoints,
    RWStructuredBuffer<QuadraticParams> params
) {
    uint tid = dispatchThreadID.x;

    DataPoint dp = dataPoints[tid];
    dataPoints[tid].y = params[0].evaluate(dp.x);

}

[shader("compute")]
[numthreads(1, 1, 1)]
void main(
    uint3 dispatchThreadID: SV_DispatchThreadID,
    RWStructuredBuffer<DataPoint> dataPoints,
    RWStructuredBuffer<QuadraticParams> params,
    RWStructuredBuffer<float> lossHistory,
    uint epoch,
    uint max_epochs,
    uint point_count,
    float learning_rate    
) {

    uint tid = dispatchThreadID.x;
    //Get the current state of the quadratic coefficients
    QuadraticParams currentParams = params[0];

    //Initialize a differential pair.
    DifferentialPair<QuadraticParams> dpParams = diffPair(currentParams);

    //Record the current loss. 
    //We will plot this at the end
    if (epoch < max_epochs) {
        lossHistory[epoch] = computeLoss(currentParams,point_count, dataPoints);
    }

    //Call the backward pass of 'computeLoss'
    //This will place the gradients of the function
    //into the 'd' memmber of the differential pair.
    //The gradients reflect the 'incorrectness' of the
    //coefficients with respect to the 'incorrectness' 
    //(mean squared error) of the ouptut.
    // Propagate gradients backward
    bwd_diff(computeLoss)(dpParams, point_count, dataPoints, 1.0);

    // Extract gradients
    QuadraticParams gradients = dpParams.d;

    // Subract a small fraction of the gradient
    //(scaled by the learning rate) from the 
    QuadraticParams newParams;
    newParams.a = currentParams.a - learning_rate * gradients.a;
    newParams.b = currentParams.b - learning_rate * gradients.b;
    newParams.c = currentParams.c - learning_rate * gradients.c;

    // Store updated parameters
    params[0] = newParams;


}
