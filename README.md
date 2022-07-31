<h2>Lighter Test Suite
  <img src="https://zeezide.com/img/lighter/Lighter256.png"
       align="right" width="64" height="64" />
</h2>

A test suite for Lighter.

This is in a separate package for two reasons:
- If the code generation fails, the code generator itself can't build anymore
  (w/o switching themes and stuff).
- to keep the Lighter download smaller, as this may contain bigger test
  databases.

It actually seems to require Swift 5.7 to get the plugin lookup in dependencies
to work (either on macOS commandline or in Xcode).


### Who

Lighter is brought to you by
[Helge Heß](https://github.com/helje5/) / [ZeeZide](https://zeezide.de).
We like feedback, GitHub stars, cool contract work, 
presumably any form of praise you can think of.

**Want to support my work**?
Buy an app:
[Past for iChat](https://apps.apple.com/us/app/past-for-ichat/id1554897185),
[SVG Shaper](https://apps.apple.com/us/app/svg-shaper-for-swiftui/id1566140414),
[Shrugs](https://shrugs.app/),
[HMScriptEditor](https://apps.apple.com/us/app/hmscripteditor/id1483239744).
You don't have to use it! 😀
