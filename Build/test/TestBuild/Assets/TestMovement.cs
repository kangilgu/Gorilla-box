using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestMovement : MonoBehaviour
{
    public float speed = 6.0F;
    public float jumpSpeed = 8.0F;
    public float gravity = 20.0F;
    public float turnSpeed = 180f;
    private Vector3 moveDirection = Vector3.zero;

    void Update()
    {
        if(Input.GetAxis("Mouse X") > 0.2f)
        {
            this.transform.Rotate(0, turnSpeed * Time.deltaTime, 0);
        }
        else if(Input.GetAxis("Mouse X") < -0.2f)
        {
            this.transform.Rotate(0, -turnSpeed * Time.deltaTime, 0);
        }

        if (Input.GetAxis("Mouse Y") > 0.2f)
        {
            Camera.main.transform.Rotate(-turnSpeed / 2f * Time.deltaTime, 0, 0);
        }
        else if (Input.GetAxis("Mouse Y") < -0.2f)
        {
            Camera.main.transform.Rotate(turnSpeed / 2f * Time.deltaTime, 0, 0);
        }

        CharacterController controller = GetComponent<CharacterController>();
        if (controller.isGrounded)
        {
            moveDirection = new Vector3(Input.GetAxis("Horizontal"), 0, Input.GetAxis("Vertical"));
            moveDirection = transform.TransformDirection(moveDirection);
            moveDirection *= speed;
            if (Input.GetButton("Jump"))
                moveDirection.y = jumpSpeed;

        }
        moveDirection.y -= gravity * Time.deltaTime;
        controller.Move(moveDirection * Time.deltaTime);
    }
}
