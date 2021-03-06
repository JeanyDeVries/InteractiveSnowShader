Shader "Custom/Snowtracks"
{
    Properties{
        [Header(Tesselation options)]
        [Space(5)]
        _Tess("Tessellation ", float) = 0.01
        _MinDist("minimal distance ", float) = 0
        _MaxDist("maximal distance ", float) = 100
        _Phong("Phong Strengh", Range(0,1)) = 0.5
        _Displacement("Displacement", float) = 0.3

        [Space(10)]
        [Header(Snow)]
        [Space(5)]
        _SnowColor("Snow color", color) = (1,1,1,0)
        _SnowTex("Snow texture", 2D) = "white" {}

        [Space(10)]
        [Header(Ground)]
        [Space(5)]
        _GroundColor("Ground color", color) = (1,1,1,0)
        _GroundTex("Ground texture", 2D) = "white" {}

        [Space(10)]
        [Header(SplatTexture)]
        [Space(5)]
        _SnowSplatTex("Splat Texture", 2D) = "black" {}

        [Space(10)]
        [Header(Lighting)]
         [Space(5)]
        _SpecColor("Spec color", color) = (0.5,0.5,0.5,0.5)
    }

    SubShader{
        Tags { "RenderType" = "Transparent" }
        LOD 300

        CGPROGRAM
        #pragma surface surf BlinnPhong addshadow fullforwardshadows vertex:disp tessellate:tessDistance tessphong:_Phong nolightmap fragment frag
        #pragma target 5.0
        #include "Tessellation.cginc"

        struct appdata 
        {
            float4 vertex : POSITION;
            float4 tangent : TANGENT;
            float3 normal : NORMAL;
            float2 texcoord : TEXCOORD0;
        };

        /*Set the tesselation set in the inspector to the mesh*/
        float _Phong;
        float _MinDist;
        float _MaxDist;
        float _Tess;

        float4 tessDistance (appdata v0, appdata v1, appdata v2) {
            return UnityDistanceBasedTess(v0.vertex, v1.vertex, v2.vertex, _MinDist, _MaxDist, _Tess);
        }

        sampler2D _SnowSplatTex;
        float _Displacement;

        uniform float _OrthographicCamSize;
        
        sampler2D _GroundTex;
        fixed4 _GroundColor;
        sampler2D _SnowTex;
        fixed4 _SnowColor;
        float3 _CameraPosition;

        float2 ScreenUV;
        float depthScreen;

        sampler2D _CameraDepthNormalsTexture;
        void disp(inout appdata v)
        {
            //Get the world position
            float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;


            //Set the position of the uv
            float2 uv = worldPos.xz - _CameraPosition.xz;
            //Set the correct scale 
            uv = uv / (_OrthographicCamSize * 2);
            //Add an offset so the position is correct
            uv += 0.5;


            //Vertex shader

            //Clamp the texture from 0 to 1 so it will not stack 
            //Look up the splat texture and grab the red value of the uv
            //Add the displacement value as an offset
            float depth = saturate(tex2Dlod(_SnowSplatTex, float4(uv, 0, 0)).r) * _Displacement;
            //Set the vertex and distract the normal with the displacement for the depth in the snow
            v.vertex.xyz -= v.normal * depth;
        }

        struct Input 
        {
            float2 uv_GroundTex;
            float2 uv_SnowTex;
            float2 uv_SnowSplatTex;
            float3 worldPos;
        };

        void surf(Input IN, inout SurfaceOutput o) 
        {
            // calculates UV based on distance on XZ plane to orthographic camera. 
            float2 uv = IN.worldPos.xz - _CameraPosition.xz;
            //Set the correct scale 
            uv = uv / (_OrthographicCamSize * 2);
            //Add an offset so the position is correct
            uv += 0.5;


            //Surface shader

            //Clamp the texture from 0 to 1 so it will not stack
            //Look up the splat texture and grab the red value of the uv
            //Add the displacement value as an offset
            half depth = saturate(tex2Dlod(_SnowSplatTex, float4(uv, 0, 0)).r);

            //mix the snow and ground texture according to the depth of the snow
            half4 color = lerp(tex2D(_SnowTex, IN.uv_SnowTex) * _SnowColor, tex2D(_GroundTex, IN.uv_GroundTex) * _GroundColor, depth);

            o.Albedo = color.rgb * 1.0;
            o.Specular = 0.05;
            o.Gloss = 0.05;
        }
        ENDCG
        }
    FallBack "Diffuse"
}
