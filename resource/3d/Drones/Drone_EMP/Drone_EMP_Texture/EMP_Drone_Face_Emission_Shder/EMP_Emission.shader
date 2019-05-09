Shader "Custom/EMP_Emission"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_MainTex2("홀로그램 채널", 2D) = "white" {}
		_RimPower("빛의 세기",Range(0,10)) = 0.1
		

    }
    SubShader
    {
		Tags { "RenderType" = "Opaque"}
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard
        #pragma target 3.0

        sampler2D _MainTex, _MainTex2;

		float4  _Color;
		float _RimPower;

        struct Input
        {
            float2 uv_MainTex, uv_MainTex2;
        };
        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
		
			fixed4 HLTex = tex2D(_MainTex2, IN.uv_MainTex2 * 1+ float2 (_Time.y , 0));
			//fixed4 HLTex = tex2D(_MainTex2, IN.uv_MainTex2);
			//HLTex.a = tex2D(_MainTex2, IN.uv_MainTex2 * 1 + float2 (_Time.y*1, 0));


			float4 ama = lerp(c, HLTex, HLTex);
			ama = ama * _Color;
			o.Emission =   ama*_RimPower;
			
        }
        ENDCG
    }
    FallBack "Diffuse"
}
