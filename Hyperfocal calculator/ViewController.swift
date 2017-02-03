//
//  ViewController.swift
//  Hyperfocal calculator
//
//  Created by Loic Sillere on 03/02/2017.
//  Copyright © 2017 Loic Sillere. All rights reserved.
//

import UIKit

class ViewController: UIViewController/*, UIPickerViewDelegate, UIPickerViewDataSource*/ {

    var pickerData: [String] = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6"]
    var valueToPass: String! = "test"
    var selectedCamera:Camera = Camera(name: "APS-C", cercleDeConfusion: 0.020)
    var CameraList = [Camera]()
    
    @IBAction func calculate(_ sender: UIButton) {
        print(selectedCamera.name)
        print(focalLength.text)
        print(apertureSize.text)
        let F:Double = Double(focalLength.text!)!
        let c:Double = selectedCamera.cercleDeConfusion
        let d:Double = Double(apertureSize.text!)!
        print(d)
        let calcul = ((F*F/(F/d*c)))/1000
        print(calcul)
        hyperfocalDistaceResult.text = String(calcul)
    }

    @IBOutlet weak var focalLength: UITextField!
    @IBOutlet weak var hyperfocalDistaceResult: UILabel!
    
    @IBOutlet weak var apertureSize: UITextField!
    @IBOutlet weak var cameraName: UIButton!
    @IBOutlet weak var captorPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CameraList = camerasInit()
        print(CameraList[0].name)
        //self.captorPicker.delegate = self
        //self.captorPicker.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // The number of columns of data
    /*func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }*/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Segue")

        if segue.identifier == "cameraSelection" {
            print("Segue")
            let tableVC = segue.destination as! CameraTableViewController
            // Pass the object
            tableVC.passedValue = valueToPass
        }
    }
    
    @IBAction func unwindToMainViewController(sender: UIStoryboardSegue) {
        if sender.source is CameraTableViewController {
            let view2:CameraTableViewController = sender.source as! CameraTableViewController
            //print(view2.pickedCamera.name)
            cameraName.setTitle((view2.pickedCamera.name) as String, for: .normal)
        }
    }
    
    
    
    func camerasInit() -> [Camera] {
        var cameras = [Camera]()
        
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
                        cameras.append(Camera(name: time, cercleDeConfusion: windSpeed))
                    }
                }
            }
        }
        
        
        
        
        return cameras
    }
}

