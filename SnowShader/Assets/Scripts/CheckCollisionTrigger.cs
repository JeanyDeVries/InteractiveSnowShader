using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CheckCollisionTrigger : MonoBehaviour
{
    Material opacityMaterial;
    float opacity;

    private void Awake()
    {
        opacityMaterial = GetComponent<MeshRenderer>().material;
        opacity = opacityMaterial.GetFloat("_Opacity");
        opacityMaterial.SetFloat("_Opacity", 0.0f);
    }

    private void OnTriggerEnter(Collider other)
    {
        if(other.gameObject.tag == "Ground")
            opacityMaterial.SetFloat("_Opacity", opacity);
    }

    private void OnTriggerStay(Collider other)
    {
        if (other.gameObject.tag == "Ground")
            opacityMaterial.SetFloat("_Opacity", opacity);
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.gameObject.tag == "Ground")
            opacityMaterial.SetFloat("_Opacity", 0.0f);
    }
}
