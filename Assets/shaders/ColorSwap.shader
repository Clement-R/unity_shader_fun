Shader "Hidden/ColorSwap"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Step ("Step", Range(0, 4.5)) = 0.5
		_MousePos ("Mouse Position", Vector) = (0, 0, 0, 0)
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always
		Blend SrcAlpha OneMinusSrcAlpha
		
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
			fixed _Step;
			half4x4 _ColorMatrix;
			half4x4 _SecColorMatrix;
			float4 _MousePos;

			float circle(in float2 _st, in float _radius) {
				_st.x -= 0.5;
				float aspect = _ScreenParams.x / _ScreenParams.y;
				_st.x *= aspect;
				_st.x += 0.5;

				float2 dist = _st - float2(0.5, 0.5);
				return 1. - smoothstep(_radius - (_radius*0.01),
									   _radius + (_radius*0.01),
									   dot(dist, dist)*4.0);
			}

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 baseCol = tex2D(_MainTex, i.uv);
				fixed x = baseCol.r;
				fixed4 col = _ColorMatrix[x * 3];
				fixed4 secCol = _SecColorMatrix[x * 3];

				// Swap only on step
				// fixed a = step(_Step, i.uv.x);
				// col = a > 0.5 ? baseCol : col;
				// Debug step
				// col = fixed4(a, a, a, 1);
				
				// Swap with circle and secondary palette
				float c = circle(i.uv.xy, _Step);
				// float c = circle(_MousePos.xy, _Step);

				// Debug circle
				// col = float4(c, c, c, 1);
				col = c > 0.5 ? secCol : col;

				// Swap with grayscale
				// col = c > 0.5 ? dot(col, float3(0.3, 0.59, 0.11)) : col;
				
				return col;
			}
			ENDCG
		}
	}
}
