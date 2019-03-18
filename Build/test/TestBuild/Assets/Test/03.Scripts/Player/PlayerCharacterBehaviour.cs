using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;


namespace PlayerCharacter
{
    [RequireComponent(typeof(PlayerCharacterInfo))]
    [RequireComponent(typeof(CapsuleCollider))]
    [RequireComponent(typeof(Animator))]
    [RequireComponent(typeof(Rigidbody))]
    public class PlayerCharacterBehaviour : MonoBehaviour
    {
        [SerializeField] float m_MovingTurnSpeed = 360f;
        [SerializeField] float m_StationaryTurnSpeed = 180f;
        [SerializeField] float m_CameraTurnSpeed = 120f;
        [SerializeField] float m_JumpPower = 12f;
        [SerializeField] float m_MoveSpeed = 6f;
        [Range(1f, 4f)] [SerializeField] float m_GravityMultiplier = 2f;
        [SerializeField] float m_RunCycleLegOffset = 0.2f;
        [SerializeField] float m_MoveSpeedMultiplier = 1f;
        [SerializeField] float m_AnimSpeedMultiplier = 1f;
        [SerializeField] float m_GroundCheckDistance = 0.1f;

        // 캐릭터의 주요 Component
        Rigidbody m_Rigidbody;
        Animator m_Animator;
        bool m_IsGrounded;
        float m_OrigGroundCheckDistance;

        // 애니메이션 컨트롤 변수
        float m_TurnAmount;
        float m_ForwardAmount;
        Vector3 m_GroundNormal = Vector3.zero;

        // Collider의 변화적용
        const float k_Half = 0.5f;
        float m_CapsuleHeight;
        float m_CapsuleRadius;
        Vector3 m_CapsuleCenter;
        CapsuleCollider m_Capsule;
        bool m_Crouching;

        // 캐릭터 시선처리
        public int layerMask;

        bool m_Jump = false;
        Vector3 m_MoveDirection;



        // Start is called before the first frame update
        void Start()
        {

            // 콜라이더 변수 지정
            m_CapsuleCenter = new Vector3(0, PlayerCharacterInfo.s_CapsuleCenter, 0);
            m_CapsuleHeight = PlayerCharacterInfo.s_CapsuleHeight;
            m_CapsuleRadius = PlayerCharacterInfo.s_CapsuleRadius;

            // 캐릭터 콜라이더 설정
            m_Capsule = GetComponent<CapsuleCollider>();
            m_Capsule.height = m_CapsuleHeight;
            m_Capsule.radius = m_CapsuleRadius;
            m_Capsule.center = m_CapsuleCenter;

            m_Animator = GetComponent<Animator>();

            // RigidBody 지정
            m_Rigidbody = GetComponent<Rigidbody>();
            m_Rigidbody.constraints = RigidbodyConstraints.FreezeRotationX |
                RigidbodyConstraints.FreezeRotationY |
                RigidbodyConstraints.FreezeRotationZ;

            m_OrigGroundCheckDistance = m_GroundCheckDistance;
        }

        public void Move(Vector3 move, bool crouch, bool jump)
        {
            if (move.magnitude > 1f) move.Normalize();
            m_TurnAmount = Mathf.Atan2(move.x, move.z);
            m_ForwardAmount = move.z;

            //ApplyExtraTurnRotation();

            if (m_IsGrounded)
            {
                HandleGroundMovement(crouch, jump);
            }
            else
            {
                HandleAirborneMovement();
            }


            ScaleCapsuleForCrouching(crouch);
            transform.Translate(move * m_MoveSpeed * Time.deltaTime);
            UpdateAnimator(m_MoveDirection);
        }

        void ScaleCapsuleForCrouching(bool crouch)
        {
            if (crouch)
            {
                if (m_Crouching) return;
                m_Capsule.height = m_CapsuleHeight / 2f;
                m_Capsule.center = m_CapsuleCenter / 2f;
                m_Crouching = true;
            }
            else
            {
                Ray crouchRay = new Ray(m_Rigidbody.position + Vector3.up * m_Capsule.radius * k_Half, Vector3.up);
                float crouchRayLength = m_CapsuleHeight - m_Capsule.radius * k_Half;
                if(Physics.SphereCast(crouchRay, m_Capsule.radius * k_Half, crouchRayLength, Physics.AllLayers, QueryTriggerInteraction.Ignore))
                {
                    m_Crouching = true;
                    return;
                }
                m_Capsule.height = m_CapsuleHeight;
                m_Capsule.center = m_CapsuleCenter;
                m_Crouching = false;
            }
        }

        void UpdateAnimator(Vector3 move)
        {
            m_Animator.SetFloat("Forward", m_ForwardAmount, 0.1f, Time.deltaTime);
            m_Animator.SetFloat("Turn", m_TurnAmount, 0.1f, Time.deltaTime);
            m_Animator.SetBool("Crouch", m_Crouching);
            m_Animator.SetBool("OnGround", m_IsGrounded);
            
            if (m_Jump)
            {
                m_Animator.SetFloat("Jump", m_Rigidbody.velocity.y);
            }

            float runCycle =
                Mathf.Repeat(m_Animator.GetCurrentAnimatorStateInfo(0).normalizedTime + m_RunCycleLegOffset, 1);

            float jumpLeg = (runCycle < k_Half ? 1 : -1) * m_ForwardAmount;

            if (m_IsGrounded)
            {
                m_Animator.SetFloat("JumpLeg", jumpLeg);

                if (m_IsGrounded && move.magnitude > 0)
                {
                    m_Animator.speed = m_AnimSpeedMultiplier;
                }
                else
                {
                    m_Animator.speed = 1;
                }
            }
        }

        void HandleAirborneMovement()
        {
            Vector3 extraGravityForce = (Physics.gravity * m_GravityMultiplier) - Physics.gravity;
            m_Rigidbody.AddForce(extraGravityForce);
            m_GroundCheckDistance = m_Rigidbody.velocity.y < 0 ? m_OrigGroundCheckDistance : 0.01f;
        }

        void HandleGroundMovement(bool crouch, bool jump)
        {
            if(jump && !crouch && m_Animator.GetCurrentAnimatorStateInfo(0).IsName("Grounded"))
            {
                m_Rigidbody.velocity = new Vector3(m_Rigidbody.velocity.x, 
                    m_JumpPower, m_Rigidbody.velocity.z);
                
                m_IsGrounded = false;
                m_Animator.applyRootMotion = false;
                m_GroundCheckDistance = 0.1f;
            }
        }

        public void CheckGroundStatus(bool collision)
        {
            if (collision)
            {
                m_IsGrounded = true;
                m_Animator.applyRootMotion = true;
            }
            else
            {
                m_IsGrounded = false;
                m_Animator.applyRootMotion = true;
            }
        }

        public void OnAnimatorMove()
        {
            if(m_IsGrounded && Time.deltaTime > 0)
            {
                Vector3 v = (m_Animator.deltaPosition * m_MoveSpeedMultiplier) / Time.deltaTime;

                v.y = m_Rigidbody.velocity.y;
                m_Rigidbody.velocity = v;
            }
        }


    }

}