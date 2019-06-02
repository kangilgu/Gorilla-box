Shader "Custom/Drink_Alpha_Inside"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_RimColor("Rim_Color", Color) = (1,1,1,1)
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_MainTex2("Albedo (RGB)", 2D) = "white" {}
		_Glossiness("Smoothness", Range(0,1)) = 0.5
		_RimPower("RimPower", Range(0,10)) = 0.5

	}
		SubShader
		{
			Tags { "RenderType" = "Opaque" }

			CGPROGRAM
			#pragma surface surf Standard 
			#pragma target 3.0

			sampler2D _MainTex,_MainTex2;
			half _Glossiness;
			float _RimPower;

			struct Input
			{
				float2 uv_MainTex, uv_MainTex2;
				float3 viewDir;
				float3 worldNormal;
			};
			fixed4 _Color, _RimColor;

			void surf(Input IN, inout SurfaceOutputStandard o)
			{
				fixed4 d = tex2D(_MainTex2, IN.uv_MainTex2 + float2 (0, 1-_Time.y*0.1));
				fixed4 c = tex2D(_MainTex, IN.uv_MainTex * d.r) ;
				float rim = (saturate(dot(o.Normal, IN.viewDir)));
				rim = 1 - rim;
				rim = pow(rim,   _RimPower) ;

				//o.Albedo = c.rgb;
				o.Emission = c.rgb*_RimColor;
				o.Alpha = rim+0.5;
				o.Smoothness = _Glossiness;

			}
			ENDCG
		}
			FallBack "Diffuse"
}
