//
//  BrushEditorViewController.swift
//  scrbbl
//
//  Created by Blake Barrett on 5/7/16.
//  Copyright © 2016 Blake Barrett. All rights reserved.
//

import Foundation
import UIKit

class BrushEditorViewController : UIViewController {
    
    var brush: Brush?
    
    var delegate: BrushReceiver?
    
    @IBOutlet weak var colorPreviewView: UIView!
    
    @IBOutlet weak var thicknessSlider: UISlider!
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    @IBOutlet weak var redTextField: UITextField!
    @IBOutlet weak var greenTextField: UITextField!
    @IBOutlet weak var blueTextField: UITextField!
    
    override func viewDidLoad() {
        guard let brush = brush else { return }
        // init values
        thicknessSlider.setValue(Float(brush.width) / 10.0, animated: true)
        redSlider.setValue(Float(brush.red), animated: true)
        greenSlider.setValue(Float(brush.green), animated: true)
        blueSlider.setValue(Float(brush.blue), animated: true)
        
        redTextField.text = "\(brush.red * 255)"
        greenTextField.text = "\(brush.green * 255)"
        blueTextField.text = "\(brush.blue * 255)"
    }
    
    @IBAction func thicknessSliderValueChanged(sender: UISlider) {
        brush?.width = CGFloat(sender.value * 10.0)
    }
    
    @IBAction func redSliderValueChanged(sender: UISlider) {
        brush?.red = CGFloat(sender.value)
        redTextField.text = "\((brush?.red)! * 255)"
    }
    
    @IBAction func greenSliderValueChanged(sender: UISlider) {
        brush?.green = CGFloat(sender.value)
        greenTextField.text = "\((brush?.green)! * 255)"
    }
    
    @IBAction func blueSliderValueChanged(sender: UISlider) {
        brush?.blue = CGFloat(sender.value)
        blueTextField.text = "\((brush?.blue)! * 255)"
    }
    
    @IBAction func onDoneButtonPressed(sender: UIButton) {
        delegate?.setBrush(self.brush!)
        self.dismiss()
    }
    
    @IBAction func onCancelButtonPressed(sender: UIButton) {
        self.dismiss()
    }
    
    func dismiss() {
        self.dismissViewControllerAnimated(true) { 
            // …
        }
    }
}