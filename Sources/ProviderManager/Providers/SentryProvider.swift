//
//  File.swift
//  
//
//  Created by Yagiz Nizipli on 9/9/20.
//

#if canImport(Sentry)
import Sentry

public class SentryProvider : BaseProvider<SentrySDK>, AnalyticsProvider {
  private let options: Options
  
  public struct Options {
    var dsn: String
    var debug: Bool = false
    var enableAutoSessionTracking: Bool = true
  }
  
  public init(_ options: Options) {
    self.options = options
    super.init()
  }
  
  public func setup(with properties: Properties?) {
    SentrySDK.start(options: [
      "dsn": options.dsn,
      "debug": options.debug,
      "enableAutoSessionTracking": options.enableAutoSessionTracking
    ])
  }
  
  public override func event(_ event: FruitAnalyticsEvent) {
    guard let event = update(event: event) else {
      return
    }
    
    if event.type == .error {
      if let error = event.properties?.first(where: { $0.key == Property.ExceptionHandler.error.rawValue })?.value as? Error {
        SentrySDK.capture(error: error)
      }
    }
  }
  
  public override func update(event: FruitAnalyticsEvent) -> FruitAnalyticsEvent? {
    guard (event.properties?.keys.contains(Property.ExceptionHandler.error.rawValue)) != nil  else { return nil }
    return event
  }
  
  public func identify(userId: String, properties: Properties? = nil) {
    SentrySDK.setUser(.init(userId: userId))
  }
}

#endif
