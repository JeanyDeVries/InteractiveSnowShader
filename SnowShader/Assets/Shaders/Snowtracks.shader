Shader "Custom/Snowtracks"
{
    Properties{
            _Tess("Tessellation", Range(1,64)) = 4
            _SnowColor("Snow color", color) = (1,1,1,0)
            _SnowTex("Snow texture", 2D) = "white" {}
            _GroundColor("Ground color", color) = (1,1,1,0)
            _GroundTex("Ground texture", 2D) = "white" {}
            _Splat("Splat Texture", 2D) = "black" {}
            _Displacement("Displacement", Range(0, 1.0)) = 0.3
            _SpecColor("Spec color", color) = (0.5,0.5,0.5,0.5)
    }

    SubShader{
        Tags { "RenderType" = "Transparent" }
        LOD 300

        CGPROGRAM
        #pragma surface surf BlinnPhong addshadow fullforwardshadows vertex:disp tessellate:tessFixed nolightmap
        #pragma target 5.0
        #include "Tessellation.cginc"

        struct appdata {
            float4 vertex : POSITION;
            float4 tangent : TANGENT;
            float3 normal : NORMAL;
            float2 texcoord : TEXCOORD0;
        };

        float _Tess;

        float4 tessFixed()
        {
            return _Tess;
        }

        sampler2D _Splat;
        float _Displacement;

        uniform sampler2D _GlobalEffectRT;
        uniform float _OrthographicCamSize;

        sampler2D _GroundTex;
        fixed4 _GroundColor;
        sampler2D _SnowTex;
        fixed4 _SnowColor;
        float3 _CameraPosition;

        void disp(inout appdata v)
        {
            float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
            float2 uv = worldPos.xz - _CameraPosition.xz;
            uv = uv / (_OrthographicCamSize * 2);
            uv += 0.5;

            float d = saturate(tex2Dlod(_Splat, float4(uv,0,0)).r) * _Displacement;
            v.vertex.xyz -= v.normal * d;
        }

        struct Input {
            float2 uv_GroundTex;
            float2 uv_SnowTex;
            float2 uv_Splat;
            float3 worldPos;
        };

        void surf(Input IN, inout SurfaceOutput o) {
            // calculates UV based on distance on XZ plane to orthographic camera. 
            float2 uv = IN.worldPos.xz - _CameraPosition.xz;
            uv = uv / (_OrthographicCamSize * 2);
            uv += 0.5;

            half amount = saturate(tex2Dlod(_Splat, float4(uv, 0, 0)).r);
            half4 c = lerp(tex2D(_SnowTex, IN.uv_SnowTex) * _SnowColor, tex2D(_GroundTex, IN.uv_GroundTex) * _GroundColor, amount);
            o.Albedo = c.rgb;
            o.Specular = 0.5;
            o.Gloss = 0.5;
        }
        ENDCG
        }
    FallBack "Diffuse"
}
