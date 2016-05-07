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
    
    var brush = Brush()
    
    @IBOutlet weak var thicknessSlider: UISlider!
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    
    @IBAction func thicknessSliderValueChanged(sender: UISlider) {
        brush.width = CGFloat(sender.value * 10.0)
    }
    
    @IBAction func redSliderValueChanged(sender: UISlider) {
        brush.red = CGFloat((sender.value * 100.0) / 255)
    }
    
    @IBAction func greenSliderValueChanged(sender: UISlider) {
        brush.green = CGFloat((sender.value * 100.0) / 255)
    }
    
    @IBAction func blueSliderValueChanged(sender: UISlider) {
        brush.blue = CGFloat((sender.value * 100.0) / 255)
    }
    
    @IBAction func onDoneButtonPressed(sender: UIButton) {
        (self.parentViewController as? ViewController)?.brush = self.brush
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