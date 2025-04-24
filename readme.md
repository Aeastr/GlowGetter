<div align="center">
  <img width="300" height="300" src="/assets/icon.png" alt="GlowGetter Logo">
  <h1><b>GlowGetter</b></h1>
  <p>
    An experimental Swift package for adding an HDR-like glow effect
    to SwiftUI views using private Core Animation filters.
    <br>
    <i>Compatible with iOS 15.0+</i>
  </p>
</div>

<div align="center">
  <a href="https://swift.org">
    <img src="https://img.shields.io/badge/Swift-6.0-orange.svg" alt="Swift Version">
  </a>
  <a href="https://www.apple.com/ios/">
    <img src="https://img.shields.io/badge/Platform-iOS%2015%2B%20%7C%20-blue.svg" alt="Platform">
  </a>
  <a href="LICENSE">
    <img src="https://img.shields.io/badge/License-MIT-green.svg" alt="License: MIT">
  </a>
</div>


---

## **Overview: Experimental HDR Glow via Private `CAFilter`**

This package provides a SwiftUI modifier (`.glow`) that applies an HDR-like glow effect by leveraging a **private** Core Animation filter (`CAFilter(type: "edrGainMultiply")`).

> ## ⚠️ **Warning: Private API Usage & Risks** ⚠️
>
> *   **App Store Rejection:** Apps using private APIs like `CAFilter` **may be rejected** during the App Store review process. This package is may not be suitable for apps intended for App Store distribution.
> *   **API Instability:** Private APIs are undocumented, unsupported, and can change or be removed by Apple without warning in any OS update, potentially breaking your code.
> *   **Obfuscation is Not a Guarantee:** While the private API strings within this package are obfuscated (using Base64 encoding) to hinder basic static analysis, this **does not prevent detection** by Apple's review process or guarantee future compatibility.
>
> **Developers choosing this package must understand and accept these significant risks.** If you need a production-ready, App Store-safe solution, explore alternatives using public APIs in the main branch (like Metal shaders).

This implementation directly manipulates the layer's rendering via the filter, aiming to increase the perceived brightness of the view's content, pushing colors into the Extended Dynamic Range (EDR) on compatible displays.

---

### **Example Visual (Conceptual)**

*(Note: Static images cannot fully represent HDR effects. Test on a compatible device.)*

Imagine applying the modifier to a bright element:

```swift
struct GlowExample: View {
    var body: some View {
        Image(systemName: "sun.max.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 100)
            .foregroundStyle(.yellow) // A bright base color works best
            // Apply the glow with significant intensity for HDR effect
            .glow(5.0)
    }
}
```

On an HDR display, the yellow sun icon would appear significantly brighter than standard UI elements, creating a distinct "glow."

---

## **Installation**

### Swift Package Manager

1.  In Xcode, navigate to **File > Add Packages...**
2.  Enter the repository URL:
    `https://github.com/Aeastr/GlowGetter`
3.  Select the desired branch/version and add the package.

---

## **Key Components**

*   **`.glow(_ intensity:)` (Public Modifier):**
    The primary SwiftUI `View` extension modifier used to apply the effect. Takes an `intensity` parameter to control the brightness boost.
*   **`FilteredViewRepresentable` (Internal):**
    A private `UIViewRepresentable` that wraps the target SwiftUI view, hosts it in a `UIHostingController`, and applies the `CAFilter` to the underlying `UIView`'s layer.
*   **Obfuscation Helpers (Internal):**
    Internal functions and structures used to decode Base64 strings at runtime, avoiding direct embedding of private API string literals in the source code.

---

## **Basic Usage**

Import the package and apply the `.glowWithObfuscatedFilter` modifier to your SwiftUI view.

```swift
import SwiftUI
import GlowGetter // Make sure to import the package

struct ContentView: View {
    @State private var glowIntensity: Double = 4.0

    var body: some View {
        VStack {
            Text("Standard Text")

            Circle()
                .fill(.white)
                .frame(width: 100, height: 100)
                // Apply the glow effect
                .glow(glowIntensity)

            Slider(value: $glowIntensity, in: 1.0...10.0) {
                Text("Glow Intensity")
            }
            .padding()
        }
        // Ensure the environment supports HDR display if possible
        // .environment(\.colorScheme, .dark) // Often helps
    }
}
```

**Parameters:**

*   `_ intensity`: `Double` (Default: `1.0`). A multiplier for the view's brightness. Values greater than `1.0` push the view into the EDR range on compatible displays. Experiment with values like `2.0` to `10.0` or higher.

---

## **How It Works**

1.  The `.glow` modifier wraps your SwiftUI `View` content within the internal `FilteredViewRepresentable`.
2.  `FilteredViewRepresentable` creates a `UIHostingController` to render the SwiftUI `View` into a standard `UIView`.
3.  It retrieves the necessary private API strings (like `"CAFilter"`, `"filterWithType:"`, `"edrGainMultiply"`, `"inputScale"`) by decoding embedded Base64 strings at runtime.
4.  Using these decoded strings, it dynamically creates an instance of the private `CAFilter` configured for the `edrGainMultiply` type.
5.  This filter is then added to the `filters` array of the `UIView`'s `layer`.
6.  The `intensity` parameter provided to the modifier is set as the `inputScale` value on the `CAFilter`, controlling the strength of the brightness multiplication effect.
7.  The `UIViewRepresentable` manages the view lifecycle and updates the filter's intensity when the state changes.

> This mechanism directly hooks into Core Animation's rendering pipeline via unsupported means. It offers a potentially simpler way to achieve an EDR effect compared to complex custom Metal shaders but comes with significant risks and limitations.

---

## **Acknowledgments**

This project benefited from the insights, code, or inspiration provided by the following individuals or projects:

Special thanks to the broader Swift and iOS development communities for sharing knowledge and pushing boundaries.

---

## **License**

GlowGetter is available under the MIT license. See the [LICENSE](LICENSE) file for more information.
