using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class LobbySceneManager : MonoBehaviour
{

    public void ChangeFirstScene() {
        SceneManager.LoadScene("03.Stage1");
    }

    public void ChangeSecondScene() {
        SceneManager.LoadScene("04.Stage2");
    }

    public void ChangeThirdScene() {
        SceneManager.LoadScene("05.Stage3");
    }
}

