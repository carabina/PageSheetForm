//
//  PreviewViewController
//
import UIKit

public class PreviewViewController: UIViewController {

    @IBOutlet var webView:UIWebView?

    private var html:String?
    public var previewPageTitle:String?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = previewPageTitle
                
        // スクロール速度を上げる
        webView?.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal
        
        // 編集ページから渡ってきたhtmlをwebviewに渡す。
        // 自動改行設定をapiから取得できないので、自動改行の場合の表示（\nを<br/>に置き換える）で常にプレビュー表示します。
        let replacedHtml: String = html!.replacingOccurrences(of: "\n", with: "<br/>")
        let htmlString: String = "<html><meta name='viewport' content='width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;'></head><body><div style='padding:10px;line-height:1.5em'>\(replacedHtml)</div></body></html>"
        webView?.loadHTMLString(htmlString, baseURL: nil)
    }

    public func setHtml(html:String) {
        self.html = html
    }
}
