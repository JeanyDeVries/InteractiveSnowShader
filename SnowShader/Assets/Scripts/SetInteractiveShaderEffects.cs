using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

public class SetInteractiveShaderEffects : MonoBehaviour
{
    [SerializeField] float timeLimitRender;
    [SerializeField] Renderer snowTrackRenderer;

    private Camera orthoCam;
    private float timer;

    void Awake()
    {
        orthoCam = GetComponent<Camera>();

        //Set the FPS rate to 60 so the blending will not go super fast in the render texture
        QualitySettings.vSyncCount = 0;
        Application.targetFrameRate = 60;

        //Set the value correctly in the shader
        Shader.SetGlobalFloat("_OrthographicCamSize", orthoCam.orthographicSize);
    }

    private void Update()
    {
        /*
        Timer();
        if (timer < timeLimitRender)
            return;

        CommandBuffer buf = new CommandBuffer();
        buf.name = "Setting up a new render texture";

        RenderTexture temp = new RenderTexture(orthoCam.targetTexture.width, orthoCam.targetTexture.height,
            0, RenderTextureFormat.ARGBFloat);

        int screenSplatID = Shader.PropertyToID("_Splat");
        buf.GetTemporaryRT(screenSplatID, temp.width, temp.height, 0, FilterMode.Bilinear);
        buf.Blit(orthoCam.targetTexture, screenSplatID);
        snowTrackRenderer.materials[0].SetTexture("_Splat", temp);

        orthoCam.AddCommandBuffer(CameraEvent.AfterSkybox, buf);
        buf.ReleaseTemporaryRT(screenSplatID);

        timer = 0;*/
    }

    private void Timer()
    {
        timer += Time.deltaTime;
    }
}
