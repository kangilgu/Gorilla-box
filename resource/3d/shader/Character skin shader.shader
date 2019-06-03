Shader "Custom/Characer skin shader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _SSSColor ("sssColor", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _ReflectionPower ("반사 강도", Range(0,1)) = 0.0
		_MetallicTex("MetallicTex", 2D) = "black" {}
		_EmissionTex("Emission", 2D) = "black" {}
		_EmissionColor("Emission color", Color) = (0,0,0,0)
		_EmissionPower("Emission Power", Range(0,50)) = 0
		_BumpMap("Normal", 2D) = "bump" {}
		_AO("Occlusion", 2D) = "white" {}
		_lineCol("선 색깔", Color) = (1,1,1,1)
		_linePower("선 굵기", Range(0,10)) = 4
		_SSS("SSS", 2D) = "white" {}
    }
    SubShader

		
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

		cull off

        CGPROGRAM

        #pragma surface surf Standard


    
        #pragma target 3.0
        
        #include "UnityPBSLighting.cginc"
		#include "UnityStandardBRDF.cginc"
		//#include "UnityShaderVariables.cginc"

        sampler2D _MainTex,_MetallicTex,_EmissionTex, _BumpMap, _AO, _SSS;
		//samplerCUBE _CubeMap;
		float3 _EmissionColor, _lineCol;
		float _ReflectionPower, _linePower, atten, _EmissionPower;

		

        struct Input
        {
            float2 uv_MainTex, uv_MetallicTex, uv_EmissionTex, uv_BumpMap, uv_SSS;
			float3 worldRefl, viewDir, lightDir, worldPos;
        };

		

	
        half _Glossiness, _Metallic;
		
        fixed4 _Color, _SSSColor;

		

		
   
		void surf (Input IN, inout SurfaceOutputStandard o)
        {
      
			float ndotL = dot(o.Normal, IN.lightDir) * 0.5 + 0.5;

            fixed4 albedoMap = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            fixed4 sssMap = tex2D (_SSS, float2(ndotL, 0.5)) * _SSSColor;
            fixed4 metalMap = tex2D (_MetallicTex, IN.uv_MetallicTex);
            fixed4 emissionMap = tex2D (_EmissionTex, IN.uv_EmissionTex);
			float3 NormalMap = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
			
			float Outline = saturate(dot(o.Normal, IN.viewDir));
			Outline = pow(1 - Outline, _linePower);

			if (Outline > 0.5)
			{
				Outline = 0.7;
			}
			else
			{
				Outline = 1;
			}
			
			float3 sssAlbedo = albedoMap.rgb * sssMap.rgb ;

            o.Albedo = sssAlbedo.rgb; //sssAlbedo.rgb
			o.Normal = NormalMap ;
            o.Metallic = _Metallic * metalMap.r;
            o.Smoothness = _Glossiness * metalMap.a;
            o.Alpha = albedoMap.a;
			o.Occlusion = tex2D(_AO, IN.uv_MainTex);

			o.Emission = emissionMap.rgb * _EmissionColor * _EmissionPower; //(Outline * _lineCol.rgb) * //(o.Albedo.rgb + 0.1));
			
			
        }
        ENDCG
    }
    FallBack "Diffuse"
}
