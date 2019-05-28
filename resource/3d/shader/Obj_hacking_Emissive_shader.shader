Shader "hacking/Obj_hacking_Emissive_shader"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_EmissivePower("EmissivePower",float) = 0.5
	}
		SubShader
	{
		Tags { "RenderType" = "Opaque" }

		CGPROGRAM
		#pragma surface surf ES noshadow noambient
		#pragma target 3.0

		float _EmissivePower;

        struct Input
        {
			float4 color:COLOR;
        };

        fixed4 _Color;

        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Emission = _Color * _EmissivePower;
            o.Alpha = 1;
        }
		float4 LightingES(SurfaceOutput j, float3 lightDir, float attne)
		{
			float4 finalColor;
			finalColor.rgb = j.Emission;
			finalColor.a = 1;
			return finalColor;
		}
        ENDCG
    }
    FallBack "Diffuse"
}
