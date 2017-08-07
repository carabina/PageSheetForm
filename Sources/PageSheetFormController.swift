//
//  PageSheetFormController
//
import UIKit

public class PageSheetFormController: UIViewController {
    
    private var initialText:String?
    private var cancelButonText:String?
    private var sendButtonText:String?
    private var titleText:String?

    private var titleSize:CGFloat?
    private var buttonSize:CGFloat?

    @IBOutlet var composeTextView:UITextView?
    
    @IBOutlet var cancelButton:UIBarButtonItem?
    @IBOutlet var sendButton:UIBarButtonItem?
    
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
        
        setUpCancelButton()
        setUpSendButton()
        
        
        self.navigationItem.title = titleText
        
        if (titleSize != nil) {
            self.navigationController?.navigationBar.titleTextAttributes
                = [NSFontAttributeName: UIFont.systemFont(ofSize: titleSize!)]
        }
    
        
        composeTextView?.text = initialText
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
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
    
    public func setTitleSize(_ size:CGFloat) {
        self.titleSize = size
    }
    
    public func setButtonSize(_ size:CGFloat) {
        self.buttonSize = size
    }
    
    @objc private func cancel(sender:UIBarButtonItem) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        self.dismiss(animated: true, completion:nil)
    }
    
    @objc private func send(sender:UIBarButtonItem) {
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
    
    func setUpCancelButton() {
        let leftButton = UIBarButtonItem(title: cancelButonText, style: UIBarButtonItemStyle.plain, target: self, action:#selector(PageSheetFormController.cancel(sender:)))
        
        if (buttonSize != nil) {
            leftButton.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: buttonSize!)], for: UIControlState.normal)
        }
        
        self.navigationItem.leftBarButtonItem = leftButton
    }
    
    func setUpSendButton() {
        let rightButton = UIBarButtonItem(title: sendButtonText, style: UIBarButtonItemStyle.plain, target: self, action: #selector(PageSheetFormController.send(sender:)))
        
        if (buttonSize != nil) {
            rightButton.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: buttonSize!)], for: UIControlState.normal)
        }
        
        self.navigationItem.rightBarButtonItem = rightButton
    }
}
