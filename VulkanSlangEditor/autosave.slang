
[shader("vertex")]
float4 main(uint vertexID : SV_VertexID) : SV_Position {
    // Input built-in is passed as a function parameter
    
    // Calculate position based on vertex ID
    float x = (vertexID == 0) ? -0.5 : ((vertexID == 1) ? 0.5 : 0.0);
    float y = (vertexID == 2) ? 0.5 : -0.5;
    
    // Output built-in is returned from the function
    return float4(x, y, 0.0, 1.0);
}

// Pixel shader using direct parameters
[shader("pixel")]
float4 main(float2 texCoord : TEXCOORD0) : SV_Target0 
{
    // Use texCoord to sample a texture
    return float4(texCoord, 0.0, 1.0);
}