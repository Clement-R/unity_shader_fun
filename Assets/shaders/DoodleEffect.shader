Shader "Unlit/DoodleEffect"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_Noise ("Noise texture", 2D) = "white" {}
		_Amount("Amount", Range(0.005, 0.01)) = 0.0
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
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
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float3 normal : NORMAL;
			};

			sampler2D _MainTex;
			sampler2D _Noise;
			float _Amount;
			float4 _MainTex_ST;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.normal = v.normal;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				// Flag
				// float2 noise = UnpackNormal(tex2D(_Noise, i.uv + float2(_Time.y / 3.0, _Time.y / 3.0).xy));
				
				float2 noise = UnpackNormal(tex2D(_Noise, i.uv + float2(_Time.y * 300.0, _Time.y * 300.0).xy));

				float2 uv = i.uv + (noise * _Amount);

				fixed4 col = tex2D(_MainTex, uv);
				// col = float4(1, 1, 1, col.a);
				
				return col;
			}
			ENDCG
		}
	}
}
