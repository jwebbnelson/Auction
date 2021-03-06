//
//  TableViewController.swift
//  Auction
//
//  Created by Raymond Law on 1/20/18.
//  Copyright (c) 2018 Clean Swift LLC. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import RealmSwift

protocol TableDisplayLogic: class
{
  func displayFetchedObjects(viewModel: Table.FetchObjects.ViewModel)
}

class TableViewController: UITableViewController, TableDisplayLogic
{
  var interactor: TableBusinessLogic?
  var router: (NSObjectProtocol & TableRoutingLogic & TableDataPassing)?

  // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
  {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Setup
  
  private func setup()
  {
    let viewController = self
    let interactor = TableInteractor()
    let presenter = TablePresenter()
    let router = TableRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  // MARK: Routing
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if let scene = segue.identifier {
      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
      if let router = router, router.responds(to: selector) {
        router.perform(selector, with: segue)
      }
    }
  }
  
  // MARK: View lifecycle
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    registerTableViewCells()
    fetchObjects()
  }
  
  // MARK: Table view
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return displayedObjects.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {
    switch interactor?.displayable {
    case .some(.items), .none:
      return configureItemCell(forRowAt: indexPath)
    case .some(.buyers):
      return configureBuyerCell(forRowAt: indexPath)
    case .some(.sellers):
      return configureSellerCell(forRowAt: indexPath)
    }
  }
  
  private func registerTableViewCells()
  {
    let itemCellNib = UINib(nibName: "ItemCell", bundle: nil)
    tableView.register(itemCellNib, forCellReuseIdentifier: "ItemCell")
    let buyerCellNib = UINib(nibName: "BuyerCell", bundle: nil)
    tableView.register(buyerCellNib, forCellReuseIdentifier: "BuyerCell")
    let sellerCellNib = UINib(nibName: "SellerCell", bundle: nil)
    tableView.register(sellerCellNib, forCellReuseIdentifier: "SellerCell")
  }
  
  private func configureItemCell(forRowAt indexPath: IndexPath) -> ItemCell
  {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
    cell.item = displayedObjects[indexPath.row] as! Table.FetchObjects.ViewModel.DisplayedItem
    return cell
  }
  
  private func configureBuyerCell(forRowAt indexPath: IndexPath) -> BuyerCell
  {
    let cell = tableView.dequeueReusableCell(withIdentifier: "BuyerCell", for: indexPath) as! BuyerCell
    cell.buyer = displayedObjects[indexPath.row] as! Table.FetchObjects.ViewModel.DisplayedBuyer
    return cell
  }

  private func configureSellerCell(forRowAt indexPath: IndexPath) -> SellerCell
  {
    let cell = tableView.dequeueReusableCell(withIdentifier: "SellerCell", for: indexPath) as! SellerCell
    cell.seller = displayedObjects[indexPath.row] as! Table.FetchObjects.ViewModel.DisplayedSeller
    return cell
  }
  
  // MARK: Fetch objects
  
  @IBOutlet weak var segmentedControl: UISegmentedControl!
  
  @IBAction func segmentedControlValueChanged(_ sender: Any)
  {
    fetchObjects()
  }
  
  var displayedObjects = [DisplayedObject]()
  
  func fetchObjects()
  {
    let displayable = Table.Displayable(rawValue: segmentedControl.selectedSegmentIndex)!
    let request = Table.FetchObjects.Request(displayable: displayable)
    interactor?.fetchObjects(request: request)
  }
  
  func displayFetchedObjects(viewModel: Table.FetchObjects.ViewModel)
  {
    displayedObjects = viewModel.displayedObjects
    tableView.reloadData()
  }
}
