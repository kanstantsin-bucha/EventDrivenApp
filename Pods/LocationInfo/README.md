# LocationInfo

[![CI Status](http://img.shields.io/travis/truebucha/LocationInfo.svg?style=flat)](https://travis-ci.org/truebucha/LocationInfo)
[![Version](https://img.shields.io/cocoapods/v/LocationInfo.svg?style=flat)](http://cocoapods.org/pods/LocationInfo)
[![License](https://img.shields.io/cocoapods/l/LocationInfo.svg?style=flat)](http://cocoapods.org/pods/LocationInfo)
[![Platform](https://img.shields.io/cocoapods/p/LocationInfo.svg?style=flat)](http://cocoapods.org/pods/LocationInfo)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.
```ObjC
QMLocationInfo * info = [QMLocationInfo locationInfoUsingSublocation: @""
                                        city: @""
                                        state: @""
                                        country: @""
                                        countryCode: @""
                                        location: nil];

[QMLocationInfoAppleConvertion locationInfoUsingPlacemark: [CLPlacemark new]];
[QMLocationInfoLuongConvertion locationInfoUsingAddress: [LMAddress new]];
[QMLocationAnnotation annotationUsing: info];
```

## Requirements

## Installation

LocationInfo is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'LocationInfo'
```

## Author

truebucha, truebucha@gmail.com

## License

LocationInfo is available under the MIT license. See the LICENSE file for more info.
