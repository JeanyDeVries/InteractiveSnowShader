// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/OpacitySnow"
{
    Properties
    {
        _Opacity("Opacity", Range(0,0.2)) = 0.1
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" }
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
                float4 redColor = float4(1.0, 0.0, 0.0, 1.0);                
                fixed4 col = redColor * _Opacity;
                return col;
            }
            ENDCG
        }
    }
}
