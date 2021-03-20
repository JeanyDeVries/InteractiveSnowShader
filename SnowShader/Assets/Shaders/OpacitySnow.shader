// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

/*
    Set the opacity to the red material. It will then blend in the render texture
*/
Shader "Custom/OpacitySnow"
{
    Properties
    {
        _MainTex("Splat Texture", 2D) = "white" {}
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

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
            };

            v2f vert(float4 vertex : POSITION)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(vertex);
                o.worldPos = mul(unity_ObjectToWorld, vertex).xyz;
                return o;
            }

            half _Opacity;
            uniform sampler2D _SplatTex;
            float4 _SplatTex_TexelSize;
            float3 _CameraPosition;
            float _OrthographicCamSize;

            fixed4 frag (v2f i) : SV_Target
            {
                //Always output red for the render texture
                float4 redColor = float4(1.0, 0.0, 0.0, 1.0);

                //Add the opacity to the color
                fixed4 col = redColor * _Opacity * unity_DeltaTime;

                // calculates UV based on distance on XZ plane to orthographic camera. 
                float2 uv = i.worldPos.xz - _CameraPosition.xz;
                //Set the correct scale 
                uv = uv / (_OrthographicCamSize * 2);
                //Add an offset so the position is correct
                uv += 0.5;

                float x = step(1.0 - _SplatTex_TexelSize.x * 2.0f, saturate(abs((uv.x * 2.0) - 1.0)));
                float y = step(1.0 - _SplatTex_TexelSize.y * 2.0f, saturate(abs((uv.y * 2.0) - 1.0)));
                col.rgb = lerp(col.rgb, (0.0).xxx, min(x + y, 1.0));

                col.a = 1.0; 
                return col;
            }
            ENDCG
        }
    }
}
