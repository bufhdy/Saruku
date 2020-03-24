# Saruku 

[![GitHub issues](https://img.shields.io/github/issues/bufhdy/Saruku)](https://github.com/bufhdy/Saruku/issues) [![UI frame](https://img.shields.io/badge/UI_frame-SwiftUI-yellow)](https://github.com/topics/swiftui) [![Twitter](https://img.shields.io/twitter/url?style=social&url=https%3A%2F%2Ftwitter.com%2Fbufhdy)](https://twitter.com/bufhdy)

Now at Alpha 0.1. Still in development. Use for test ONLY.

<p style="text-align: center">
    <img src="https://github.com/bufhdy/Saruku/raw/master/img/saruku-cover.png" alt="saruku-icon" />
</p>

Saruku is a macOS menu bar app that provides cool down time for SNS apps to help you focus on your current work.

For who wants to build the project yourself, you should install [LaunchAtLogin](https://github.com/sindresorhus/LaunchAtLogin) by [Carthage](https://github.com/Carthage/Carthage). Please follow their instructions before hatching your own Saruku. And there's something extra that you may modify the JSON file (`AppItemData.json`) to fit your custom apps.

## Known Issues

1. When opening a file, timer will stop for a little while. (Have got no idea how to solve. )
2. Hidden cursor not working when getting back from other apps. It'll be good after open any Saruku own window.
3. Popover won't display correctly when hidden by hidden-bar app. (So don't hide it by default?)
4. App will crush when running in the .dmg file. So please drag Saruku into the Applications folder.
5. Cannot change the colour title bar text. (Don't know how to. )
6. It'll get stuck in open panel if view mode is list. Wwhen mode is icon it's all right
7. On full screen, Saruku will be cropped.

## To-Dos

- [x] Start at login
- [ ] Shortcut
- [x] Dark mode
- [x] More joyful animations
- [ ] Languages
    - [ ] 日本語 (not complete)
    - [x] 正體中文
- [x] Notification
- [ ] Import & export
- [ ] Save JSON file

## Fonts

- English: [Acme](https://fonts.google.com/specimen/Acme) by [Huerta Tipográfica](https://www.huertatipografica.com/en)
- 正體中文: [Open 粉圓](https://justfont.com/huninn/)
- 日本語: [Kosugi Maru](https://fonts.google.com/specimen/Kosugi+Maru)
