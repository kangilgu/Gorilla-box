using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using PlayerCharacter;

[System.Serializable]
public class PlayerData
{
    public float healthPoint;
    public float[] position;

    public PlayerData(PlayerCharacterInfo player)
    {
        healthPoint = PlayerCharacterInfo.HP;

        position = new float[3];
        position[0] = player.transform.position.x;
        position[1] = player.transform.position.y;
        position[2] = player.transform.position.z;
    }
}
