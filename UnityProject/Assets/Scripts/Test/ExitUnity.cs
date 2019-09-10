using Bridge;
using UnityEngine;
using UnityEngine.UI;

namespace Test
{
    public class ExitUnity : MonoBehaviour
    {
        private void Awake()
        {
            GetComponent<Button>().onClick.AddListener(OnButtonClick);
        }

        public void OnButtonClick()
        {
            NativeBridge.ExitUnity();
        }
    }
}
