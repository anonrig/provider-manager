//
//  File.swift
//  
//
//  Created by Yagiz Nizipli on 9/9/20.
//

#if canImport(UXCam)

public class UXCamProvider : BaseProvider<UXCam>, AnalyticsProvider {
  
  private let options: Options
  
  public struct Options {
    var apiKey: String
    var optIntoSchematicRecordings: Bool = true
    var setAutomaticScreenNameTagging: Bool = false
  }
  
  public init(_ options: Options) {
    self.options = options
    super.init()
  }
  
  public func setup(with properties: Properties?) {
    if options.optIntoSchematicRecordings {
      UXCam.optIntoSchematicRecordings()
    }
    
    UXCam.setAutomaticScreenNameTagging(options.setAutomaticScreenNameTagging)
    UXCam.start(withKey: options.apiKey)
  }
  
  public override func event(_ event: AnalyticsEvent) {
    guard let event = update(event: event) else {
      return
    }
    
    switch event.type {
    case .screen:
      UXCam.tagScreenName(event.name)
    default:
      UXCam.logEvent(event.name, withProperties: event.properties)
    }
  }
  
  public func identify(userId: String, properties: Properties? = nil) {
    UXCam.setUserIdentity(userId)
    
    if let properties = properties {
      set(properties: properties)
    }
  }
  
  public func set(properties: Properties) {
    for (property, value) in properties {
      UXCam.setUserProperty(property, value: value)
    }
  }
}

extension UXCamProvider {
  
  public func flush() {}
  
  public func reset() {}
  
  public func alias(userId: String, forId: String) {}
  
  public func increment(property: String, by number: NSDecimalNumber) {}
}


#endif
