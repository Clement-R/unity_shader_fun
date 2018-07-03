// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/BasicVertFrag101"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_SecTex("Texture", 2D) = "white" {}
		_Color ("Color", Color) = (1, 1, 1, 1)
		_Tween("Tween", Range(0, 1)) = 0
	}
	SubShader
	{
		Tags
		{ 
			"RenderType"="Opaque"
			"Queue"="Transparent"
		}
		LOD 100

		Pass
		{
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			sampler2D _SecTex;
			float4 _Color;
			float _Tween;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				// col = float4(col.rgb, col.w * (1.0 - _Tween));

				// Repeat texture
				/*fixed4 col = tex2D(_MainTex, i.uv * 2.0);
				col = float4(col.rgb, col.w * (1.0 - _Tween));*/

				// Tween between two textures
				// fixed4 secCol = tex2D(_SecTex, i.uv);
				// secCol = float4(secCol.rgb, secCol.w * _Tween);
				
				// add tint
				// col = col * _Color;
				
				// add uv tint
				// col = col * float4(i.uv.x, i.uv.y, 1, 1);

				// Use sprite shape but new colors
				// col = float4(i.uv.x, i.uv.y, 1, col.w);

				// fixed4 col = float4(i.uv.x, i.uv.y, 1, 1);
				// return lerp(col, secCol, _Tween);
				return col;
			}
			ENDCG
		}
	}
}
