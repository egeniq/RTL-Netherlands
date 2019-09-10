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
1. Build Unity3D project with. This will create an xcode project.
2. Open `Application.xcworkspace`. Notice you have 2 project inside: the main application and a Launcher.
3. From the Unity build folder, Add `Data` folder to the application project as a reference (blue icon).
4. Add `Library` and `Classes` the the Launcher project as groups (yellow icon).
5. From `Library` we Added, remove il2cpp folder reference (Do not delete the folder, just the reference!)
6. From `Classes` remove `DynamicLibEngineAPI.mm` and `DynamicLibEngineAPI-functions.h` references.
7. From `Classes` open `CrashReporter.mm`. Replace: 
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
8. Run the application to a device.



This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
