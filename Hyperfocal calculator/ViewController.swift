//
//  ViewController.swift
//  Hyperfocal calculator
//
//  Created by Loic Sillere on 03/02/2017.
//  Copyright © 2017 Loic Sillere. All rights reserved.
//

import UIKit

extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard()
    {
        view.endEditing(true)
    }
}

extension String {
    static let numberFormatter = NumberFormatter()
    var doubleValue: Double {
        String.numberFormatter.decimalSeparator = "."
        if let result =  String.numberFormatter.number(from: self) {
            return result.doubleValue
        } else {
            String.numberFormatter.decimalSeparator = ","
            if let result = String.numberFormatter.number(from: self) {
                return result.doubleValue
            }
        }
        return 0
    }
}

class ViewController: UIViewController/*, UIPickerViewDelegate, UIPickerViewDataSource*/ {

    var selectedCamera:Camera = Camera(name: "", confusionCircle: 0)
    var CameraList = [Camera]()
    var result:Double = 0
    var resultUnitOfMesure = Measurement(value: 0, unit: UnitLength.meters)
    
    @IBOutlet weak var focalLength: UITextField!
    @IBOutlet weak var hyperfocalDistaceResult: UILabel!
    @IBOutlet weak var distanceUnitSegmentedControl: UISegmentedControl!
    @IBOutlet weak var apertureSize: UITextField!
    @IBOutlet weak var cameraName: UIButton!
    @IBOutlet weak var resultDescriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation bar customization
        let nav = self.navigationController?.navigationBar
        nav?.tintColor = UIColor.white
        nav?.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        nav?.shadowImage = UIImage()
        UIApplication.shared.statusBarStyle = .lightContent
        
        self.hideKeyboard()
        
        if(selectedCamera.name != "") {
            cameraName.setTitle(selectedCamera.name as String, for: .normal)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func calculate(_ sender: UIButton) {
        if(focalLength.text != "" && apertureSize.text != "" && selectedCamera.confusionCircle != 0) {
            
            let F:Double = (focalLength.text!).doubleValue
            let c:Double = selectedCamera.confusionCircle
            let d:Double = (apertureSize.text!).doubleValue
            print("Double OK")
            
            print(d)
            result = ((F*F/(F/d*c)))/1000
            print(result)
            result = Double(round(100*result)/100)
            
            // Calcul is made in meter
            resultUnitOfMesure = Measurement(value: result, unit: UnitLength.meters)

            // Convert result if needed in feet
            if(distanceUnitSegmentedControl.selectedSegmentIndex == 1) {
                resultUnitOfMesure = resultUnitOfMesure.converted(to: UnitLength.feet)
            }

            resultUnitOfMesure.value = Double(round(100*resultUnitOfMesure.value )/100)
            
            // Print result
            resultDescriptionLabel.isHidden = false
            hyperfocalDistaceResult.text = String(describing: resultUnitOfMesure)
            }
            /*else {
                print("KO")
            }*/
        
    }
    
    @IBAction func DistanceUnitSegmentedControlAction(_ sender: Any) {
        if(resultUnitOfMesure.value != 0) {
            switch distanceUnitSegmentedControl.selectedSegmentIndex {
            case 0: // Meter
                resultUnitOfMesure = resultUnitOfMesure.converted(to: UnitLength.meters)
            case 1: // Feet
                resultUnitOfMesure = resultUnitOfMesure.converted(to: UnitLength.feet)
            default: // Meter
                resultUnitOfMesure = resultUnitOfMesure.converted(to: UnitLength.meters)
            }
            resultUnitOfMesure.value = Double(round(100*resultUnitOfMesure.value )/100)
            
            hyperfocalDistaceResult.text = String(describing: resultUnitOfMesure)
        }
    }
    
    
    /* Unwind Segue from cameraTable but doesn't work with the search
     @IBAction func unwindToMainViewController(sender: UIStoryboardSegue) {
        if sender.source is CameraTableViewController {
            let view2:CameraTableViewController = sender.source as! CameraTableViewController
            cameraName.setTitle((view2.pickedCamera.name) as String, for: .normal)
            selectedCamera = view2.pickedCamera
        }
    }*/
}

