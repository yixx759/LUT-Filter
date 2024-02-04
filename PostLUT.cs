using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PostLUT : MonoBehaviour
{
    public Material PostLUTMat;

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source, destination, PostLUTMat);
    }
}
