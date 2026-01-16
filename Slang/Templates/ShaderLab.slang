// Template that follows Unity ShaderLab naming conventions

// Camera uniforms
uniform float4x4 iViewProjection;

uniform float4 _Color;

struct appdata
{
	float4 vertex : POSITION;
};

struct v2f 
{
    float4 vertex : SV_Position;
};

[shader("vertex")]
v2f main(appdata v)
{
	v2f o;
	
   	o.vertex = mul(v.vertex, iViewProjection);
    return o;
}

[shader("pixel")]
float4 main(v2f i) : SV_Target0 
{
    return _Color;
}

