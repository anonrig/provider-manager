//
//  File.swift
//  
//
//  Created by Yagiz Nizipli on 9/9/20.
//

#if canImport(Mixpanel)
import Mixpanel

public class MixpanelProvider : BaseProvider<MixpanelInstance>, AnalyticsProvider {
  public struct Options {
    var token: String
  }
  
  private let options: Options
  
  public init(_ options: Options) {
    self.options = options
    
    super.init()
  }
  
  public func setup(with properties: Properties?) {
    instance = Mixpanel.initialize(token: options.token)
  }
  
  public func flush() {
    instance.flush()
  }
  
  public func reset() {
    instance.reset()
  }
  
  public override func event(_ event: FruitAnalyticsEvent) {
    guard let event = update(event: event) else {
      return
    }
    
    switch event.type {
    case .default, .screen, .finishTime:
      instance.track(event: event.name, properties: event.properties as? [String : MixpanelType])
    case .time:
      super.event(event)
      instance.time(event: event.name)
    case .purchase:
      guard let amount = event.properties?[Property.Purchase.price.rawValue] as? NSDecimalNumber else {
        return
      }
      instance.track(event: event.name, properties: event.properties as? [String: MixpanelType])
      instance.people.trackCharge(amount: amount.doubleValue, properties: event.properties as? [String : MixpanelType])
    default:
      super.event(event)
    }
    
    delegate?.analyticsProviderDidSendEvent(self, event: event)
  }
  
  public func identify(userId: String, properties: Properties? = nil) {
    instance.identify(distinctId: userId)
    
    if let properties = properties {
      set(properties: properties)
    }
  }
  
  public func alias(userId: String, forId: String) {
    instance.createAlias(userId, distinctId: forId)
  }
  
  public func set(properties: Properties) {
    guard let properties = prepare(properties: properties) else {
      return
    }
    
    instance.people.set(properties: properties)
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
    instance.people.increment(property: property, by: number.doubleValue)
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
  
  public func push(payload: [AnyHashable : Any], event: EventName?) {
    instance.trackPushNotification(payload, event)
  }
}
#endif
