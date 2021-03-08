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
        Tags { "RenderType" = "Opaque" }
        LOD 300

        CGPROGRAM
        #pragma surface surf BlinnPhong addshadow fullforwardshadows vertex:disp tessellate:tessDistance nolightmap
        #pragma target 5.0
        #include "Tessellation.cginc"

        struct appdata {
            float4 vertex : POSITION;
            float4 tangent : TANGENT;
            float3 normal : NORMAL;
            float2 texcoord : TEXCOORD0;
        };

        float _Tess;

        float4 tessDistance(appdata v0, appdata v1, appdata v2) {
            float minDist = 10.0;
            float maxDist = 25.0;
            return UnityDistanceBasedTess(v0.vertex, v1.vertex, v2.vertex, minDist, maxDist, _Tess);
        }

        sampler2D _Splat;
        float _Displacement;

        void disp(inout appdata v)
        {
            float d = tex2Dlod(_Splat, float4(v.texcoord.xy,0,0)).r * _Displacement;
            v.vertex.xyz -= v.normal * d;

            //Set the ground even to the height of the displacement
            v.vertex.xyz += v.normal * _Displacement;
        }

        sampler2D _GroundTex;
        fixed4 _GroundColor;
        sampler2D _SnowTex;
        fixed4 _SnowColor;

        struct Input {
            float2 uv_GroundTex;
            float2 uv_SnowTex;
            float2 uv_Splat;
        };

        void surf(Input IN, inout SurfaceOutput o) {
            half amount = tex2Dlod(_Splat, float4(IN.uv_Splat, 0, 0)).r;
            half4 c = lerp(tex2D(_SnowTex, IN.uv_SnowTex) * _SnowColor, tex2D(_GroundTex, IN.uv_GroundTex) * _GroundColor, amount);
            o.Albedo = c.rgb;
            o.Specular = 0.2;
            o.Gloss = 1.0;
        }
        ENDCG
        }
    FallBack "Diffuse"
}
