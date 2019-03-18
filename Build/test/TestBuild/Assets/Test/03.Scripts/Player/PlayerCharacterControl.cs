using System.Collections;
using System.Collections.Generic;
using UnityEngine;

#region
// 캐릭터를 동작시키기 위한 부분입니다.

#endregion


namespace PlayerCharacter
{

    [RequireComponent(typeof(PlayerCharacterBehaviour))]
    public class PlayerCharacterControl : MonoBehaviour
    {
        public Camera playerCamera;
        Camera curCamera;
        public GameObject ForwardLook;
        public GameObject CameraForward;
        public GameObject CameraAxisX;

        [SerializeField] float m_CharacterTurnX = 60f;
        [SerializeField] float m_CharacterTurnY = 60f;

        private PlayerCharacterBehaviour m_Character;
        private Vector3 m_MoveDirection;
        private bool m_Jump;
        bool crouch = false;
        bool changeView = false;

        bool isCollision = false;
        bool isControlCharater = true;

        public int layerMask;

        void Start()
        {
            layerMask = 1 << 9;
            curCamera = playerCamera;

            m_Character = GetComponent<PlayerCharacterBehaviour>();
        }

        private void Update()
        {
            if (!m_Jump)
            {
                m_Jump = Input.GetButtonDown("Jump");

            }
        }

        private void FixedUpdate()
        {
            float h = Input.GetAxis("Horizontal");
            float v = Input.GetAxis("Vertical");

            if (isControlCharater)
            {
                if (Input.GetKeyDown(KeyCode.C))
                {
                    crouch = !crouch;
                }

                if (Input.GetAxis("Mouse X") < -0.2f)
                {
                    transform.Rotate(0, -m_CharacterTurnX * Time.deltaTime, 0);
                }
                else if (Input.GetAxis("Mouse X") > 0.2f)
                {
                    transform.Rotate(0, m_CharacterTurnX * Time.deltaTime, 0);
                }

                if (Input.GetAxis("Mouse Y") > 0.2f)
                {
                    curCamera.transform.Rotate(-m_CharacterTurnY * Time.deltaTime, 0, 0);
                }
                else if (Input.GetAxis("Mouse Y") < -0.2f)
                {
                    curCamera.transform.Rotate(m_CharacterTurnY * Time.deltaTime, 0, 0);
                }

                m_MoveDirection = v * Vector3.forward + h * Vector3.right;

                if (Input.GetKey(KeyCode.LeftShift)) m_MoveDirection *= 2.5f;

                m_Character.Move(m_MoveDirection, crouch, m_Jump);

                m_Character.CheckGroundStatus(isCollision);

                if (isCollision)
                    m_Jump = false;

            }
            else
            {
                m_Character.Move(Vector3.zero, false, false);
                
                if(Input.GetAxis("Mouse X") < -0.2f)
                {
                    CameraAxisX.transform.Rotate(0, -m_CharacterTurnX * Time.deltaTime, 0);
                }
                else if(Input.GetAxis("Mouse X")> 0.2f)
                {
                    CameraAxisX.transform.Rotate(0, m_CharacterTurnX * Time.deltaTime, 0);
                }

                if(Input.GetAxis("Mouse Y") > 0.2f)
                {
                    curCamera.transform.Rotate(-m_CharacterTurnY * Time.deltaTime, 0, 0);
                }
                else if(Input.GetAxis("Mouse Y") < -0.2f)
                {
                    curCamera.transform.Rotate(m_CharacterTurnY * Time.deltaTime, 0, 0);
                }
            }


            if (Input.GetKeyDown(KeyCode.F))
            {
                if (!changeView)
                {
                    Vector3 rayDirection = CameraForward.transform.position - ForwardLook.transform.position;

                    RaycastHit hitInfo;

                    Ray ray = new Ray(ForwardLook.transform.position, rayDirection);
                    if (Physics.Raycast(ray, out hitInfo, Mathf.Infinity, layerMask, QueryTriggerInteraction.Ignore))
                    {
                        ObjectInfo objectInfo = hitInfo.transform.GetComponentInParent<ObjectInfo>();

                        if (objectInfo == null)
                            return;

                        changeView = true;
                        isControlCharater = false;
                        ChangeCamera(objectInfo._Camera);
                        CameraAxisX = objectInfo._CameraX;
                    }
                }
                else
                {
                    changeView = false;
                    isControlCharater = true;
                    ChangeCamera(playerCamera);
                }
            }

            if(isControlCharater)
                CastRay();

        }

        void ChangeCamera(Camera newCamera)
        {
            curCamera.targetDisplay = 1;
            curCamera = newCamera;
            curCamera.targetDisplay = 0;
        }

        void CastRay()
        {
            Vector3 rayDirection = CameraForward.transform.position - ForwardLook.transform.position;

            RaycastHit hitInfo;

            Ray ray = new Ray(ForwardLook.transform.position, rayDirection);
            if (Physics.Raycast(ray, out hitInfo, Mathf.Infinity, layerMask, QueryTriggerInteraction.Ignore))
            {
                ObjectInfo objectInfo = hitInfo.transform.GetComponentInParent<ObjectInfo>();

                if (objectInfo == null)
                    return;

                //objectInfo.ViewGUIButton(true);
            }
        }

        private void OnCollisionStay(Collision other)
        {

             isCollision = true;

        }

        private void OnCollisionExit(Collision collision)
        {
            isCollision = false;
        }
    }
}