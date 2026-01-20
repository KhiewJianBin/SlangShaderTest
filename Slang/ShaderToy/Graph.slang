// Camera uniforms
uniform float4x4 iViewProjection;

uniform uint2 iResolution;

uniform float iTime; // In seconds

struct appdata
{
	float4 pos : POSITION;
};

struct v2f 
{
    float4 pos : SV_Position;
    
    float3 worldPos : TEXCOORD0;
};

[shader("vertex")]
v2f main(appdata v)
{
	v2f o;
	
   	o.pos = mul(v.pos, iViewProjection);
    return o;
}

float f(float x)
{
	return sin(x + iTime);
}
bool cmp(float a, float b, float epsilon)
{
	return (abs(a-b))<epsilon;
}

[shader("pixel")]
float4 main(v2f i) : SV_Target0 
{
	float4 color = float4(0,0,0,1);
	
	float2 p = i.pos.xy / iResolution.xy * 8.0 - 4.;
	float2 plot = i.pos.xy / iResolution.xy;
	
	if(cmp(p.y, f(p.x), 0.03))
	{
		color = float4 (1., 0., 0., 1.);
	}
	else if (cmp(0.5, plot.x, 0.002) || cmp(0.5, plot.y, 0.004)) 
	{
		color = float4(0.0, 1.0, 0.0, 1.0);
	}
	else if(cmp(fmod(.5007-plot.x, 0.0625), 0., 0.0014) || cmp(fmod(.5007-plot.y, 0.125), 0., 0.003))
	{
		color = float4(1.);
	}
	else 
	{
		color = float4(.0);
	}
	
	i.pos.xy = i.pos.xy / iResolution.xy;
	color.rg = i.pos.xy;
	
    return color;
}



