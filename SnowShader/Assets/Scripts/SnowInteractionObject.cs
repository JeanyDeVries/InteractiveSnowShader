using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SnowInteractionObject : DrawTracks
{
    public float widthTrailObject;
    public float opacityTrailObject;
    [HideInInspector] public Collider colliderObject;

    [HideInInspector] public bool onSnow;

    public override void Start()
    {
        widthTrail = widthTrailObject;
        opacityTrail = opacityTrailObject;
        colliderObject = GetComponent<Collider>();

        base.Start();
    }

    private void OnCollisionEnter(Collision collision)
    {
        if(collision.gameObject.tag == "Ground")
            onSnow = true;
    }

    private void OnCollisionStay(Collision collision)
    {
        if (collision.gameObject.tag == "Ground")
            onSnow = true;
    }

    private void OnCollisionExit(Collision collision)
    {
        onSnow = false;
    }

}
