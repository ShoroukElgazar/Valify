# Valify

**Valify** is a simple framework to capture photos.

![swift v5.3](https://img.shields.io/badge/swift-v5.3-orange.svg)
![iOS 13](https://img.shields.io/badge/iOS-13.0+-865EFC.svg)
![macOS](https://img.shields.io/badge/macOS-10.15+-179AC8.svg)
![tvOS](https://img.shields.io/badge/tvOS-13.0+-41465B.svg)
![License](https://img.shields.io/badge/License-Apache-blue.svg)

---

# Table of contents

- [Preview](#preview)
- [Installation](#installation)
- [Demo](#demo)
- [License](#license)

---

## Installation

### Xcode Projects

Select `File` -> `Swift Packages` -> `Add Package Dependency` and enter `https://github.com/ShoroukElgazar/Valify.git`.



Then simply `import Valify` wherever you’d like to use the library.

---

## :zap: Usage
1. Import `Valify`.

```swift
import Valify
```

2. Create an object of `CameraNavigationViewController`

```swift
 var vc = CameraNavigationViewController()
```
3. In the closure that returns from vc it will return image and error, assign image to your imageView and handle the error then present vc:

```swift
     vc.modalPresentationStyle = .fullScreen
        
            vc.onCompleted = { [weak self] image, error in
                if let capturedImage = image {
                    self?.imageView.image = capturedImage
                } else if let error = error {
                    print("Error: \(error)")
                            }
                        }
        
            present(vc, animated: true, completion: nil)
```
---

## :clap: Contribution

- PRs are welcome, let's make this library better. :raised_hands:

- Please :star: if you like the idea!

## License

**Apache License**, Version 2.0

<details>
<summary>
click to reveal License
</summary>

```txt
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

https://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

</details>

