RWTexture2D<float4> texFrame; // Output texture

uniform float2 iResolution; // Screen size

uniform float iTime; // In seconds

[shader("compute")]
[numthreads(16, 16, 1)]
void main(uint2 thread: SV_DispatchThreadID)
{
	float2 uv = float2(thread) / iResolution;
	
	uv.x += sin(iTime);
	float4 color = float4(uv, 0, 1.0);
	
	texFrame[thread] = color;
}
