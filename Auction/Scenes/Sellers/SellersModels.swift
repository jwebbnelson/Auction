//
//  SellersModels.swift
//  Auction
//
//  Created by Raymond Law on 1/17/18.
//  Copyright (c) 2018 Clean Swift LLC. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import RealmSwift

enum Sellers
{
  // MARK: Use cases
  
  enum FetchSellers
  {
    struct Request
    {
    }
    struct Response
    {
      var sellers: Results<User>?
    }
    struct ViewModel
    {
      struct DisplayedSeller
      {
        var name: String
        var email: String
      }
      var displayedSellers: [DisplayedSeller]
    }
  }
}
