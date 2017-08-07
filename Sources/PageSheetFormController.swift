//
//  PageSheetFormController
//
import UIKit

public class PageSheetFormController: UIViewController {
    
    private let seguePushPreview = "SeguePushPreview"
    
    private var isPreview:Bool = false
    

    private var initialText:String?
    private var previewPageTitle:String = "Preview"
    private var cancelButonText:String = "Cancel"
    private var sendButtonText:String = "Send"
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
    
        
        setUpComposeTextView(initialText!)
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
    
    public func setPreviewPageTitle(_ text:String) {
        self.previewPageTitle = text
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
    
    func preview() {
        performSegue(withIdentifier: seguePushPreview, sender: nil)
    }
    
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == seguePushPreview) {
            let previewViewController: PreviewViewController? = segue.destination as? PreviewViewController
            previewViewController?.previewPageTitle = previewPageTitle
            previewViewController?.setHtml(html: (composeTextView?.text)!)
        }
    }
    
    func setUpComposeTextView(_ defaultString: String) {
        let bodyFontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: UIFontTextStyle.body)
        
        let bodyFont = UIFont(descriptor: bodyFontDescriptor, size: 0.0)
        
        let paragrahStyle = NSMutableParagraphStyle()
        paragrahStyle.lineSpacing = 10.0
        let attributedText = NSMutableAttributedString(string: defaultString)
        attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragrahStyle, range: NSRange(location: 0, length: attributedText.length))
        attributedText.addAttribute(NSFontAttributeName, value: bodyFont, range: NSRange(location: 0, length: attributedText.length))
        composeTextView?.attributedText = attributedText
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 45))
        toolbar.barStyle = .default
        toolbar.backgroundColor = UIColor.white
        toolbar.tintColor = UIColor.black
        
        if (isPreview) {
            toolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "プレビュー", style: .done, target: self, action: #selector(self.preview))]
        }
        toolbar.sizeToFit()
        composeTextView?.inputAccessoryView = toolbar
    }
    
    public func setIsPreview (_ isPreview:Bool) {
        self.isPreview = isPreview
    }
}
