Shader "Unlit/OccludedSprite"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_MousePos("Mouse Position", Vector) = (0, 0, 0, 0)
	}

	CGINCLUDE
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
	float4 _MainTex_ST;
	float4 _MousePos;

	v2f vert(appdata v)
	{
		v2f o;
		o.vertex = UnityObjectToClipPos(v.vertex);
		o.uv = TRANSFORM_TEX(v.uv, _MainTex);
		return o;
	}

	float circle(in float2 _st, in float _radius) {
		_st -= (_MousePos - .5);

		_st.x -= 0.5;
		float aspect = _ScreenParams.x / _ScreenParams.y;
		_st.x *= aspect;
		_st.x += 0.5;

		float2 dist = _st - float2(0.5, 0.5);
		return 1. - smoothstep(_radius - (_radius*0.01),
			_radius + (_radius*0.01),
			dot(dist, dist)*4.0);
	}
	ENDCG

	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Blend SrcAlpha OneMinusSrcAlpha

		Pass
		{
			// Set stencil value to 4
			Stencil
			{
				Ref 4
				Comp Always
				Pass Replace
			}

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile _ PIXELSNAP_ON
			#include "UnityCG.cginc"

			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				col.a = circle(i.uv.xy, 0.5);
				return col;
			}
			ENDCG
		}

		//Pass
		//{	
		//	// Set stencil value to 4
		//	Stencil
		//	{
		//		Ref 4
		//		Comp Equal
		//	}
		//	
		//	CGPROGRAM
		//	#pragma vertex vert
		//	#pragma fragment frag
		//	#pragma multi_compile _ PIXELSNAP_ON
		//	#include "UnityCG.cginc"

		//	fixed4 frag (v2f i) : SV_Target
		//	{
		//		return (0, 0, 0, 0);
		//	}
		//	ENDCG
		//}

		Pass
		{
			Stencil
			{
				Ref 4
				Comp NotEqual
			}

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile _ PIXELSNAP_ON
			#include "UnityCG.cginc"

			fixed4 _OccludedColor;

			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				return col;
			}
			ENDCG
		}
	}
}
