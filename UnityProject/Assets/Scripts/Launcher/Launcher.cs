using Bridge;
using TMPro;
using UnityEngine;

namespace Launcher
{
    public class Launcher : MonoBehaviour
    {
        [SerializeField] private TextMeshProUGUI _text;
        // Start is called before the first frame update
        private void Start()
        {
            var stuff = NativeBridge.DoSomething("GetStuff");
            _text.text = $"Got: {stuff}";
        }
    }
}
