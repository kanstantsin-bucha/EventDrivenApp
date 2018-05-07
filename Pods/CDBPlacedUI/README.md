# CDBPlacedUI

Use it to place views into placeholders and implement view controllers containment in easy way.
It based on autolayout iOS technology.

[![CI Status](http://img.shields.io/travis/yocaminobien/CDBPlacedUI.svg?style=flat)](https://travis-ci.org/yocaminobien/CDBPlacedUI)
[![Version](https://img.shields.io/cocoapods/v/CDBPlacedUI.svg?style=flat)](http://cocoapods.org/pods/CDBPlacedUI)
[![License](https://img.shields.io/cocoapods/l/CDBPlacedUI.svg?style=flat)](http://cocoapods.org/pods/CDBPlacedUI)
[![Platform](https://img.shields.io/cocoapods/p/CDBPlacedUI.svg?style=flat)](http://cocoapods.org/pods/CDBPlacedUI)

## PLACEHOLDER

'UIView * view = [UIView new];

[CDBPlaceholderMaster placeUI:view
                inPlaceholder:self.view
                 usingOptions:CDBPlacedUIOptionsCentered | CDBPlacedUIOptionsEqualSize];'

## CONTAINMENT

'UIViewController * controller = [UIViewController new];
controller.view.frame = CGRectMake(0, 0, 200, 200);
[CDBContainmentMaster displayChildViewController:controller
                                     withOptions:CDBPlacedUIOptionsCentered | CDBPlacedUIOptionsConstantSize
                                          inView:redView
                                ofViewController:self];'

## TODO

* Add tests

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

CDBPlacedUI is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "CDBPlacedUI"
```

## Author

yocaminobien, yocaminobien@gmail.com

## License

CDBPlacedUI is available under the MIT license. See the LICENSE file for more info.
