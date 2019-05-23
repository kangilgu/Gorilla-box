Shader "Custom/Drink_rim_Alpha_shader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness("Smoothness", Range(0,1)) = 0.5
		_RimPower("RimPower", Range(0,10)) = 0.5
		_RimPower2("RimPower2", Range(0,10)) = 0.5


    }
    SubShader
    {
        Tags { "RenderType"= "Transparent""Queue" = "Transparent" }
	
        CGPROGRAM
        #pragma surface surf Standard alpha:fade
        #pragma target 3.0

        sampler2D _MainTex;
		half _Glossiness;
		float _RimPower, _RimPower2;

        struct Input
        {
            float2 uv_MainTex;
			float3 viewDir;

        };
        fixed4 _Color;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			float4 rim = (saturate(dot(o.Normal, IN.viewDir)));
			rim = 1 - rim;
			rim = pow(rim,   _RimPower);

			float rim2 = dot(o.Normal, IN.viewDir);
			rim2 =  1 - rim2;
			rim2 = pow(rim2, _RimPower2);

			//o.Albedo = c.rgb;
            o.Emission = c.rgb*rim2;
            o.Alpha = rim;
			o.Smoothness = _Glossiness;

        }
        ENDCG
    }
    FallBack "Diffuse"
}
