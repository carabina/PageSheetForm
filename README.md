### PageSheetForm ![CocoaPods Version](https://img.shields.io/cocoapods/v/PageSheetForm.svg?style=flat) ![Platform](https://img.shields.io/cocoapods/p/PageSheetForm.svg?style=flat) ![License](https://img.shields.io/cocoapods/l/PageSheetForm.svg?style=flat)

PageSheetForm is a PageSheet style form.

### Examples

#### Swift

```html
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
```

#### ObjectiveC

```
@import PageSheetForm;

__weak PageSheetFormController *pageSheetFormController = [PageSheetFormController instantiate];
    [pageSheetFormController setTitleText:@"Title"];
    [pageSheetFormController setCancelButtonText:@"Cancel"];
    [pageSheetFormController setSendButtonText:@"Send"];
    [pageSheetFormController setCompletionHandler:^(NSString *sendText) {
        
        if ([sendText length] > 5) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"The number of characters exceeds the upper limit. Please enter within 20 characters." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}];
            [alertController addAction:cancelAction];
            [pageSheetFormController presentViewController:alertController animated:YES completion:nil];

            return;
        }
        
        if ([sendText length] == 0) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"It is not input. Please enter.." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}];
            [alertController addAction:cancelAction];
            [pageSheetFormController presentViewController:alertController animated:YES completion:nil];
            
            return;
        }
        
        [self dismissViewControllerAnimated:true completion:nil];
    }];

    [self presentViewController:pageSheetFormController animated:true completion:nil];
```

### Installation (CocoaPods)
`pod PageSheetForm`

or 

`pod 'PageSheetForm', :git => 'https://github.com/tichise/PageSheetForm.git'`

