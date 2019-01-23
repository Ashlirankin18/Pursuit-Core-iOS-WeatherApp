//
//  FavoritesViewController.swift
//  WeatherApp
//
//  Created by Ashli Rankin on 1/18/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
  @IBOutlet weak var favoritesTableView: UITableView!
  
 
  override func viewDidLoad() {
        super.viewDidLoad()
    favoritesTableView.dataSource = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    self.favoritesTableView.reloadData()
  }
  
}
extension FavoritesViewController:UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return DirectoryManager.getForecasts().count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let forcast = DirectoryManager.getForecasts()[indexPath.row]
    guard let cell = favoritesTableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as? ImageTableViewCell else {return UITableViewCell()}
    cell.placeIamage.image = UIImage(data: forcast.imageData)
    cell.placeName.text = forcast.placeName.replacingOccurrences(of: "%20", with: " ")
    return cell
  }
  
  
}
