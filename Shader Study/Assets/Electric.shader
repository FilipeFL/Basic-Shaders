Shader "Custom/Electric"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)
        _MainTex("DefaultParticle", 2D) = "white"{}
        _Noise("Noise(RGB)", 2D) = "white"{}
        _Brilho("Brilho", Range(0,3)) = 1
    }
        
    SubShader
    {
        Tags {"Queue"="Transparent"}
        
        CGPROGRAM
        #pragma surface surf Standard alpha:blend
        
        struct Input{float2 uv_MainTex;};
        
        sampler2D _MainTex, _Noise;
        
        fixed4 _Color;
        fixed _Brilho;

        //Implementação do shader que utiliza de duas texturas (uma pra partícula e outra para o noise) e animação
        void surf(Input IN,inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D(_MainTex,IN.uv_MainTex);
            fixed2 p = fixed2(0,_Time.y);
            fixed4 noise = tex2D(_Noise,IN.uv_MainTex-p)*_Brilho;
            o.Emission = c.rgb * noise.rgb * _Color;
            o.Alpha = c.r * noise.r;
        }
        ENDCG
    }
}
