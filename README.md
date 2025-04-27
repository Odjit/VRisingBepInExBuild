This is the repo for building BepInEx for V-Rising 1.1.

Make sure to initialize git submodules if you didn't when cloning with the below command.

git submodule update --init --recursive

Run createVRisingBepInEx.cmd and this will create BepInEx_V-Rising_1.1.zip

Steps taken by the powershell script
1. Build BepInEx and its necessary libraries (Cpp2IL and IL2CppInterop) with the necessary V-Rising changes
2. Download the BepInEx 733 Bleeding Edge download for Unity.IL2CPP-win-x64
3. Extract to BepInEx_V-Rising_1.1
4. Copy our new binary files from BepInEx\bin\Unity.IL2CPP to BepInEx_V-Rising_1.1\BepInEx\core
5. Create a new zip file with the contents of BepInEx_V-Rising_1.1