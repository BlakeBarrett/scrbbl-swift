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
    private var originalBrush: Brush?
    
    var delegate: BrushReceiver?
    
    @IBOutlet weak var colorPreviewView: UIView!
    @IBOutlet weak var colorPreviewImageView: UIImageView!
    
    @IBOutlet weak var thicknessSlider: UISlider!
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    @IBOutlet weak var redTextField: UITextField!
    @IBOutlet weak var greenTextField: UITextField!
    @IBOutlet weak var blueTextField: UITextField!
    
    override func viewDidLoad() {
        guard let brush = brush else { return }
        
        self.originalBrush = Brush()
        self.originalBrush?.red = (self.brush?.red)!
        self.originalBrush?.green = (self.brush?.green)!
        self.originalBrush?.blue = (self.brush?.blue)!
        self.originalBrush?.width = (self.brush?.width)!
        
        // init values
        thicknessSlider.setValue(Float(brush.width) / 10.0, animated: true)
        redSlider.setValue(Float(brush.red), animated: true)
        greenSlider.setValue(Float(brush.green), animated: true)
        blueSlider.setValue(Float(brush.blue), animated: true)
        
        update(redTextField, withValue: brush.red)
        update(greenTextField, withValue: brush.green)
        update(blueTextField, withValue: brush.blue)
    }
    
    func getCenterPoint() -> CGPoint {
        return CGPointMake(colorPreviewImageView.frame.size.width / 2, colorPreviewImageView.frame.size.height / 2)
    }
    
    func updateBrushSwatch() {
        let red = (self.brush?.red)!
        let green = (self.brush?.green)!
        let blue = (self.brush?.blue)!
        let alpha = (self.brush?.alpha)!
        
        let tempBrush = Brush()
        tempBrush.width = (self.brush?.width)!
        tempBrush.red = 1 - red
        tempBrush.green = 1 - green
        tempBrush.blue = 1 - blue
        
        self.colorPreviewView.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        self.colorPreviewImageView.image = nil
        ViewController.drawLineFrom(getCenterPoint(), toPoint: getCenterPoint(), inImageView: self.colorPreviewImageView, withBrush: tempBrush)
    }
    
    func update(textField: UITextField, withValue: CGFloat?) {
        textField.text = "\(round(withValue! * 255))"
        updateBrushSwatch()
    }
    
    @IBAction func thicknessSliderValueChanged(sender: UISlider) {
        brush?.width = CGFloat(sender.value * 10.0)
        updateBrushSwatch()
    }
    
    @IBAction func redSliderValueChanged(sender: UISlider) {
        brush?.red = CGFloat(sender.value)
        update(redTextField, withValue: brush?.red)
    }
    
    @IBAction func greenSliderValueChanged(sender: UISlider) {
        brush?.green = CGFloat(sender.value)
        update(greenTextField, withValue:  brush?.green)
    }
    
    @IBAction func blueSliderValueChanged(sender: UISlider) {
        brush?.blue = CGFloat(sender.value)
        update(blueTextField, withValue:  brush?.blue)
    }
    
    @IBAction func onDoneButtonPressed(sender: UIButton) {
        delegate?.setBrush(self.brush!)
        self.dismiss()
    }
    
    @IBAction func onCancelButtonPressed(sender: UIButton) {
        delegate?.setBrush(self.originalBrush!)
        self.dismiss()
    }
    
    func dismiss() {
        self.dismissViewControllerAnimated(true) { 
            // …
        }
    }
}