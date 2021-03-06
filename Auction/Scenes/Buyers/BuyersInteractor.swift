//
//  BuyersInteractor.swift
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

protocol BuyersBusinessLogic
{
  func fetchBuyers(request: Buyers.FetchBuyers.Request)
}

protocol BuyersDataStore
{
}

class BuyersInteractor: BuyersBusinessLogic, BuyersDataStore, RealmWorkerDelegate
{
  var presenter: BuyersPresentationLogic?
  var worker: BuyersWorker?
  
  // MARK: Fetch buyers
  
  var buyers: Results<User>?
  
  func fetchBuyers(request: Buyers.FetchBuyers.Request)
  {
    RealmWorker.shared.addDelegate(delegate: self)
    refreshBuyers()
  }
  
  // MARK: Refresh buyers
  
  private func refreshBuyers()
  {
    if buyers?.realm == nil {
      if RealmWorker.shared.realm != nil {
        buyers = RealmWorker.shared.realm.objects(User.self)
      }
    }
    let response = Buyers.FetchBuyers.Response(buyers: buyers)
    presenter?.presentFetchBuyers(response: response)
  }
  
  // MARK: RealmWorkerDelegate
  
  func realmWorkerHasChanged()
  {
    refreshBuyers()
  }
}
