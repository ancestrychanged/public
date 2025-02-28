# inertial movement units test  
a simple script to test device motion inputs and display inertial measurements in real time; a module is included to detect the current platform (either pc, mobile, or console)

## overview  
this script uses the device's Gyroscope and Accelerometer data to compute motion changes

it smooths out rapid fluctuations with a low-pass filter and then identifies the dominant movement direction—making it perfect for quick testing of motion input on mobile devices; the module `GetPlatformChanceBased` confirms the script only runs on mobile, or any other device that supports a Gyroscope or an Accelerometer

## scripts
- **main script (`a localscript`)**:  
  - there are several configuration parameters such as `updateInterval`, `clampThreshold`, and multipliers for pitch, yaw, and roll;
     - you can change them however you like 
  - captures input from the units via a .RenderStepped event from `RunService`
  - reads gyroscope data by converting a `CFrame` into radians, applies a smoothing filter, and then calculates effective rotation differences;  
  - determines the dominant axis (pitch, yaw, or roll) and updates a display element with a status (for example, "Pitch Down" or "Stationary");
  - processes accelerometer data similarly by clamping values and identifying the dominant acceleration direction;  
  - outputs a detailed text summary of both gyroscope and accelerometer readings in a TextLabel that's inside the `.rbxl` file  

- **platform detection module (`GetPlatformChanceBased`)**:  
  - checks input sources like mouse, keyboard, touch, and gamepad;  
  - calculates a simple "chance" value for pc, mobile, and console based on available inputs;  
  - returns the most likely platform which, in this case, is used to ensure that the main script only runs on mobile devices

## usage examples  
- a racing game 
- "shake ur phone to do something"
- imagination is your friend 
