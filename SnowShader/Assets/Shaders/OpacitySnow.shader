// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

/*
    Set the opacity to the red material. It will then blend in the render texture
*/
Shader "Custom/OpacitySnow"
{
    Properties
    {
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

            float4 vert(float4 vertex : POSITION) : SV_POSITION
            {
                return UnityObjectToClipPos(vertex);
            }

            half _Opacity;

            fixed4 frag () : SV_Target
            {
                //Always output red for the render texture
                float4 redColor = float4(1.0, 0.0, 0.0, 1.0);      

                //Add the opacity to the color
                fixed4 col = redColor * _Opacity * unity_DeltaTime;
                return col;
            }
            ENDCG
        }
    }
}
