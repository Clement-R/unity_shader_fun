using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class PostProcessEffect : MonoBehaviour {

	public Material mat;
	[Range(1, 10)]
	public int iteration;
	[Range(0, 4)]
	public int downRes;

	private void OnRenderImage(RenderTexture src, RenderTexture dest) {
		int width = src.width >> downRes;
		int height = src.height >> downRes;

		RenderTexture rt = RenderTexture.GetTemporary(width, height);
		Graphics.Blit(src, rt);

		for (int i = 0; i < iteration; i++) {
			RenderTexture rt2 = RenderTexture.GetTemporary(width, height);
			Graphics.Blit(rt, rt2, mat);
			RenderTexture.ReleaseTemporary(rt);
			rt = rt2;
		}

		Graphics.Blit(rt, dest);
		RenderTexture.ReleaseTemporary(rt);
	}
}
