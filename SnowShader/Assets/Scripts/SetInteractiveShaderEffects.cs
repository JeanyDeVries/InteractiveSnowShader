using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SetInteractiveShaderEffects : MonoBehaviour
{
    void Awake()
    {
        //Set the FPS rate to 60 so the blending will not go super fast in the render texture
        QualitySettings.vSyncCount = 0;
        Application.targetFrameRate = 60;

        //Set the value correctly in the shader
        Shader.SetGlobalFloat("_OrthographicCamSize", GetComponent<Camera>().orthographicSize);
    }
}
