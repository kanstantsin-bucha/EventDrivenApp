# QMGeocoder

[![CI Status](http://img.shields.io/travis/truebucha/QMGeocoder.svg?style=flat)](https://travis-ci.org/truebucha/QMGeocoder)
[![Version](https://img.shields.io/cocoapods/v/QMGeocoder.svg?style=flat)](http://cocoapods.org/pods/QMGeocoder)
[![License](https://img.shields.io/cocoapods/l/QMGeocoder.svg?style=flat)](http://cocoapods.org/pods/QMGeocoder)
[![Platform](https://img.shields.io/cocoapods/p/QMGeocoder.svg?style=flat)](http://cocoapods.org/pods/QMGeocoder)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

you could place google API key inside info.plist file at ["google"]["GeocoderApiKey"]
```ruby
    <key>Google</key>
    <dict>
    <key>GeocoderApiKey</key>
    <string>ApiKeyStringHere</string>
    </dict>
```
```ObjC
[QMGeocoder.shared geocodeAddress: address
                            using: QMGeocoderServiceApple
                       completion: ^(QMLocationInfo * _Nullable appleInfo, NSError * _Nullable error) {
    NSLog(@"Apple: %@", appleInfo);
}];

[QMGeocoder.shared geocodeAddress: address
                            using: QMGeocoderServiceGoogle
                       completion: ^(QMLocationInfo * _Nullable googleInfo, NSError * _Nullable error) {
    NSLog(@"Google: %@", googleInfo);
}];
```
## Requirements

## Installation

QMGeocoder is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'QMGeocoder'
```

## Author

truebucha, truebucha@gmail.com

## License

QMGeocoder is available under the MIT license. See the LICENSE file for more info.
