<div align="center">
  <img width="128" height="128" src="/assets/icon.png" alt="GlowGetter Icon">
  <h1><b>GlowGetter</b></h1>
  <p>
    Add customizable Metal-powered glow effects to your SwiftUI views.
  </p>
</div>

<p align="center">
  <a href="https://swift.org"><img src="https://img.shields.io/badge/Swift-6.0+-F05138?logo=swift&logoColor=white" alt="Swift 6.0+"></a>
  <a href="https://developer.apple.com"><img src="https://img.shields.io/badge/iOS-15+-000000?logo=apple" alt="iOS 15+"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-green.svg" alt="License: MIT"></a>
  <img src="https://img.shields.io/badge/Status-Experimental-orange.svg" alt="Experimental">
</p>

> [!NOTE]
> This implementation is experimental. A [ca-filter-alt branch](https://github.com/Aeastr/GlowGetter/tree/ca-filter-alt) exists with an alternative approach that doesn't rely on an overlay.

<div align="center">
  <img src="assets/example1.jpg" alt="Example 1" width="280">
  <img src="assets/example2.jpg" alt="Example 2" width="280">
</div>


## Overview

- Single `.glow()` modifier for any SwiftUI view
- Adjustable intensity
- Optional shape clipping (Circle, RoundedRectangle, etc.)
- Metal-rendered overlay for the glow effect


## Installation

```swift
dependencies: [
    .package(url: "https://github.com/Aeastr/GlowGetter.git", from: "1.0.0")
]
```

```swift
import GlowGetter
```

Or in Xcode: **File > Add Packages…** and enter `https://github.com/Aeastr/GlowGetter`


## Usage

### Basic Glow

```swift
Color.orange
    .glow(0.8)
```

### With Shape Clipping

Clip the glow to match your view's shape:

```swift
// Circle
Color.orange
    .clipShape(Circle())
    .glow(0.8, Circle())

// Rounded rectangle
Color.orange
    .clipShape(.rect(cornerRadius: 20))
    .glow(0.8, .rect(cornerRadius: 20))
```


## How It Works

GlowGetter uses a Metal layer to produce the glow effect by blending a rendered overlay with the underlying view content. The overlay is applied via `GlowRenderView`, wrapped in the `.glow()` modifier for declarative use.

This serves as a quick way to achieve glow effects. For high-performance or production scenarios, a more robust Metal pipeline may be needed.

### Acknowledgments

Thanks to [Jordi Bruin](https://github.com/jordibruin) and [Ben Harraway](https://github.com/BenLumenDigital) for their insights on the rendering functionality. This repo adapts code built for [Vivid](https://www.getvivid.app).


## Contributing

Contributions welcome. See the [Contributing Guide](CONTRIBUTING.md) for details.


## License

MIT. See [LICENSE](LICENSE) for details.
