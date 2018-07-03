using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class ColorSwapEffect : MonoBehaviour {
	[Header("Palette 1")]
	public Color Color0;
	public Color Color1;
	public Color Color2;
	public Color Color3;

	[Header("Palette 2")]
	public Color Palette2Color0;
	public Color Palette2Color1;
	public Color Palette2Color2;
	public Color Palette2Color3;

	public Material mat;

	Matrix4x4 ColorMatrix {
		get {
			Matrix4x4 mat = new Matrix4x4();
			mat.SetRow(0, ColorToVec(Color0));
			mat.SetRow(1, ColorToVec(Color1));
			mat.SetRow(2, ColorToVec(Color2));
			mat.SetRow(3, ColorToVec(Color3));

			return mat;
		}
	}

	Matrix4x4 SecColorMatrix {
		get {
			Matrix4x4 mat = new Matrix4x4();
			mat.SetRow(0, ColorToVec(Palette2Color0));
			mat.SetRow(1, ColorToVec(Palette2Color1));
			mat.SetRow(2, ColorToVec(Palette2Color2));
			mat.SetRow(3, ColorToVec(Palette2Color3));

			return mat;
		}
	}

	Vector4 ColorToVec(Color color) {
		return new Vector4(color.r, color.g, color.b, color.a);
	}

	void OnRenderImage(RenderTexture src, RenderTexture dest) {
		mat.SetMatrix("_ColorMatrix", ColorMatrix);
		mat.SetMatrix("_SecColorMatrix", SecColorMatrix);
		Graphics.Blit(src, dest, mat);
	}
}
