//
//  ViewController.swift
//  Hyperfocal calculator
//
//  Created by Loic Sillere on 03/02/2017.
//  Copyright © 2017 Loic Sillere. All rights reserved.
//

import UIKit

class ViewController: UIViewController/*, UIPickerViewDelegate, UIPickerViewDataSource*/ {

    var valueToPass: String! = "test"
    var selectedCamera:Camera = Camera(name: "", cercleDeConfusion: 0)
    var CameraList = [Camera]()
    
    @IBAction func calculate(_ sender: UIButton) {
        if(focalLength.text != "" && apertureSize.text != "" && selectedCamera.cercleDeConfusion != 0) {
            let F:Double = Double(focalLength.text!)!
            let c:Double = selectedCamera.cercleDeConfusion
            let d:Double = Double(apertureSize.text!)!
            print(d)
            let calcul = ((F*F/(F/d*c)))/1000
            print(calcul)
            hyperfocalDistaceResult.text = String(calcul)
        }
    }

    @IBOutlet weak var focalLength: UITextField!
    @IBOutlet weak var hyperfocalDistaceResult: UILabel!
    
    @IBOutlet weak var apertureSize: UITextField!
    @IBOutlet weak var cameraName: UIButton!
    @IBOutlet weak var captorPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Bar customization
        let nav = self.navigationController?.navigationBar
        nav?.tintColor = UIColor.white
        //nav?.barStyle = UIBarStyle.black
        //self.navigationController?.toolbar.barTintColor = UIColor.init(red: 111, green: 212, blue: 254, alpha: 100)
        //nav?.backgroundColor = UIColor.init(red: 111, green: 212, blue: 254, alpha: 100)
        //self.navigationController?.toolbar.
        //nav?.barTintColor = UIColor.init(red: 111/255, green: 212/255, blue: 254/255, alpha: 1)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        //self.captorPicker.delegate = self
        //self.captorPicker.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cameraSelection" {
            let tableVC = segue.destination as! CameraTableViewController
            // Pass the object
            tableVC.passedValue = valueToPass
        }
    }
    
    @IBAction func unwindToMainViewController(sender: UIStoryboardSegue) {
        if sender.source is CameraTableViewController {
            let view2:CameraTableViewController = sender.source as! CameraTableViewController
            cameraName.setTitle((view2.pickedCamera.name) as String, for: .normal)
            selectedCamera = view2.pickedCamera
        }
    }
}

