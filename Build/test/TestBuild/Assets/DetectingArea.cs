using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DetectingArea : MonoBehaviour
{
    ObjectInfo objectInfo;
    // Start is called before the first frame update
    void Start()
    {
        objectInfo = GetComponentInParent<ObjectInfo>();
    }

    // Update is called once per frame
    void Update()
    {

    }

    void OnTriggerStay(Collider other)
    {
        if (other.transform.tag == "Player")
        {
            Debug.Log("aa");
            objectInfo._Button.SetActive(true);
            objectInfo._time = 0f;
        }
    }
}
