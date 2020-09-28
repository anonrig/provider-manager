# ProviderManager

Analytics provider manager for iOS. Supports Adjust, Mixpanel, Firebase, Sentry, UXCam.

## Initialization

```swift
final class AnalyticsManager {
  
  static let shared = ProviderManager()
  
  private let providers: [AnalyticsProvider] = [
    AdjustProvider(.init(token: "TOKEN",
                         environment: .sandbox,
                         appSecret: .init(secretId: 1,
                                          info1: 2,
                                          info2: 3,
                                          info3: 4,
                                          info4: 5))),
    FirebaseProvider(),
    MixpanelProvider(.init(token: "MIXPANEL TOKEN")),
    SentryProvider(.init(dsn: "DSN URL"))
  ]
  
  init() {
    providers.forEach {
      AnalyticsManager.shared.addProvider(provider: $0)
    }
  }
}
```

## Initialize Events

```swift
extension AnalyticsManager {
  
  enum Event: String {
    case pushToken
    case purchase
    
    var identifier: String? {
      switch self {
      case .purchase:
        return "PURCHASE EVENT"
      default:
        return nil
      }
    }
  }
  
  enum Screen: String {
    case today
  }
}
```

## Definitions

```swift
extension AnalyticsManager {
  
  static func track(event: Event, properties: Properties? = nil) {
    AnalyticsManager.shared.event(name: event.rawValue, properties: properties)
  }
  
  static func track(screen: Screen, properties: Properties? = nil) {
    AnalyticsManager.shared.screen(name: screen.rawValue, properties: properties)
  }
  
  static func time(event: Event, properties: Properties? = nil) {
    AnalyticsManager.shared.time(name: event.rawValue, properties: properties)
  }
  
  static func finish(event: Event, properties: Properties? = nil) {
    AnalyticsManager.shared.finish(name: event.rawValue, properties: properties)
  }
}
```

## Tracking Example

```swift
var properties = [
  Property.Purchase.currency.rawValue: purchase.product.priceLocale.currencyCode ?? "USD",
  Property.Purchase.price.rawValue: purchase.product.price,
  Property.Purchase.sku.rawValue: purchase.product.productIdentifier,
  Property.Purchase.transactionId.rawValue: purchase.originalTransaction?.transactionIdentifier
]

if let id = AnalyticsManager.Event.purchase.identifier {
  // This is required for Adjust, since Adjust depends on event identifier.
  properties[Property.identifier.rawValue] = id as Any
}

AnalyticsManager.track(event: .purchase, properties: properties)
```
