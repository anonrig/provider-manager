//
//  File.swift
//  
//
//  Created by Yagiz Nizipli on 9/9/20.
//

import Foundation

public enum Property : String {
  case identifier
  
  case type
  case time
  case success
  
  case startDate
  case endDate
  case term
  case value
  
  public enum Launch : String {
    case application
    case options = "launchOptions"
  }
  
  public enum Purchase : String {
    case identifier
    
    case category
    case affiliation
    case country
    case currency
    case item
    case price
    case sku
    case shipping
    case quantity
    case tax
    case transactionId
    
    case paymentInfoAvailable
    
    case networkClick
    case campaign
    case step
    case option
    case campaignContent
    case coupon
    case brand
    case variant
    case itemList
    case medium
    case source
    case virtualCurrency
    
    case receipt
  }
  
  // Achievements, content, scores
  public enum Content : String {
    case identifier
    case type
    case description
    case maxRating
    case character
    case score
    
    case searchTerm
  }
  
  public enum User : String {
    case age
    case gender
    case type = "userType"
    case email
    case name
    case firstName
    case lastName
    case lastLogin
    case created
    
    case level
    case registrationMethod
  }
  
  public enum Location : String {
    case origin
    case destination
    case flightNumber
  }
  
  public enum ExceptionHandler: String {
    case error = "error"
  }
}

public enum Value : String {
  case yes
  case no
}
