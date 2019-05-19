Shader "Custom/Characer shader hologram"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_MainTex2("홀로그램 텍스처", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
		_MetallicTex("MetallicTex", 2D) = "black" {}
		_EmissionTex("Emission", 2D) = "black" {}
		_EmissionColor("Emission color", Color) = (0,0,0,0)
		_EmissionPower("Emission Power", Range(0,50)) = 0
		_BumpMap("Normal", 2D) = "bump" {}
		_AO("Occlusion", 2D) = "white" {}
		_holoCol("홀로그램 색깔", Color) = (1,1,1,1)
		_holoPower("홀로그램 굵기", Range(0,10)) = 4
		_holoAlpha ("홀로그램 조절", Range(0,10)) = 0.5

    }
    SubShader

		
    {
        Tags { "RenderType"="Transparent" "Queue" = "Transparent" }
        LOD 200

		cull off

        CGPROGRAM

        #pragma surface surf Standard alpha:fade


    
        #pragma target 3.0
        
        #include "UnityPBSLighting.cginc"
		#include "UnityStandardBRDF.cginc"
		//#include "UnityShaderVariables.cginc"

        sampler2D _MainTex,_MainTex2,_MetallicTex,_EmissionTex, _BumpMap, _AO;
		//samplerCUBE _CubeMap;
		float3 _EmissionColor, _holoCol;
		float _ReflectionPower, _holoPower, atten, _EmissionPower, _holoAlpha;

		

        struct Input
        {
            float2 uv_MainTex, uv_MainTex2, uv_MetallicTex, uv_EmissionTex, uv_BumpMap;
			float3 worldRefl, viewDir, lightDir, worldPos;
        };

		

	
        half _Glossiness, _Metallic;
		
        fixed4 _Color;

		

		
   
		void surf (Input IN, inout SurfaceOutputStandard o)
        {
      
            fixed4 albedoMap = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            fixed4 holoMap = tex2D (_MainTex2, (IN.uv_MainTex2 +IN.worldPos.y * _holoAlpha + _Time.y)) ;
            fixed4 metalMap = tex2D (_MetallicTex, IN.uv_MetallicTex);
            fixed4 emissionMap = tex2D (_EmissionTex, IN.uv_EmissionTex);
			float3 NormalMap = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
			
			
			
            //o.Albedo = albedoMap.rgb ;
			o.Normal = NormalMap ;
            o.Metallic = _Metallic * metalMap.r;
            o.Smoothness = _Glossiness * metalMap.a;
        
			o.Occlusion = tex2D(_AO, IN.uv_MainTex);

			o.Emission = _holoCol ;
			float hologram = saturate(dot(o.Normal, IN.viewDir)) ;
			hologram = pow(frac(IN.worldPos.g * _holoPower + _Time.y) , 2);
			//Outline = pow(1 - Outline, _linePower) ;

			o.Alpha = (holoMap * hologram ) + 0.1;
			//float3 hologram = pow(1 - rim, 3) +
				/*o.Emission = (emissionMap.rgb * _EmissionColor * _EmissionPower) + (Outline * _lineCol.rgb * (o.Albedo.rgb + 0.2));*/
				
			
        }
        ENDCG
    }
    FallBack "Diffuse"
}
