using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SetInteractiveShaderEffects : MonoBehaviour
{
    [SerializeField] RenderTexture rt;

    // Start is called before the first frame update
    void Awake()
    {
        Shader.SetGlobalFloat("_OrthographicCamSize", GetComponent<Camera>().orthographicSize);
    }

    private void Update()
    {
        rt = GetComponent<Camera>().targetTexture;
        Shader.SetGlobalTexture("_GlobalEffectRT", rt);
        Shader.SetGlobalVector("_Position", transform.position);
    }
}
