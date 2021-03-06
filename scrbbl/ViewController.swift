//
//  ViewController.swift
//  scrbbl
//
//  Created by Blake Barrett on 5/6/16.
//  Copyright © 2016 Blake Barrett. All rights reserved.
//  Started out following the tutorial here: https://www.raywenderlich.com/87899/make-simple-drawing-app-uikit-swift
//

import UIKit
import CoreGraphics
import MobileCoreServices

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, BrushReceiver {

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var tempImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.destinationViewController is BrushEditorViewController) {
            let editor = (segue.destinationViewController as! BrushEditorViewController)
            editor.delegate = self
            editor.brush = self.brush
        }
    }
    
    // MARK: - Touch Interaction Code
    
    var lastPoint = CGPointMake(0, 0)
    var swiped = false
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        swiped = false
        if let touch = touches.first {
            lastPoint = touch.locationInView(self.mainImageView)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        swiped = true
        if let touch = touches.first {
            let currentPoint = touch.locationInView(self.mainImageView)
            ViewController.drawLineFrom(lastPoint, toPoint: currentPoint, inImageView: self.tempImageView, withBrush: self.brush)
            
            // 7
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if !swiped {
            // draw a single point
            ViewController.drawLineFrom(lastPoint, toPoint: lastPoint, inImageView: self.tempImageView, withBrush: self.brush)
        }
        
        mainImageView.image = mergeImages(mainImageView.image, second: tempImageView.image)
        tempImageView.image = nil
    }
    
    // MARK: - Line Drawing Code
    var brush: Brush = Brush()
    func setBrush(brush: Brush) {
        self.brush = brush
    }
    
    class func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint, inImageView: UIImageView, withBrush: Brush) {
        
        let brush = withBrush
        
        let size = inImageView.frame.size
        
        // 1
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        inImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        // 2
        CGContextMoveToPoint(context, fromPoint.x, fromPoint.y)
        CGContextAddLineToPoint(context, toPoint.x, toPoint.y)
        
        // 3
        CGContextSetLineCap(context, CGLineCap.Round)
        CGContextSetLineWidth(context, brush.width)
        CGContextSetRGBStrokeColor(context, brush.red, brush.green, brush.blue, brush.alpha)
        CGContextSetBlendMode(context, CGBlendMode.Normal)
        
        // 4
        CGContextStrokePath(context)
        
        // 5
        inImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    // MARK: - Merge Image (from ImageMaskUtils)
    
    func mergeImages(first: UIImage?, second: UIImage?) -> UIImage {
        
        guard let first = first else {return second!}
        guard let second = second else {return first}
        
        let size: CGSize
        if ((first.size.width != second.size.width) ||
            (first.size.height != second.size.height)) {
            size = CGSizeMake(
                max(first.size.width, second.size.width),
                max(first.size.height, second.size.height))
        } else {
            size = first.size
        }
        
        UIGraphicsBeginImageContext(size)
        
        let originPoint = CGPointMake(0, 0)
        first.drawAtPoint(originPoint)
        second.drawAtPoint(originPoint)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func fit(image:UIImage, inSize: CGSize) -> UIImage {
        let size = inSize
        let originalAspectRatio = image.size.width / image.size.height
        
        let rect: CGRect
        let width, height, x, y: CGFloat
        //      width > height
        if (originalAspectRatio > 1) {
            // this appears to work
            width = size.width
            height = size.width / originalAspectRatio
            x = 0
            y = (size.height - height) / 2
            rect = CGRect(
                x: x, y: y,
                width: width,
                height: height
            )
        } else {
            // while this does not
            width = size.height * originalAspectRatio
            height = size.height
            x = (size.width - width) / 2
            y = 0
            rect = CGRect(
                x: x, y: y,
                width: width,
                height: height
            )
        }
        
        UIGraphicsBeginImageContext(size)
        image.drawInRect(rect)
        
        let rasterized = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return rasterized
    }
    
    // MARK: - Button Bar Item Click Handlers
    
    @IBAction func onTrashClicked(sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let destroyAction = UIAlertAction(title: "Reset", style: .Destructive) { (action) in
            self.tempImageView.image = nil
            self.mainImageView.image = nil
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            // no-op
        }
        
        alertController.addAction(destroyAction)
        alertController.addAction(cancelAction)
        
        alertController.popoverPresentationController?.barButtonItem = sender
        
        self.presentViewController(alertController, animated: true) {
            // ...
        }
    }
    
    @IBAction func onActionClicked(sender: UIBarButtonItem) {
        guard let image = self.mainImageView.image else { return }
        let activity = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        if (UIDevice.currentDevice().userInterfaceIdiom == .Pad) {
            let nav = UINavigationController(rootViewController: activity)
            nav.modalPresentationStyle = .Popover
            
            let popover = nav.popoverPresentationController as UIPopoverPresentationController!
            popover.barButtonItem = sender
            
            self.presentViewController(nav, animated: true, completion: nil)
        } else {
            presentViewController(activity, animated: true, completion: nil)
        }
    }
    
    @IBAction func onCameraClicked(sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.mediaTypes = [kUTTypeImage as String]
        presentViewController(imagePicker, animated: true) { () -> Void in
            // no-op
        }
    }
    
    // MARK: - Image Picker Controller Delegate Stuff
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let image = fit((info[UIImagePickerControllerOriginalImage] as! UIImage), inSize: self.mainImageView.frame.size)
        self.mainImageView.image = mergeImages(image, second: self.mainImageView.image)
        
        picker.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
}

protocol BrushReceiver {
    func setBrush(brush: Brush)
}
