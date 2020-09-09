//
//  BaseProvider.swift
//  
//
//  Created by Yagiz Nizipli on 9/9/20.
//

import Foundation

///
/// Provider generic class
///
/// Analytics provider generic class provides some common analytics functionality.
///
open class BaseProvider <T> : NSObject {
  
  // Stores global properties
  private var globalProperties : Properties?
  
  // Delegate
  public weak var delegate : AnalyticsProviderDelegate?
  
  open var events : [EventName : Date] = [:]
  open var properties : [EventName : Properties] = [:]
  
  open var instance : T! = nil
  
  public override init () {
    super.init()
  }
  
  /// On application activate
  open func activate() {}
  
  /// On application resign
  open func resign() {}
  
  /// Captures event
  /// - Parameter event: Event triggered
  open func event(_ event: AnalyticsEvent) {
    switch event.type {
    case .time:
      events[event.name] = Date()
      
      if let properties = event.properties {
        self.properties[event.name] = properties
      }
    case .finishTime:
      
      var properties = event.properties
      
      if properties == nil {
        properties = [:]
      }
      
      if let time = events[event.name] {
        properties![Property.time.rawValue] = time.timeIntervalSinceNow as AnyObject?
      }
    default:
      //
      // A Generic Provider has no way to know how to send events.
      //
      assert(false)
    }
  }
  
  open func update(event: AnalyticsEvent) -> AnalyticsEvent? {
    if let delegate = delegate, let selfProvider = self as? AnalyticsProvider {
      return delegate.providerShouldSendEvent(selfProvider, event: event)
    }
    else {
      return event
    }
  }
  
  open func global(properties: Properties, overwrite: Bool = true) {
    globalProperties = mergeGlobal(properties: properties, overwrite: overwrite)
  }
  
  
  /// Captures device token
  /// - Parameter token: Device token gathered from AppDelegate
  open func addDevice(token: Data) {
    // No device token feature
  }
  
  /// Captures push notification token
  /// - Parameter token: Push notification token
  open func setPushToken(token: String) {
    // No push feature
  }
  
  /// Captures push notifications
  /// - Parameters:
  ///   - payload: Push Notification payload
  ///   - event: Push notification event
  open func push(payload: [AnyHashable : Any], event: EventName?) {
    // No push logging feature, so we log a default event
    
    let properties : Properties? = (payload as? Properties) ?? nil
    
    let defaultEvent = AnalyticsEvent(type: .default, name: DefaultEvent.pushNotification.rawValue, properties: properties)
    
    self.event(defaultEvent)
  }
  
  public func mergeGlobal(properties: Properties?, overwrite: Bool) -> Properties {
    var final : Properties = globalProperties ?? [:]
    
    if let properties = properties {
      for (property, value) in properties {
        if final[property] == nil || overwrite == true {
          final[property] = value
        }
      }
    }
    
    return final
  }
}

