Shader "Custom/EMP_light_Range"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_RG("단계별", float) = 1

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Standard
        #pragma target 3.0

        sampler2D _MainTex;
		float4 _Color;
		float _RG;

        struct Input
        {
            float2 uv_MainTex;
        };
        void surf (Input IN, inout SurfaceOutputStandard o)
        {
			
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			float d = c.r;
			
			if (_RG > 7)
				_RG = 7;

			o.Emission = c.r * _Color *_RG;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
