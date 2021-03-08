Shader "Custom/Color"
{
    Properties
    {
        _Color ("Color red", Range(0,1)) = 1
        _Opacity ("Opacity", Range(0,1)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200
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
        half _Color;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo.r = _Color * _Opacity;
            o.Albedo = (0.0).xxx;

            float d = pow(max(dot(IN.worldNormal, float3(0.0, 1.0, 0.0)), 0.0), 5.0);

            o.Emission = (0.0).xxx;
            o.Emission.r = _Color * _Opacity * d;

        }
        ENDCG
    }
    FallBack "Diffuse"
}
