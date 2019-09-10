#import <UnityLauncher/Launcher.h>

void OnExitUnity()
{
    [Launcher onUnityExit];
}

char* SomeFunction(char* data)
{
    char* cStr = [Launcher someFunction: data];
    NSLog(@"WOW");
    return cStr;
}
