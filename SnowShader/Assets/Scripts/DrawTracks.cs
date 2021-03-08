using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DrawTracks : MonoBehaviour
{
    public Camera _camera;
    public Shader _drawShader;


    [HideInInspector] public Material _drawMaterial;
    [HideInInspector] public float widthTrail;
    [HideInInspector] public float opacityTrail;

    [HideInInspector] public Transform[] interactionObjects;
    [HideInInspector] public List<Collider> collidors;

    private RenderTexture _splatmap;
    private Material _snowMaterial;
    private RaycastHit hit;

    public virtual void Start()
    {
        GameObject[] target = GameObject.FindGameObjectsWithTag("SnowInteractionObject");
        interactionObjects = new Transform[target.Length];
        for (int i = 0; i < target.Length; i++)
        {
            interactionObjects[i] = target[i].transform;
            SnowInteractionObject snowInteractionObject = interactionObjects[i].GetComponent<SnowInteractionObject>();

            snowInteractionObject._drawMaterial = new Material(_drawShader);
            snowInteractionObject._drawMaterial.SetVector("_Color",
                snowInteractionObject.GetComponent<MeshRenderer>().material.GetFloat("_Opacity") * Color.red);
            snowInteractionObject._drawMaterial.SetFloat("_WidthTrail", snowInteractionObject.widthTrailObject);
            snowInteractionObject._drawMaterial.SetFloat("_OpacityTrail", snowInteractionObject.opacityTrailObject);
        }

        _snowMaterial = GetComponent<MeshRenderer>().material;
        _splatmap = new RenderTexture(1024, 1024, 0, RenderTextureFormat.ARGBFloat);
        _snowMaterial.SetTexture("_Splat", _splatmap);
    }

    private void Update()
    {
        foreach (Transform interactionObject in interactionObjects)
        {
            if (Physics.Raycast(interactionObject.transform.position, -Vector3.up, out hit))
            {
                SnowInteractionObject snowInteractionObject = interactionObject.GetComponent<SnowInteractionObject>();
                if (!snowInteractionObject.onSnow)
                    return;

                snowInteractionObject._drawMaterial.SetVector
                    ("_Coordinate", new Vector4(hit.textureCoord.x, hit.textureCoord.y, 0, 0));
                RenderTexture temp = RenderTexture.GetTemporary(_splatmap.width, _splatmap.height, 0, RenderTextureFormat.ARGBFloat);
                Graphics.Blit(_splatmap, temp);
                Graphics.Blit(temp, _splatmap, snowInteractionObject._drawMaterial);

                //Remove it from memory
                RenderTexture.ReleaseTemporary(temp);
                _camera.targetTexture = temp;
            }
        }
    }

    private void OnGUI()
    {
        GUI.DrawTexture(new Rect(0, 0, 128, 128), _splatmap, ScaleMode.ScaleToFit, false, 1);
    }
}
