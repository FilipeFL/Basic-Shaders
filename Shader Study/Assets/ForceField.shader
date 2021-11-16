Shader "Custom/ForceField"
{
    Properties{
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("DefaultParticle", 2D) = "white"{}
        [HDR] _Emission ("Emission", color) = (0,0,0)
        _Smoothness ("Smoothness", Range(0, 1)) = 0
        _Metallic ("Metalness", Range(0, 1)) = 0
        _FresnelColor ("Fresnel Color", Color) = (1,1,1,1)
        [PowerSlider(4)] _FresnelExponent ("Fresnel Exponent", Range(0.25, 4)) = 1
    }
    
    SubShader{
        Tags{"Queue"="Transparent"}
        CGPROGRAM
        
        #pragma surface surf Standard alpha:blend
        
        struct Input {
            float2 uv_MainTex;
            float3 worldNormal;
            float3 viewDir;
            INTERNAL_DATA
        };
        
        sampler2D _MainTex;
        
        fixed4 _Color;
        
        half _Smoothness;
        half _Metallic;
        half3 _Emission;

        float3 _FresnelColor;
        float _FresnelExponent;
        
        void surf(Input IN,inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            fixed2 p = fixed2(0,_Time.y);
            o.Emission = c.rgb * _Color;
            o.Alpha = c.r;
            
            //faz o dot product entre a normal e a direção
            float fresnel = dot(IN.worldNormal, IN.viewDir);
            
            //faz um clamp entre os valores de 0 e 1 para não termos artefatos na parte de trás
            fresnel = saturate( 1 - fresnel);

            //combina o valor do fresnel com a cor
            float3 fresnelColor = fresnel * _FresnelColor;
            
            //aumenta o valor do fresnel para ajustá-lo
            fresnel = pow(fresnel, _FresnelExponent);
            
            //aplica o fresnel à emissão
            o.Emission = _Emission + fresnel;
        }
        ENDCG
    }
}
