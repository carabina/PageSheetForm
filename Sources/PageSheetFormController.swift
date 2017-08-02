//
//  PageSheetFormController
//
import UIKit

public class PageSheetFormController: UIViewController {
    
    private var initialText:String?
    private var cancelButonText:String?
    private var sendButtonText:String?
    private var titleText:String?
    
    @IBOutlet var composeTitleLabel:UILabel?
    @IBOutlet var composeTextView:UITextView?
    
    @IBOutlet var cancelButton:UIButton?
    @IBOutlet var sendButton:UIButton?
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    public var completionHandler: ((_ sendText: String) -> Void)?
    
    
    public static func instantiate() -> PageSheetFormController {
        let storyboardsBundle = getStoryboardsBundle()
        let pageSheetFormController = UIStoryboard(name: "PageSheetForm", bundle: storyboardsBundle).instantiateInitialViewController() as! PageSheetFormController
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            // 使用デバイスがiPhoneの場合
            pageSheetFormController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            // 使用デバイスがiPadの場合
            pageSheetFormController.modalPresentationStyle = UIModalPresentationStyle.pageSheet
        }

        return pageSheetFormController
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.cancelButton?.setTitle(cancelButonText, for: UIControlState.normal)
        self.sendButton?.setTitle(sendButtonText, for: UIControlState.normal)
        composeTitleLabel?.text = titleText
        composeTextView?.text = initialText
        
        
        // Start keyboard display / hidden notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // Cursor initial position of explanatory area set as head
        composeTextView?.selectedTextRange = composeTextView?.textRange(from: (composeTextView?.beginningOfDocument)!, to: (composeTextView?.beginningOfDocument)!)
        
        composeTextView?.becomeFirstResponder()
    }
    
    public func setInitialText(_ text:String) {
        self.initialText = text
    }
    
    public func setTitleText(_ text:String) {
        self.titleText = text
    }
    
    public func setCancelButtonText(_ text:String) {
        self.cancelButonText = text
    }
    
    public func setSendButtonText(_ text:String) {
        self.sendButtonText = text
    }
    
    @IBAction public func cancel() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        self.dismiss(animated: true, completion:nil)
    }
    
    @IBAction public func send() {
        if completionHandler != nil {
            completionHandler!((composeTextView?.text)!)
        }
    }
    
    static func getStoryboardsBundle() -> Bundle {
        let podBundle = Bundle(for: PageSheetFormController.self)
        let bundleURL = podBundle.url(forResource: "Storyboards", withExtension: "bundle")
        let bundle = Bundle(url: bundleURL!)!
        
        return bundle
    }
    
    func keyboardWillShow(_ notification: Notification) {
        let info: [AnyHashable: Any]? = notification.userInfo
        
        let rowRect:NSValue? = info?[UIKeyboardFrameEndUserInfoKey] as? NSValue
        let keyboardFrame:CGRect? = rowRect?.cgRectValue
        
        let duration = CDouble(info?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval ?? TimeInterval())
        bottomConstraint.constant = (keyboardFrame?.size.height)!
        
        UIView.animate(withDuration: duration, animations: {() -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    func keyboardWillHide(_ notification: Notification) {
        let info: [AnyHashable: Any]? = notification.userInfo
        let duration = CDouble(info?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval ?? TimeInterval())
        bottomConstraint.constant = 0
        
        UIView.animate(withDuration: duration, animations: {() -> Void in
            self.view.layoutIfNeeded()
        })
    }
}
