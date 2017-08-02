//
//  ViewController.swift
//  Sample
//
//  Created by ichise on 2017/07/19.
//  Copyright © 2017年 ichise. All rights reserved.
//

import UIKit
import PageSheetForm

class ViewController: UIViewController {
    
    @IBOutlet var baseTextView:UITextView?

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    @IBAction func click(sender:UIBarButtonItem) {
        
        let pageSheetFormController = PageSheetFormController.instantiate()
        pageSheetFormController.setInitialText((self.baseTextView?.text)!)
        pageSheetFormController.setTitleText("Title")
        pageSheetFormController.setCancelButtonText("Cancel")
        pageSheetFormController.setSendButtonText("Send")
        pageSheetFormController.completionHandler = { sendText in
            
            if (sendText.characters.count > 20) {
                let alertController:UIAlertController = UIAlertController(title:nil, message: "The number of characters exceeds the upper limit. Please enter within 20 characters.", preferredStyle: UIAlertControllerStyle.alert)
                let cancelAction:UIAlertAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel, handler:{ (action:UIAlertAction!) -> Void in
                })
                alertController.addAction(cancelAction)
                pageSheetFormController.present(alertController, animated: true, completion: nil)
                return
            }
            
            if (sendText.characters.count == 0) {
                let alertController:UIAlertController = UIAlertController(title:nil, message: "It is not input. Please enter.", preferredStyle: UIAlertControllerStyle.alert)
                let cancelAction:UIAlertAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel, handler:{ (action:UIAlertAction!) -> Void in
                })
                alertController.addAction(cancelAction)
                pageSheetFormController.present(alertController, animated: true, completion: nil)
                return
            }
            
            
            // success
            self.baseTextView?.text = sendText
            
            self.dismiss(animated: true, completion: nil)
        };
        present(pageSheetFormController, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
}

