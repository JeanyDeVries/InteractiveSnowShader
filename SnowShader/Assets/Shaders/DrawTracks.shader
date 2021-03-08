Shader "Unlit/DrawTracks"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Coordinate("Coordinate", Vector) = (0, 0, 0, 0)
        _Color("Draw Color", Color) = (1, 0, 0, 0) //RED
        _WidthTrail("Width Trail", float) = 100
        [Range(0, 1)] _OpacityTrail("Opacity trail", float) = 0.5
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
                float4 worldPos : TEXCOORD4;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _Coordinate;
            fixed4 _Color;

            uniform float3 _Position;
            uniform sampler2D _GlobalEffectRT;
            uniform float _OrthographicCamSize;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            float _WidthTrail;
            float _OpacityTrail;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);

                float2 uv = i.worldPos.xz - _Position.xz;
                uv = uv / (_OrthographicCamSize * 2);
                uv += 0.5;

                float steps = tex2D(_GlobalEffectRT, uv).r;
                steps = step(0.99, steps * 3);

                float draw = pow(saturate(1 - distance(i.uv, _Coordinate.xy)), _WidthTrail);
                fixed4 drawcol = _Color * (draw * _OpacityTrail);
                return saturate(col + drawcol);
            }

            ENDCG
        }
    }
}
