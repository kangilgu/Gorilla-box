using System.Collections;
using System.Collections.Generic;
using UnityEngine;

#region
// 캐릭터의 정보를 담아 두는 스크립트입니다.
#endregion

namespace PlayerCharacter
{
    [System.Serializable]
    public class PlayerCharacterInfo : MonoBehaviour
    {
        [SerializeField] public static float s_CapsuleHeight = 1.6f;
        [SerializeField] public static float s_CapsuleRadius = 0.3f;
        [SerializeField] public static float s_CapsuleCenter = 0.8f;

        public static float HP = 1000f;

        public void SavePlayer()
        {
            SaveLoadManager.SavePlayer(this);
        }

        public void LoadPlayer()
        {
            PlayerData data = SaveLoadManager.LoadPlayer();

            HP = data.healthPoint;

            Vector3 position;
            position.x = data.position[0];
            position.y = data.position[0];
            position.z = data.position[0];
            transform.position = position;
        }
    }
}
