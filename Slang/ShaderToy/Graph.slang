
RWTexture2D<float4> texFrame; // Output texture

uniform float2 iResolution;
uniform float iTime;

float f(float x)
{
	return sin(x + iTime);
}
bool cmp(float a, float b, float epsilon)
{
	return (abs(a-b))<epsilon;
}

[shader("compute")]
[numthreads(16, 16, 1)]
void render(uint2 thread: SV_DispatchThreadID)
{
	float2 p = float2(thread)/iResolution.xy * 8.0 - 4.;
	float2 plot = float2(thread)/iResolution.xy;
	
	float4 color = float4(0);
	if(cmp(p.y, f(p.x), 0.03))
	{
		color = float4 (1, 0, 0, 1);
	}
	else if (cmp(0.5, plot.x, 0.002) || cmp(0.5, plot.y, 0.004)) 
	{
		color = float4(0, 1, 0, 0);
	}
	else if(cmp(fmod(.5007-plot.x, 0.0625), 0., 0.0014) || cmp(fmod(.5007-plot.y, 0.125), 0., 0.003))
	{
		color = float4(1);
	}
	else 
	{
		color = float4(0);
	}
	
	texFrame[thread] = color;
}
