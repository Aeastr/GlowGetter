# Contributing to GlowGetter

## Code of Conduct

Please read and follow the [Code of Conduct](./CODE_OF_CONDUCT.md). I’m committed to fostering an open, welcoming, and respectful community.

## How to Report Issues

Before opening a new issue, search existing issues to avoid duplicates. When filing a bug report, please include:
- GlowGetter version (e.g. `1.0.0`) and your Swift/Xcode versions  
- Target platform (iOS 15.0+), device or simulator  
- A concise description of the problem and steps to reproduce  
- Minimal code snippet or sample project demonstrating the issue  
- Any relevant console logs or screenshots

## How to Propose Features

If you have an idea for a new feature or enhancement:
1. Search existing feature requests or discuss in Slack/Discord.  
2. Open a new “Feature Request” issue with:
   - A clear problem statement  
   - Proposed API or usage sketch  
   - Any design or UX considerations  

## Getting Started

1. Fork the repo and clone locally:
   ```bash
   git clone https://github.com/aeastr/GlowGetter.git
   cd GlowGetter
   ```
2. Create a feature branch:
   ```bash
   git checkout -b feat/my-new-feature
   ```
3. Make your changes. 

4. Commit with a clear message:
   ```
   feat: improve methods
   ```

5. Push and open a Pull Request against `main`.

## Development Setup

- Xcode 15 or later  
- iOS 15.0+ deployment target  
- Clone & open `GlowGetter.xcodeproj` or use the Swift Package in your own project

## Coding Guidelines

- Use idiomatic Swift & SwiftUI conventions  
- Structure code for readability and reuse  
- Keep public APIs minimal and well-documented  
- If you introduce new API, add samples under `Sources/GlowGetter/Examples`  
- Format your code with `swift-format` or Xcode’s built-in formatter  
- Write unit tests _where applicable_

## Documentation

- **ReadMe** - update installation, usage, and examples sections as needed  
- Add or update screenshots/GIFs under `docs/images` with descriptive filenames

## Pull Request Process

1. Link your PR to the relevant issue (if there is one)  
2. Describe what you’ve changed and why  
3. Keep PRs focused—one feature or fix per PR  
4. Ensure all examples build and run without warnings or errors  
5. Be responsive to review feedback

## Continuous Integration

All PRs are validated by CI:
- Build on latest Xcode  
- Run example targets  
- Lint documentation links

Please address any CI failures before merging.

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for helping make GlowGetter even more magical! 🚀
