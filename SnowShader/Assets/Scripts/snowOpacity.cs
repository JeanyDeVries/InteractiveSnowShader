using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class snowOpacity : MonoBehaviour
{
    public Shader snowFallShader;
    public MeshRenderer snowMeshRenderer;

    [Range(0.001f, 0.1f)] public float flakeAmount;
    [Range(0f, 0.1f)] public float flakeOpacity;

    private Material snowFallMat;

    void Start()
    {
        snowFallMat = new Material(snowFallShader);
    }

    void LateUpdate()
    {
        snowFallMat.SetFloat("_FlakeAmount", flakeAmount);
        snowFallMat.SetFloat("_FlakeOpacity", flakeOpacity);

        RenderTexture snow = (RenderTexture)snowMeshRenderer.material.GetTexture("_SnowSplatTex");
        RenderTexture temp = RenderTexture.GetTemporary(snow.width, snow.height, 0, RenderTextureFormat.ARGBFloat);
        Graphics.Blit(snow, temp, snowFallMat);
        Graphics.Blit(temp, snow);

        snowMeshRenderer.material.SetTexture("_SnowSplatTex", snow);
        RenderTexture.ReleaseTemporary(temp);
    }
}
