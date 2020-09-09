//
//  AnalyticsProviderDelegate.swift
//  
//
//  Created by Yagiz Nizipli on 9/9/20.
//

import Foundation

public protocol AnalyticsProviderDelegate : class {
  
  /// This method will be called on the delegate, before the event is sent. If delegate returns nil, event will be discarded.
  /// - Parameters:
  ///   - provider: Analytics provider responsible for the event.
  ///   - event: Analytics event
  func providerShouldSendEvent(_ provider: AnalyticsProvider, event: AnalyticsEvent) -> AnalyticsEvent?
  
  /// Called when provider finishes sending an event.
  /// - Parameters:
  ///   - provider: Analytics provider responsible for the event.
  ///   - event: Analytics event
  func providerDidSendEvent(_ provider: AnalyticsProvider, event: AnalyticsEvent)
  
  /// Called when provider receives deferred deep linking
  /// - Parameters:
  ///   - provider: Analytics provider responsible for the event.
  ///   - url: The url of the deep link schema
  func providerDidReceiveDeferredDeepLinking(_ provider: AnalyticsProvider, url: URL)
}

public extension AnalyticsProviderDelegate {
  func providerShouldSendEvent(_ provider: AnalyticsProvider, event: AnalyticsEvent) -> AnalyticsEvent? {
    return event
  }
  
  func providerDidSendEvent(_ provider: AnalyticsProvider, event: AnalyticsEvent) {}
  
  func providerDidReceiveDeferredDeepLinking(_ provider: AnalyticsProvider, url: URL) {}
}
