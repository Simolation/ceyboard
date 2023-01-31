# ceyboard

c(ognition k)eyboard to record typing metrics on an iOS device

![Slide 16_9 - 1](https://user-images.githubusercontent.com/4338202/170876325-784f6db0-c977-48f4-81d2-df5253a48d45.png)

<p align="center">
<img src="https://img.shields.io/cocoapods/p/ios" alt="Platform" />
<img src="https://img.shields.io/badge/Swift-5.5-orange.svg" alt="Swift 5.5" />
<img src="https://img.shields.io/badge/license-MIT-green" alt="MIT License" />
</p>

This repository is the official implementation of [Analysis of Mobile Typing Characteristics in the Light of Cognition](https://ieeexplore.ieee.org/document/9861089). 
Details on how to cite the paper can be found in the GitHub repo under "Cite this repository".

## Requirements and Setup

This repository is a Xcode project with an iOS Deployment Target of `15.0`.

#### 1. Clone the project

First clone the repository on your computer:

```zsh
git clone https://github.com/Simolation/ceyboard.git
```

#### 2. Open the project

Open the Xcode project, by opening the `ceyboard.xcodeproj` file in Xcode.

#### 3. Update Bundle Identifier

The repo provides an application with the Bundle Identifier used during development and trial.
In order to run it locally, a different Bundle Identifier and App Group is required.

1.  Select the project `ceyboard` in Xcode.
2.  Select the `ceyboard` Target and open the `Signing & Capabilities` tab.
    Select your Team and choose a new Bundle Identifier.
3.  As the app needs an `App Group` to communicate between the app and the keyboard, you can find a tutorial on how to set up a new App Group here: https://www.appcoda.com/app-group-macos-ios-communication/
4.  Select the created App Group in Xcode.
5.  Repeat step 2. and 4. for the `keyboard` Target.
6.  Update the Bundle Identifiers in `shared/SuiteName.swift` as they are required at runtime.

#### 4. Build and run

Build and run the app.

## App Architecture

The app is structured into three main compartments:

1. `/ceyboard/`
   The main app which provied the onboarding, the home view and the settings. This is also the app which is installed on the phone.
2. `/keyboard/`
   The keyboard package provides the custom keyboard extension built on top of the open source project [KeyboardKit](https://github.com/KeyboardKit/KeyboardKit). For more information please refer to the [KeyboardKit Docs](https://github.com/KeyboardKit/KeyboardKit#readme).
3. `/shared/`
   The shared folder contains components which are accessible by both the main app and the keyboard. The shared access is realized over an App Group.

![App Architecture](https://user-images.githubusercontent.com/4338202/170876978-05f33513-f03a-4047-8ffa-e32282aaf058.png)

The shared package primarily contains the `CoreData` database and the [`SessionTracker`](/shared/SessionTracker.swift), which tracks the performed events on the keyboard and stores them securely on the device's local database.

## Data Export

The app does not include cloud synchronization or an option to upload the data to ensure privacy.
Instead, all the tracked data is stored locally with a manual export.

The manual export can be triggered through `Settings > Export`.

The data is exported as a JSON file for easy evaluation.

<details>
<summary>The structure is as follows:</summary>

```js
{
  "gender": "male",
  "device": "iPhone13,2",
  "appVersion": "7",
  "studyId": "0",
  "birthyear": 1990,
  "exportDate": 1646644093378.6631,
  "matrix": [
    [
      // aa matrix pair
      [
        41, // frequency
        0.1970570981502533, // mean
        0.12307097762823105 // std
      ]
      // ab ...
    ]
    // ...
  ],
  "sessions": [
    {
      "started_at": 1645959020630.1279,
      "hostApp": "org.digital-medicine.ceyboard",
      "ended_at": 1645959033263.4521,
      "events": [
        {
          "created_at": 1645959028898.114,
          "action": "character"
        },
        {
          "created_at": 1645959029482.2439,
          "action": "backspace"
        },
        {
          "created_at": 1645959028682.2271,
          "action": "character"
        }
        // ...
      ]
    }
    // ...
  ]
}
```

</details>

## License

ceyboard is available under the MIT license. See the [LICENSE](LICENSE) file for more information.
