using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CheckCollisionEnter : MonoBehaviour
{
    [SerializeField] Material opacityMaterial;
    float opacity;

    private void Awake()
    {
        if (opacityMaterial == null)
            opacityMaterial = GetComponent<MeshRenderer>().material;

        opacity = opacityMaterial.GetFloat("_Opacity");

        //Begin with setting it to 0 so it won't leave a trail when there is no collsion
        opacityMaterial.SetFloat("_Opacity", 0.0f);

    }

    private void OnCollisionEnter(Collision other)
    {
        //Set the opacity value to the value that was set in the inspector
        if (other.collider.gameObject.tag == "Ground")
        {
            //Begin with setting it to 0 so it won't leave a trail when there is no collsion
            opacityMaterial.SetFloat("_Opacity", opacity);
        }
    }

    private void OnCollisionStay(Collision other)
    {
        //Set the opacity value to the value that was set in the inspector
        if (other.collider.gameObject.tag == "Ground")
        {
            //Begin with setting it to 0 so it won't leave a trail when there is no collsion
            opacityMaterial.SetFloat("_Opacity", opacity);
        }
    }

    private void OnCollisionExit(Collision other)
    {
        //No collision with the ground, so opacity to 0 so there will not be any snow trail
        if (other.collider.gameObject.tag == "Ground")
        {
            //Begin with setting it to 0 so it won't leave a trail when there is no collsion
            opacityMaterial.SetFloat("_Opacity", 0.0f);
        }
    }
}
