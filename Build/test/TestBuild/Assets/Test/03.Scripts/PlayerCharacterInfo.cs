using System.Collections;
using System.Collections.Generic;
using UnityEngine;

#region
// 캐릭터의 정보를 담아 두는 스크립트입니다.
#endregion

namespace PlayerCharacter
{
    public class PlayerCharacterInfo : MonoBehaviour
    {
        [SerializeField] public static float s_CapsuleHeight = 1.6f;
        [SerializeField] public static float s_CapsuleRadius = 0.3f;
        [SerializeField] public static float s_CapsuleCenter = 0.8f;

    }
}
