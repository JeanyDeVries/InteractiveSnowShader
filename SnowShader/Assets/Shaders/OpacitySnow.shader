// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

/*
    Set the opacity to the red material. It will then blend in the render texture
*/
Shader "Custom/OpacitySnow"
{
    Properties
    {
        _MainTex("Splat Texture", 2D) = "black" {}
        _Opacity("Opacity", Range(0,10)) = 0.1
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" }

        //Blendmode enabled so the colors with custom opacity will overlay
        BlendOp Add
        Blend One One

        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float3 worldNormal: POSITION;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            float4 vert(float4 vertex : POSITION) : SV_POSITION
            {
                return UnityObjectToClipPos(vertex);
            }

            half _Opacity;
            uniform sampler2D _SplatTex;
            uniform float2 _UVOffsetSnow;
            float4 _SplatTex_TexelSize;

            fixed4 frag (v2f i) : SV_Target
            {
                //Always output red for the render texture
                float4 redColor = float4(1.0, 0.0, 0.0, 1.0);

                //Add the opacity to the color
                fixed4 col = redColor * _Opacity * unity_DeltaTime;

                //fixed4 col = tex2D(_SplatTex, i.uv + _UVOffsetSnow);

                float x = step(1.0 - _SplatTex_TexelSize.x * 40.0f, saturate(abs((i.uv.x * 2.0) - 1.0)));
                float y = step(1.0 - _SplatTex_TexelSize.y * 40.0f, saturate(abs((i.uv.y * 2.0) - 1.0)));
                col.rgb = lerp((0.0).xxx, col.rgb, min(x + y, 1.0));

                col.a = 1.0;
                return col;
            }
            ENDCG
        }
    }
}
