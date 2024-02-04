Shader "Unlit/LUT"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _LUT ("LUT", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            
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
            sampler2D _LUT;
            float4 _MainTex_ST;


float mix( float a, float b, float t)
{
return a*(1-t)+b*t;

    
}

            
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
              
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                //Make sure LUT texture No compression Wrap mode: Clamp  Filter Mode: Point NO MIPMAPS

                
                //Method from https://lettier.github.io/3d-game-shaders-for-beginners/lookup-table.html
                fixed4 col = saturate(tex2D(_MainTex, i.uv));
           
float2 LeftUv;
                 LeftUv.x = floor(col.z*15)*16;
                LeftUv += floor(col.x*15);
                LeftUv /= 255;
                LeftUv.y = 1-(floor(col.y*15)/15);
                float2 RightUv;
                 RightUv.x = ceil(col.z*15)*16;
                RightUv += ceil(col.x*15);
                RightUv /= 255;
                RightUv.y = 1-(ceil(col.y*15)/15);
               
            fixed4 lu = tex2D(_LUT,  LeftUv );
            fixed4 ru = tex2D(_LUT,  RightUv );

                float4 Finalcol = float4(0,0,0,1);
                Finalcol.x = mix(lu.x, ru.x, frac(col.x*15));
                Finalcol.y = mix(lu.y, ru.y, frac(col.y*15));
                Finalcol.z = mix(lu.z, ru.z, frac(col.z*15));

                
                return Finalcol;
            }
            ENDCG
        }
    }
}
