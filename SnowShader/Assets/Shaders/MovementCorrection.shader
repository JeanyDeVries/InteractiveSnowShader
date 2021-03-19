Shader "Custom/MovementCorrection"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Scale("scale", Range(0,1)) = 1
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
            float4 _MainTex_ST;
            float4  _MainTex_TexelSize;
            //float _OrthographicCamSize;
            float2 _UVOffset;
            float _Scale;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv +  _UVOffset);

                float x = step(1.0 - _MainTex_TexelSize.x * 40.0f, saturate(abs((i.uv.x  * 2.0) - 1.0)));
                float y = step(1.0 - _MainTex_TexelSize.y * 40.0f, saturate(abs((i.uv.y  * 2.0) - 1.0)));
                col.rgb = lerp(col.rgb, (0.0).xxx, min(x + y, 1.0));   

                col.a = 1.0;
                return col;
            }
            ENDCG
        }
    }
}
