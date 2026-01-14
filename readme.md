<div align="center">
  <img width="128" height="128" src="/assets/icon.png" alt="GlowGetter Icon">
  <h1><b>GlowGetter</b></h1>
  <p>
    Add customizable glow effects to your SwiftUI views.
  </p>
</div>

<p align="center">
  <a href="https://swift.org"><img src="https://img.shields.io/badge/Swift-6.0+-F05138?logo=swift&logoColor=white" alt="Swift 6.0+"></a>
  <a href="https://developer.apple.com"><img src="https://img.shields.io/badge/iOS-15+-000000?logo=apple" alt="iOS 15+"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-green.svg" alt="License: MIT"></a>
  <img src="https://img.shields.io/badge/Status-Experimental-orange.svg" alt="Experimental">
</p>

<div align="center">
  <img src="assets/example1.jpg" alt="Example 1" width="280">
  <img src="assets/example2.jpg" alt="Example 2" width="280">
</div>


## Overview

GlowGetter provides two implementations for adding glow effects:

| Target | API | App Store Safe | Method |
|--------|-----|----------------|--------|
| `GlowGetter` | Public | Yes | Metal-rendered overlay |
| `GlowGetterPrivate` | Private | No | CAFilter EDR (true HDR brightness) |


## Installation

```swift
dependencies: [
    .package(url: "https://github.com/Aeastr/GlowGetter.git", from: "2.0.0")
]
```

Add the target you need:

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "GlowGetter", package: "GlowGetter"),
        // OR
        .product(name: "GlowGetterPrivate", package: "GlowGetter")
    ]
)
```


## Usage

### GlowGetter (Public API)

Metal-powered overlay effect. Safe for App Store.

```swift
import GlowGetter

// Basic glow
Color.orange
    .glow(0.8)

// With shape clipping
Color.orange
    .clipShape(Circle())
    .glow(0.8, Circle())
```

### GlowGetterPrivate (Private API)

> [!WARNING]
> Uses private `CAFilter` APIs. May be rejected by App Store review, may break in future iOS updates. We are not responsible for any consequences of using this in your applications. **Use at your own risk.**

True HDR brightness using the `edrGainMultiply` filter. Only visible on HDR-capable displays.

```swift
import GlowGetterPrivate

// EDR glow (values typically 2.0-10.0)
Color.orange
    .glowEDR(4.0)
```

To preview: Use **My Mac | Mac Catalyst** if your Mac supports HDR—simulators won't show the effect.


## How It Works

### GlowGetter (Public)

Uses a Metal layer to render a glow overlay blended with the underlying view. The overlay is applied via `GlowRenderView` wrapped in the `.glow()` modifier.

### GlowGetterPrivate (Private)

Wraps the view in a `UIViewRepresentable` and applies CAFilter's `edrGainMultiply` to the layer. Private API strings are obfuscated at compile-time using [Obfuscate](https://github.com/Aeastr/Obfuscate).


## Acknowledgments

**GlowGetter (Public):** Thanks to [Jordi Bruin](https://github.com/jordibruin) and [Ben Harraway](https://github.com/BenLumenDigital) for their insights on the Metal rendering. Adapts code built for [Vivid](https://www.getvivid.app).

**GlowGetterPrivate:** Thanks to [Seb Vidal](https://github.com/sebjvidal) for the CAFilter implementation.


## Contributing

Contributions welcome. See the [Contributing Guide](CONTRIBUTING.md) for details.


## License

MIT. See [LICENSE](LICENSE) for details.
