//
//  File.swift
//  
//
//  Created by Yagiz Nizipli on 9/9/20.
//

import Foundation

public typealias Properties = [String : Any]
public typealias EventName = String

public struct AnalyticsEvent {
  public enum EventType {
    case `default`
    case screen
    case time
    case finishTime
    case error
  }
  
  public var type = EventType.default
  public var name : EventName
  public var properties : Properties?
  
  public init(type: EventType, name: EventName, properties: Properties? = nil) {
    self.type = type
    self.name = name
    self.properties = properties
  }
}
