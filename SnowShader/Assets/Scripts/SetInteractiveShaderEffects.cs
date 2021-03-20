using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

public class SetInteractiveShaderEffects : MonoBehaviour
{
    [SerializeField] float resfreshRate;
    [SerializeField] private Material MovementCorrectionMaterial;
    [SerializeField] private bool Debug = false;

    [SerializeField] GameObject player;

    private Camera orthoCam;
    private float timer;

    private Vector2 oldPlayerPos;

    void Awake()
    {
        orthoCam = GetComponent<Camera>();

        //Set the value correctly in the shader
        Shader.SetGlobalFloat("_OrthographicCamSize", orthoCam.orthographicSize);

        oldPlayerPos = new Vector2(player.transform.position.x, player.transform.position.z);

        RecenterSplatMap();
    }

    private void Update()
    {
        Timer();
        if (timer < resfreshRate)
            return;
        timer = 0.0f;

        RecenterSplatMap();
    }

    private void RecenterSplatMap()
    {

        Vector2 currPos = new Vector2(player.transform.position.x, player.transform.position.z);
        Vector2 delta = currPos - oldPlayerPos;
        delta /= orthoCam.orthographicSize * 2.0f;

        oldPlayerPos = currPos;
        orthoCam.transform.position = player.transform.position + new Vector3(0.0f, 50.0f, 0.0f);
        Shader.SetGlobalVector("_CameraPosition", orthoCam.transform.position);

        MovementCorrectionMaterial.SetVector("_UVOffset", delta);
        Shader.SetGlobalVector("_UVOffsetSnow", delta);

        RenderTexture temp = RenderTexture.GetTemporary(orthoCam.targetTexture.width, orthoCam.targetTexture.height,
              0, orthoCam.targetTexture.format);
        Graphics.Blit(orthoCam.targetTexture, temp, MovementCorrectionMaterial);
        Graphics.Blit(temp, orthoCam.targetTexture);

        Shader.SetGlobalTexture("_SplatTex", orthoCam.targetTexture);
        Shader.SetGlobalTexture("_SnowSplatTex", orthoCam.targetTexture);

        temp.Release();
    }

    private void OnGUI()
    {
        if (Debug)
            GUI.DrawTexture(new Rect(new Vector2(25.0f, 25.0f), new Vector2(500.0f, 500.0f)), orthoCam.targetTexture); 
    }

    private void Timer()
    {
        timer += Time.deltaTime;
    }
}
