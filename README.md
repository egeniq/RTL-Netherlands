# Unity Native Integration

This is a project sample of how to embed a Unity3D project in a native iOS or Android applications.

## Getting Started

These instructions will get you to run a sample application with navigation between iOS/Android and Unity3D

### Prerequisites

* Unity3D 2019.2.0f1 or newer
* For Android: Android studio (Latest recommended) and android sdk, Java 8
* For iOS: Xcode


## Deployment (Android)

### Make the Unity project a library
1. Build Unity3D project with the Export option. This will export a gradle project.
2.  In the Build.gradle file, change 
```
apply plugin: 'com.android.application'
```
to
```
apply plugin: 'com.android.library'
```
3. Remove `applicationId 'com.company.yourapp'` under `defaultConfig`
4. Remove `bundle` block
5. In `AndroidManifest.xml` remove the intent filter of the unity activity
6. Build the AAR file (Build -> Make project). The AAR file is under `\build\outputs\aar`

### Use the library inside the app
1. In the app - Import the AAR file we created to your app (File -> New -> New Module... and select Import .JAR/.AAR Package).
2. To avoid manifest merging issues, add to `AndroidManifext.xml` under the application tag: `tools:replace="android:icon,android:theme"`. You might need to add `xmlns:tools="http://schemas.android.com/tools"` under the manifest tag.
3. In the `build.gradle` file of your app module, make sure to add the library as a dependency. Add `implementation project(":libraryName")` under dependencies.
4. Run the app into a device.

## Deployment (iOS)

### Build the unity project
1. Build Unity3D project with the 'export' option. This will create an xcode project.
2. as Target Folder, make sure you save it to <project-root>/iOS/UnityBuild
3. Open `Application.xcworkspace`. Notice you have 2 project inside: the main application ('Example') and a Launcher ('UnityLauncher').
4. Remove the placeholder `Data` from 'Example' ('remove reference')
5. From the 'UnityBuild' folder add `Data` folder to the Example application project as a reference (blue icon).
6. From the 'UnityLauncher' project, remove the current placeholder `Classes` and `Libraries` (reference only, not 'delete')
7. Add `Library` and `Classes` from the `UnityBuild` folder to the UnityLauncherLauncher project as groups (yellow icon).
8. From `Library` we Added, remove `libil2cpp` folder reference (Do not delete the folder, just the reference!)
9. From `Classes` remove `DynamicLibEngineAPI.mm` and `DynamicLibEngineAPI-functions.h` references.
10. From `Classes` open `CrashReporter.mm`. Replace: 
```Objective-C
static NSUncaughtExceptionHandler* gsCrashReporterUEHandler = NULL;

extern "C" uint8_t* UnityGetAppLoadAddress()
{
    // _mh_execute_header points to a mach header, and is located right at the address of where the
    // app is loaded.
    return (uint8_t*)&_mh_execute_header;
}

extern "C" const uint8_t * UnityGetAppLoadCommandAddress()
{
    return (const uint8_t*)(&_mh_execute_header + 1);
}

extern "C" int UnityGetAppLoadCommandCount()
{
    return _mh_execute_header.ncmds;
}
```
to
```Objective-C
static NSUncaughtExceptionHandler* gsCrashReporterUEHandler = NULL;

static uint8_t auint8;

extern "C" uint8_t* UnityGetAppLoadAddress()
{
    // _mh_execute_header points to a mach header, and is located right at the address of where the
    // app is loaded.
    return (uint8_t*)&auint8;
}

extern "C" const uint8_t * UnityGetAppLoadCommandAddress()
{
    return (const uint8_t*)(&auint8 + 1);
}

extern "C" int UnityGetAppLoadCommandCount()
{
    return 0;
}
```
11. Select the 'UnityLauncher' Scheme, and as destination select a physical device or 'generic iOS Device'
12. Build
13. From the 'Example' project, remove the `UnityLauncher.framework` 
14. in `Products` right-click the `UnityLauncher.framework` and 'show in Finder'
15. Add the `UnityLauncher.framework` to the example project (Copy if needed)
16. Make sure that in the `Example` Target, tab 'general' the `UnityLauncher.framework` is added to 'Embedded Binaries'
17. Make sure that in the `Example` Target, tab 'Build Phases' the `UnityLauncher.framework` is added to 'Linked Frameworks and Libraries' and set to `Optional`
18. Select the 'Example' scheme and make sure that the signing is valid for 'on-device' builds.
19. Build and run


### Intergration in Swift
Note that the project is written in Objective-C, but nowadays we moved on to Swift.
Notice that in `main.m` we initialize Unity with `[Launcher unityInit:argc argv:(argv)];`

For Swift, however, use the following (either in your AppDelegate or class that is going to implement it:)
`Launcher.unityInit(CommandLine.argc, argv: CommandLine.unsafeArgv)`

Make sure this is only run ONCE during your app's lifecycle.

to launch the Unity application, use `Launcher.startUnity(viewController)` where `viewController` is a reference to the presenting UIViewController.


This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
