using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CheckCollisionEnter : MonoBehaviour
{
    Material opacityMaterial;
    float opacity;

    private void Awake()
    {
        opacityMaterial = GetComponent<MeshRenderer>().material;
        opacity = opacityMaterial.GetFloat("_Opacity");
        opacityMaterial.SetFloat("_Opacity", 0.0f);
    }

    private void OnCollisionEnter(Collision other)
    {
        if(other.collider.gameObject.tag == "Ground")
            opacityMaterial.SetFloat("_Opacity", opacity);
    }

    private void OnCollisionStay(Collision other)
    {
        if (other.collider.gameObject.tag == "Ground")
            opacityMaterial.SetFloat("_Opacity", opacity);
    }

    private void OnCollisionExit(Collision other)
    {
        if (other.collider.gameObject.tag == "Ground")
            opacityMaterial.SetFloat("_Opacity", 0.0f);
    }
}
