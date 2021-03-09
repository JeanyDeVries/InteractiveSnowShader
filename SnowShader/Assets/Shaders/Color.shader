Shader "Custom/Color"
{
    Properties
    {
        _Opacity ("Opacity", Range(0,1)) = 0.5
    }
    SubShader
    {
        Tags {"RenderType" = "Transparent"}
        Blend One One

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
            float3 worldNormal;
        };

        half _Opacity;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float4 redColor = float4(1.0, 0.0, 0.0, 1.0);


            float d = pow(max(dot(IN.worldNormal, float3(0.0, 1.0, 0.0)), 0.0), 5.0);

            o.Albedo = (0.0).xxx;

            o.Emission = (0.0).xxx;
            o.Emission.r = redColor * _Opacity * d;

        }
        ENDCG
    }
    FallBack "Diffuse"
}
