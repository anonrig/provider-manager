//
//  File.swift
//  
//
//  Created by Yagiz Nizipli on 9/9/20.
//

import Foundation

public enum DefaultEvent : String {
  
  case activated              = "ProviderManagerActivated"
  
  case purchase               = "ProviderManagerEventPurchase"
  case screenView             = "ProviderManagerEventScreenView"
  case pushNotification       = "ProviderManagerEventPushNotification"
  case signUp                 = "ProviderManagerSignUp"
  case login                  = "ProviderManagerLogin"
  case viewContent            = "ProviderManagerViewContent"
  case share                  = "ProviderManagerShare"
  case search                 = "ProviderManagerSearch"
  case searchResults          = "ProviderManagerSearchResults"
  
  case spendCredits           = "ProviderManagerSpendCredits"
  case earnCredits            = "ProviderManagerEarnCredits"
  
  // Common events from Facebook SDK
  case achievedLevel          = "ProviderManagerAchievedLevel"
  case addedPaymentInfo       = "ProviderManagerAddedPaymentInfo"
  case addedToCart            = "ProviderManagerAddedToCart"
  case addedToWishlist        = "ProviderManagerAddedToWishlist"
  case completedRegistration  = "ProviderManagerCompletedRegistration"
  
  case completedTutorial      = "ProviderManagerCompletedTutorial"
  case initiatedCheckout      = "ProviderManagerInitiatedCheckout"
  case rating                 = "ProviderManagerRating"
  
  case unlockedAchievement    = "ProviderManagerUnlockedAchievement"
  
  case contact                = "ProviderManagerContact"
  case customizeProduct       = "ProviderManagerCustomizeProduct"
  case donate                 = "ProviderManagerDonate"
  case findLocation           = "ProviderManagerFindLocation"
  case schedule               = "ProviderManagerSchedule"
  
  case startTrial             = "ProviderManagerStartTrial"
  case submitApplication      = "ProviderManagerSubmitApplication"
  case subscribe              = "ProviderManagerSubscribe"
  case subscriptionHeartbeat  = "ProviderManagerSubscriptionHeartbeat"
  case adImpression           = "ProviderManagerAdImpression"
  case adClick                = "ProviderManagerAdClick"
  
  // Common events from Firebase SDK
  case checkoutProgress       = "ProviderManagerCheckoutProgress"
  case campaignEvent          = "ProviderManagerCampaignEvent"
  
  case generateLead           = "ProviderManagerGenerateLead"
  case joinGroup              = "ProviderManagerJoinGroup"
  case levelUp                = "ProviderManagerLevelUp"
  case postScore              = "ProviderManagerPostScore"
  case presentOffer           = "ProviderManagerPresentOffer"
  case refund                 = "ProviderManagerRefund"
  case removeFromCart         = "ProviderManagerRemoveFromCart"
  case checkoutOption         = "ProviderManagerCheckoutOption"
  
  case viewItem               = "ProviderManagerViewItem"
  case viewItemList           = "ProviderManagerViewItemList"
  
  
}

public extension DefaultEvent {
  
  func event() -> AnalyticsEvent {
    return AnalyticsEvent(type: .default, name: rawValue, properties: nil)
  }
}
