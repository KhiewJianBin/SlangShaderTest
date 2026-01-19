// Camera uniforms
uniform float4x4 iViewProjection;

uniform uint2 iResolution;

struct appdata
{
	float4 pos : POSITION;
};

struct v2f 
{
    float4 pos : SV_Position;
};

[shader("vertex")]
v2f main(appdata v)
{
	v2f o;
	
   	o.pos = mul(v.pos, iViewProjection);
    return o;
}

[shader("pixel")]
float4 main(v2f i) : SV_Target0 
{
	float4 color = float4(0,0,0,1);
	
	i.pos.xy = i.pos.xy / iResolution.xy;
	color.rg = i.pos.xy;
	
    return color;
}

