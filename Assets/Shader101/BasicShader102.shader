Shader "Hidden/BasicShader102"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_DisplaceTex ("DisplaceTexture", 2D) = "white" {}
		_Magnitude ("Magnitude", Range(0, 1)) = 0
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
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

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;
			sampler2D _DisplaceTex;

			float4 _MainTex_TexelSize;
			float _Magnitude;

			// Blur fun
			float4 box(sampler2D tex, float2 uv, float4 size) {
				float4 c = tex2D(tex, uv + float2(-size.x, size.y))
					+ tex2D(tex, uv + float2(0, size.y))
					+ tex2D(tex, uv + float2(size.x, size.y))
					+ tex2D(tex, uv + float2(-size.x, 0))
					+ tex2D(tex, uv + float2(0, 0))
					+ tex2D(tex, uv + float2(size.x, 0))
					+ tex2D(tex, uv + float2(-size.x, -size.y))
					+ tex2D(tex, uv + float2(0, -size.y))
					+ tex2D(tex, uv + float2(size.x, -size.y));

				return c / 9;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				// fixed4 col = tex2D(_MainTex, i.uv);
				// just invert the colors
				// col.rgb = 1 - col.rgb;
			
				// Apply uv colors
				// col = float4(i.uv.x, i.uv.y, 1, 1);

				// Apply uv colors on main tex
				// col = col * float4(i.uv.x, i.uv.y, 1, 1);

				// Displacement fun
				 float2 disp = tex2D(_DisplaceTex, i.uv).xy;
				 // disp = ((disp * 2.0) - 1.0) * _Time.x;
				
				 // disp = ((disp * 2.0) - 1.0) * _Magnitude;
				 disp = ((disp * 2.0) - 1.0) * abs(_SinTime.w) * 0.05;

				 fixed4 col = tex2D(_MainTex, i.uv + disp); 

				 return col;

				/*float2 distuv = float2(i.uv.x + _Time.x * 2, i.uv.y + _Time.x * 2);

				float2 disp = tex2D(_DisplaceTex, distuv).xy;
				disp = ((disp * 2) - 1) * _Magnitude;

				float4 col = tex2D(_MainTex, i.uv + disp);
				return col;*/
				

				// Blur fun
				// float4 col = box(_MainTex, i.uv, _MainTex_TexelSize);
				// return col;
			}
			ENDCG
		}
	}
}
