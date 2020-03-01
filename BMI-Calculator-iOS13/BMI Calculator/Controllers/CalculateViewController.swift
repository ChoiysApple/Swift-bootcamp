//
//  ViewController.swift
//  BMI Calculator
//
//  Created by Angela Yu on 21/08/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit

class CalculateViewController: UIViewController {

    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    var height: Float = 1.5
    var weight: Float = 100.0
    
    @IBAction func heightSliderMoved(_ sender: UISlider) {
        heightLabel.text = String(format:"%.2f", sender.value)+"m"
        height = sender.value
    }
    
    @IBAction func weightSliderMoved(_ sender: UISlider) {
        weightLabel.text = String(format:"%.1f", sender.value)+"Kg"
        weight = sender.value
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func calcuateBtnClicked(_ sender: UIButton) {


        self.performSegue(withIdentifier: "goToResults", sender: self)
    }
    
    
    func calculateBMI(_ height: Float, _ weight: Float) -> String{
        return String(format: "%.2f", weight/(pow(height,2)))
    }
    
}
