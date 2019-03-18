using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ObjectInfo : MonoBehaviour
{
    public Camera _Camera;
    public GameObject _CameraX;
    public GameObject _Button;
    public SphereCollider _sphereCollider;
    [SerializeField] float _detectArea;

    public float _time = 0.0f;

    void Start()
    {
        _Camera = GetComponentInChildren<Camera>();

        if (_Button == null)
            return;

        _Button.SetActive(false);
    }

    void Update()
    {
        if(_time % 3 > 2)
        {
            _time = 0;
            if (_Button == null)
                return;

            ViewGUIButton(false);
        }

        _time += Time.deltaTime;
        _sphereCollider.radius = _detectArea;
    }

    public void ViewGUIButton(bool isView)
    {
        _Button.SetActive(isView);
    }

    public enum ObjectType
    {
        CCTV,
        Cabinet
    }

}
