//
//  File.swift
//  
//
//  Created by Yagiz Nizipli on 9/9/20.
//

#if canImport(Mixpanel)

import Mixpanel

public class MixpanelProvider : BaseProvider<Mixpanel>, AnalyticsProvider {
  public struct Options {
    var token: String
  }
  
  private let options: Options
  
  public init(_ options: Options) {
    self.options = options
    
    super.init()
  }
  
  public func setup(with properties: Properties?) {
    instance = Mixpanel.init(token: options.token,
                             launchOptions: properties,
                             flushInterval: 30,
                             trackCrashes: true,
                             automaticPushTracking: true)
  }
  
  public func flush() {
    instance.flush()
  }
  
  public func reset() {
    instance.reset()
  }
  
  public override func event(_ event: AnalyticsEvent) {
    guard let event = update(event: event) else {
      return
    }
    
    switch event.type {
    case .default, .screen, .finishTime:
      instance.track(event.name, properties: event.properties as? [String: MixpanelType])
      
      if let amount = event.properties?[Property.Purchase.price.rawValue] as? NSDecimalNumber {
        instance.people.trackCharge(amount, withProperties: event.properties as? [String : MixpanelType])
      }
    case .time:
      super.event(event)
      instance.timeEvent(event.name)
    default:
      super.event(event)
    }
    
    delegate?.providerDidSendEvent(self, event: event)
  }
  
  public func identify(userId: String, properties: Properties? = nil) {
    instance.identify(userId)
    
    if let properties = properties {
      set(properties: properties)
    }
  }
  
  public func alias(userId: String, forId: String) {
    instance.createAlias(userId, forDistinctID: forId, usePeople: true)
  }
  
  public func set(properties: Properties) {
    guard let properties = prepare(properties: properties) else {
      return
    }
    
    instance.people.set(properties)
  }
  
  public override func global(properties: Properties, overwrite: Bool) {
    guard let properties = properties as? [String : MixpanelType] else {
      return
    }
    
    if overwrite {
      instance.registerSuperProperties(properties)
    } else {
      instance.registerSuperPropertiesOnce(properties)
    }
  }
  
  public func increment(property: String, by number: NSDecimalNumber) {
    instance.people.increment(property, by: number)
  }
  
  
  public override func addDevice(token: Data) {
    instance.people.addPushDeviceToken(token)
  }
  
  // MARK: Private Methods
  
  private func prepare(properties: Properties) -> [String : MixpanelType]? {
    guard let properties = properties as? [String : MixpanelType] else {
      return nil
    }
    
    let mapping : [String : String] = [
      Property.User.email.rawValue : "$email",
      Property.User.name.rawValue : "$name",
      Property.User.lastLogin.rawValue : "$last_login",
      Property.User.created.rawValue : "$created",
      Property.User.firstName.rawValue : "$first_name",
      Property.User.lastName.rawValue : "$last_name"
    ]
    
    var finalProperties : [String : MixpanelType] = [:]
    
    for (property, value) in properties {
      if let map = mapping[property] {
        finalProperties[map] = value
      }
      else {
        finalProperties[property] = value
      }
    }
    
    return finalProperties
  }
  
  public override func push(payload: [AnyHashable : Any], event: EventName?) {
    if let event = event {
      instance.trackPushNotification(payload, event: event, properties: [:])
    }
  }
}

#endif
