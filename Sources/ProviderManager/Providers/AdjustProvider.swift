//
//  File.swift
//  
//
//  Created by Yagiz Nizipli on 9/9/20.
//

#if canImport(Adjust)

import Adjust
import ProviderManager

open class AdjustProvider : BaseProvider<Adjust>, AnalyticsProvider {
  
  private let options: Options
  
  public struct Options {
    var token: String
    var environment: EnvironmentType = .sandbox
    var appSecret: AppSecret? = nil
    
    enum EnvironmentType {
      case sandbox
      case production
      
      fileprivate var original : String {
        switch self {
        case .sandbox:
          return ADJEnvironmentSandbox
        case .production:
          return ADJEnvironmentProduction
        }
      }
    }
    
    struct AppSecret {
      var secretId: UInt
      var info1: UInt
      var info2: UInt
      var info3: UInt
      var info4: UInt
    }
  }
  
  init(_ options: Options) {
    self.options = options
    super.init()
  }
  
  open func setup(with properties: Properties?) {
    let config = ADJConfig(appToken: options.token, environment: options.environment.original)
    config?.delegate = self
    
    if let appSecret = options.appSecret {
      config?.setAppSecret(appSecret.secretId, info1: appSecret.info1, info2: appSecret.info2, info3: appSecret.info3, info4: appSecret.info4)
    }
    
    instance = Adjust.getInstance() as? Adjust
    instance.appDidLaunch(config)
  }
  
  open override func activate() { }
  
  open func flush() { }
  
  open func reset() { }
  
  open override func addDevice(token: Data) {
    instance.setDeviceToken(token)
  }
  
  open override func setPushToken(token: String) {
    instance.setPushToken(token)
  }
  
  open override func event(_ event: AnalyticsEvent) {
    guard let event = update(event: event) else {
      return
    }
    
    guard let eventObject = getAdjustEvent(for: event) else {
      return
    }
    
    switch event.type {
    case .default, .finishTime, .purchase:
      instance.trackEvent(eventObject)
    default:
      super.event(event)
    }
    
    delegate?.providerDidSendEvent(self, event: event)
  }
  
  private func getAdjustEvent(for analyticsEvent: AnalyticsEvent) -> ADJEvent? {
    guard let identifier = analyticsEvent.internalId else { return nil }

    let event = ADJEvent(eventToken: identifier)
    
    if analyticsEvent.type == .purchase {
      if let price = (analyticsEvent.properties?[Property.Purchase.price.rawValue] as? NSDecimalNumber)?.doubleValue, let currency = analyticsEvent.properties?[Property.Purchase.currency.rawValue] as? String {
        event?.setRevenue(price, currency: currency)
      }
    }
    
    if let transactionId = analyticsEvent.properties?[Property.Purchase.transactionId.rawValue] as? String {
      event?.setTransactionId(transactionId)
    }
    
    return event
  }
  
  open override func update(event: AnalyticsEvent) -> AnalyticsEvent? {
    AnalyticsEvent(type: event.type, name: event.internalId ?? "", properties: event.properties)
  }
  
  public func alias(userId: String, forId: String) { }
  public func identify(userId: String, properties: Properties?) { }
  public func increment(property: String, by number: NSDecimalNumber) { }
  
  open func set(properties: Properties) {
    guard let properties = prepare(properties: properties) else {
      return
    }
    
    for (property, value) in properties {
      if let value = value as? String {
        instance.addSessionCallbackParameter(property, value: value)
      }
    }
  }
  
  private func prepare(properties: Properties?) -> Properties? {
    guard let properties = properties else {
      return nil
    }
    
    var finalProperties : Properties = [:]
    
    for (property, value) in properties {
      if value is String {
        finalProperties[property] = value
      } else {
        finalProperties[property] = String(describing: value)
      }
    }
    
    return finalProperties
  }
}

extension AdjustProvider: AdjustDelegate {
  
  public func adjustDeeplinkResponse(_ deeplink: URL?) -> Bool {
    guard let deeplink = deeplink else { return true }
    self.delegate?.providerDidReceiveDeferredDeepLinking(self, url: deeplink)
    return true
  }
}
#endif
