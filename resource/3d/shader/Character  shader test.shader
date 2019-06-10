Shader "Custom/Character shader test"
{
    Properties
    {
        _SSSColor ("sssColor", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Reflection("반사", Cube) = ""{}
		_MetallicTex("MetallicTex", 2D) = "black" {}
		_EmissionTex("Emission", 2D) = "black" {}
		_EmissionColor("Emission color", Color) = (0,0,0,0)
		_EmissionPower("Emission Power", Range(0,50)) = 0
		_BumpMap("Normal", 2D) = "bump" {}
		_AO("Occlusion", 2D) = "white" {}
		_lineCol("선 색깔", Color) = (1,1,1,1)
		_linePower("선 굵기", Range(0,10)) = 4
		_SSS("SSS", 2D) = "" {}
		_Mask("마스크맵", 2D) = "white" {}
    }
    SubShader

		
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

		cull off

        CGPROGRAM

        #pragma surface surf Skin vertex:vert 


    
        #pragma target 3.0
        
        #include "UnityPBSLighting.cginc"
		#include "UnityStandardBRDF.cginc"
		//#include "UnityShaderVariables.cginc"

        sampler2D _MainTex,_MetallicTex,_EmissionTex, _BumpMap, _AO, _SSS, _Mask;
		samplerCUBE _Reflection;
		//samplerCUBE _CubeMap;
		float3 _EmissionColor, _lineCol;
		float  _linePower, _Glossiness, _EmissionPower;

		

        struct Input
        {
            float2 uv_MainTex, uv_MetallicTex, uv_EmissionTex, uv_BumpMap, uv_SSS, uv_Mask;
			float3 worldRefl; 
			float4 color:COLOR; 
			INTERNAL_DATA
        };

		struct SurfaceOutputCustom
		{
			float3 Albedo;
			float3 Normal;
			float3 Alpha;
			float3 Emission;
			float3 Metallic;
			float3 Smoothness;

		};

		void vert(inout appdata_full v)
		{
			
		}


	
   
		void surf(Input IN, inout SurfaceOutputCustom o)
		{

			float3 rv = WorldReflectionVector(IN, o.Normal);

			fixed4 albedoMap = tex2D(_MainTex, IN.uv_MainTex) ;
			fixed4 maskMap = tex2D(_Mask,IN.uv_Mask);
			fixed4 metalMap = tex2D(_MetallicTex, IN.uv_MetallicTex);
			fixed4 emissionMap = tex2D(_EmissionTex, IN.uv_EmissionTex);
			float3 NormalMap = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));


			/*float Outline = saturate(dot(o.Normal, IN.viewDir));
			Outline = pow(1 - Outline, _linePower);

			if (Outline > 0.5)
			{
				Outline = 0.7;
			}
			else
			{
				Outline = 1;
			}*/

			o.Albedo = albedoMap.rgb ; //sssAlbedo.rgb
			o.Normal = NormalMap;
			o.Metallic = metalMap.r ;
			o.Smoothness = metalMap.a * _Glossiness;
			//o.Specular = (metalMap.r * (o.Albedo + 0.2)) + metalMap.a ;
			o.Alpha = maskMap.a;
			//o.Gloss = metalMap.a * _Glossiness ;
			o.Emission = (emissionMap.rgb * _EmissionColor * _EmissionPower); // * UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, rv); //+ (refCube.rgb * o.Gloss ); //(Outline * _lineCol.rgb) * //(o.Albedo.rgb + 0.1));
		}

		
			float4 LightingSkin (SurfaceOutputCustom s, float3 lightDir, float3 viewDir, float atten) {
				
				float3 diffCol;

				float ndotL = dot(s.Normal, lightDir) * 0.7 + 0.3;
				atten = ndotL * atten;
				diffCol = ndotL * s.Albedo.rgb ; 

				float ndotV = dot(s.Normal, viewDir);
				
			/*	float rim;
				float ndotV = dot(s.Normal, viewDir);
				rim = (1 - ndotV, 10) * _LightColor0.rgb ;*/
				
		
				float3 metalCol;
				float3 H = normalize(lightDir + viewDir);
				float full = saturate(dot(s.Normal, H));
				
				metalCol = (full * s.Albedo * s.Emission) * s.Metallic;

				float3 smoothCol;
				smoothCol = s.Smoothness * full;

				float3 sssCol;

				fixed4 sssMap = tex2D(_SSS , float2(ndotL, ndotV));
				sssCol = (sssMap * 0.15)  * trunc(s.Alpha) * 0.6 + 0.1; //* 0.6 + 0.05) ;

				
/*
				float highLight;
				highLight = full ;

				if (highLight > 0.5)
				{
					highLight = 1;
				}
				else
				{
					highLight = 0.2;
				}*/

				float4 final;
				//final.rgb = (diffCol + metalCol + smoothCol) * (_LightColor0.rgb + atten) * sssCol; //* sssCol;
				final.rgb = (smoothCol + diffCol + metalCol ) * (_LightColor0.rgb * atten) * sssCol ; //* sssCol;
				
				final.a = s.Alpha;

				return final;
			}
			
        
        ENDCG
    }
    FallBack "Diffuse"
}
