using UnityEngine;
#if UNITY_IOS
using System.Runtime.InteropServices;
#endif

namespace Bridge
{
    public static class NativeBridge
    {
#if UNITY_IOS
        
        [DllImport("__Internal")]
        private static extern void OnExitUnity();
        
        [DllImport("__Internal")]
        private static extern string SomeFunction(string data);
        
#endif

        public static void ExitUnity()
        {
            
#if !UNITY_EDITOR && UNITY_IOS
            OnExitUnity();
#elif !UNITY_EDITOR && UNITY_ANDROID
            Application.Quit();
//            var jc = new AndroidJavaClass("com.unity3d.player.UnityPlayer"); 
//            var jo = jc.GetStatic<AndroidJavaObject>("currentActivity");
//            jo.Call("finish");
#else

            Debug.LogWarning("NativeBridge OnExitUnity is not available in editor");
#endif
        }
        
        public static string DoSomething(string data)
        {
#if !UNITY_EDITOR && UNITY_IOS
            return SomeFunction(data);
#endif
            Debug.LogWarning("NativeBridge DoSomething is not available in editor");
            return null;
        }
        
    }
}