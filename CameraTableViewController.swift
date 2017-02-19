//
//  CameraTableViewController.swift
//  Hyperfocal calculator
//
//  Created by Loic Sillere on 03/02/2017.
//  Copyright © 2017 Loic Sillere. All rights reserved.
//

import UIKit

class CameraTableViewController: UITableViewController, UISearchResultsUpdating {
    var cameras: [Camera] = []
    var filteredCameras: [Camera] = []
    var test: String = "plop"
    var pickedCamera = Camera(name: "APS-C", confusionCircle: 0.020)
    let searchController = UISearchController(searchResultsController: nil)

    weak var delegate: ViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameras = camerasInit()
        print("file cameratableviewcontroller")
        
        let appColor = UIColor(red: 95/255, green: 184/255, blue: 254/255, alpha: 1.0)
        
        // Navigation bar customization
        let nav = self.navigationController?.navigationBar
        nav?.isTranslucent = false
        nav?.tintColor = UIColor.white
        nav?.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        nav?.shadowImage = UIImage()
        
        // Search Controller customization
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search your camera model"
       // searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.barTintColor = appColor
        searchController.searchBar.layer.borderWidth = 1
        searchController.searchBar.layer.borderColor = appColor.cgColor
        searchController.searchBar.tintColor = UIColor.white

        
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredCameras.count
        }
        return cameras.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let camera: Camera
        if searchController.isActive && searchController.searchBar.text != "" {
            camera = filteredCameras[indexPath.row]
        } else {
            camera = cameras[indexPath.row]
        }
        
        
        cell.textLabel?.text = camera.name
        
        return cell
    }
    
    public func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
 
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredCameras = cameras.filter { Camera in
            return (Camera.name.lowercased().range(of: searchText.lowercased()) != nil)
        }
        
        tableView.reloadData()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pickedCamera" {
            let cell = sender as! UITableViewCell
            let index = tableView.indexPath(for: cell)
            if let indexPath = index?.row {
                let tableVC = segue.destination as! ViewController
                if searchController.isActive && searchController.searchBar.text != "" {
                    tableVC.selectedCamera = filteredCameras[indexPath]
                    // test with unwind segue : pickedCamera = filteredCameras[indexPath]
                } else {
                    tableVC.selectedCamera = cameras[indexPath]
                    // test with unwind segue : pickedCamera = cameras[indexPath]
                }
            }
        }
    }
    
    
    func camerasInit() -> [Camera] {
        var camerasJSON = [Camera]()
        
        // Fetch URL
        let url = Bundle.main.url(forResource: "camera", withExtension: "json")!
        
        // Load Data
        let data = try! Data(contentsOf: url)
        
        // Deserialize JSON
        let JSON = try! JSONSerialization.jsonObject(with: data, options: [])
        
        if let JSON = JSON as? [String: AnyObject] {
            if let cameraData = JSON["cameras"] as? [[String: AnyObject]] {
                for cameraDataPoint in cameraData {
                    if let time = cameraDataPoint["name"] as? String,
                        let windSpeed = cameraDataPoint["confusionCircle"] as? Double {
                        camerasJSON.append(Camera(name: time, confusionCircle: windSpeed))
                    }
                }
            }
        }
        
        return camerasJSON
    }
}
