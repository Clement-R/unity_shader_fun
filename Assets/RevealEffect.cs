using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RevealEffect : MonoBehaviour {
	private SpriteRenderer _sr;
	private Material _mat;

	private void Start() {
		_sr = GetComponent<SpriteRenderer>();
		_mat = _sr.material;
	}

	void Update () {
		_mat.SetVector("_MousePos", Camera.main.ScreenToViewportPoint(Input.mousePosition));
	}
}
