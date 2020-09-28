//
//  File.swift
//  
//
//  Created by Yagiz Nizipli on 9/9/20.
//

import Foundation

public protocol AnalyticsProvider {
  //
  // MARK: Delegate
  //
  var delegate : AnalyticsProviderDelegate? { get set }
  
  //
  // MARK: Common Methods
  //
  
  /*!
   Prepares analytical provider with selected properities and initializes all systems.
   
   - parameter properties: properties of analytics.
   */
  func setup(with properties: Properties?)
  
  /*!
   Should be called when app is becomes active.
   */
  func activate()
  
  /*!
   Should be called when app resigns active.
   */
  func resign()
  
  /*!
   Manually force the current loaded events to be dispatched.
   */
  func flush()
  
  /*!
   Resets all user data.
   */
  func reset()
  
  //
  // MARK: Tracking
  //
  
  /// Logs a specific event to analytics.
  /// - Parameter event: Event struct
  func event(_ event: AnalyticsEvent)
  
  //
  // MARK: User Tracking
  //
  
  /*!
   Identify an user with analytics. Do this as soon as user is known.
   
   - parameter userId:      user id
   - parameter properties:  different traits and properties
   */
  func identify(userId: String, properties: Properties?)
  
  /*!
   Connect the existing anonymous user with the alias (for example, after user signs up),
   and he was using the app anonymously before. This is used to connect the registered user
   to the dynamically generated ID it was given before. Identify will be called automatically.
   
   - parameter userId: user
   */
  func alias(userId: String, forId: String)
  
  /*!
   Sets properties to currently identified user.
   
   - parameter properties: properties
   */
  func set(properties: Properties)
  
  /*!
   Sets global properties to be sent on all events.
   
   - parameter properties: properties
   - paramater overwrite:  if properties should be overwritten, if previously set.
   */
  func global(properties: Properties, overwrite: Bool)
  
  /*!
   Increments currently set property by a number.
   
   - parameter property: property to increment
   - parameter number:   number to incrememt by
   */
  func increment(property: String, by number: NSDecimalNumber)
  
  /*!
   Add device token to the provider for push notification support.
   
   - parameter token: token
   */
  func addDevice(token: Data)
  
  /// Set push token gathered from AppDelegate
  /// - Parameter token: Push token string
  func setPushToken(token: String)
  
  /// Log push notification to the provider.
  /// - Parameters:
  ///   - payload: push notification payload
  ///   - event: action of the push
  func push(payload: [AnyHashable : Any], event: EventName?)
}

/*!
 *  Convenience extensions
 */
public extension AnalyticsProvider {
  
  func error(error: Error) {
    event(AnalyticsEvent(type: .error, name: "CaughtError", properties: [
      Property.ExceptionHandler.error.rawValue: error
    ]))
  }
  
  func event(_ defaultEvent: DefaultEvent, properties: Properties? = nil, internalId: String? = nil) {
    event(name: defaultEvent.rawValue, properties: properties, internalId: internalId)
  }
  
  func event(name: EventName, properties: Properties? = nil, internalId: String? = nil) {
    event(AnalyticsEvent(type: .default, name: name, properties: properties, internalId: internalId))
  }
  
  func screen(name: EventName, properties: Properties? = nil) {
    event(AnalyticsEvent(type: .screen, name: name, properties: properties))
  }
  
  func time(name: EventName, properties: Properties? = nil) {
    event(AnalyticsEvent(type: .time, name: name, properties: properties))
  }
  
  func finish(name: EventName, properties: Properties? = nil) {
    event(AnalyticsEvent(type: .finishTime, name: name, properties: properties))
  }
}
