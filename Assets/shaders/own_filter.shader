Shader "Hidden/own_filter"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
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

			float rand(float2 co) {
				return frac(sin(dot(co.xy, float2(12.9898, 78.233))) * 43758.5453);
			}

			float2 mirror(float2 uv) {
				return float2(uv.x, 1 - uv.y);
			}

			float2 symmetry(float2 uv) {
				// Dirty way
				float2 uv2;
				uv2.x = uv.x;
				if (uv.y <= 0.5) {
					uv2.y = 1 - uv.y;
				} else {
					uv2.y = uv.y;
				}
				return uv2;
				
				// Cool way
				// uv.y = abs(uv.y - .5) + .5;
				// return uv;
			}

			float2 rotation(float2 uv) {
				// Translate world to (0.5, 0.5)
				uv -= .5;
				// Remap world between -1 and 1
				uv.x *= _ScreenParams.x / _ScreenParams.y;
				
				// Rotation logic
				float a = atan2(uv.y, uv.x);
				a += 0.6 * _SinTime.w;
				uv = float2(cos(a), sin(a))*length(uv);

				// Remap world between 0 and 1
				uv.x *= _ScreenParams.y / _ScreenParams.x;
				// Translate the world back to its original position
				uv += .5;

				return uv;
			}

			float2 scale(float2 uv) {
				// Own
				/*uv -= .5;
				uv.x *= _ScreenParams.x / _ScreenParams.y;
				uv = uv / 2.0;
				uv.x *= _ScreenParams.y / _ScreenParams.x;
				uv += .5;*/

				// Correction
				uv -= .5;
				uv *= .5;
				uv += .5;
				return uv;
			}

			float2 zoomDistored(float2 uv) {
				// Fail :(

				// Correction
				uv -= .5;
				
				float l = length(uv);
				uv *= smoothstep(.0, .5, l);

				uv += .5;
				return uv;
			}

			float2 repeat(float2 uv) {
				// Fail :(

				// Correction
				float s = 4.;
				float c = .5;
				uv -= c / 2.;
				uv = fmod((uv + c / 2.)*s / 2., c);
				uv += c / 2.;

				return uv;
			}

			float2 spiral(float2 uv) {
				// Fail :(

				// Correction
				uv -= .5;
				uv.x *= _ScreenParams.x / _ScreenParams.y;
				float l = length(uv) - .1;
				float a = atan2(uv.y, uv.x);
				a += l * 10.;
				uv = float2(cos(a), sin(a))*length(uv)*_SinTime.z;
				uv += .5;
				return uv;
			}

			float2 applyScanline(float2 uv) {
				uv.x += (rand(uv.yy)*2. - 1.)*.1*smoothstep(.0, 1., sin(uv.y*5.));
				return uv;
			}

			float2 applyDoubleFrequence(float2 uv) {
				uv -= .5;
				
				float dir = sin(abs(uv.y*1000.));
				uv.x += sign(dir) * 0.05;
				// uv.x += sign(dir) * smoothstep(0., 0.5, (abs(abs(_SinTime.w) - 0.5)));
				
				uv += .5;
				return uv;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				float2 uv = i.uv;

				// uv = mirror(uv);
				// uv = symmetry(uv);
				// uv = rotation(uv);
				// uv = scale(uv);
				// uv = zoomDistored(uv);
				// uv = repeat(uv);
				// uv = spiral(uv);
				uv = applyDoubleFrequence(uv);

				/*float4 color = float4(uv.x, uv.y, 0.0, 1.0);
				return color;*/

				fixed4 col = tex2D(_MainTex, uv);
				return col;
			}
			ENDCG
		}
	}
}
