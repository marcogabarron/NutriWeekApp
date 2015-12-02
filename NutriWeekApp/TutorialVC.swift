

import UIKit

class TutorialVC: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var start: UIButton!
    
    
    @IBAction func start(sender: AnyObject) {
        
        if start.hidden == false{
            dismissTutorial(true)
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "FirstLaunchTutorial")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Initiliaze NSUserDefaults default values
        let firstLaunchTutorial = NSUserDefaults.standardUserDefaults().boolForKey("FirstLaunchTutorial")
        if firstLaunchTutorial {
            dismissTutorial(false)
        }
        
        //Esconde botão
        start.hidden = true
        
        

        let page1: UIView! = NSBundle.mainBundle().loadNibNamed("Page1-Tutorial",
            owner: self,
            options: nil)[0] as! UIView
        
        let page2: UIView! = NSBundle.mainBundle().loadNibNamed("Page2-Tutorial",
            owner: self,
            options: nil)[0] as! UIView
        
        let page3: UIView! = NSBundle.mainBundle().loadNibNamed("Page3-Tutorial",
            owner: self,
            options: nil)[0] as! UIView
        
        let page4: UIView! = NSBundle.mainBundle().loadNibNamed("Page4-Tutorial",
            owner: self,
            options: nil)[0] as! UIView
        
        let page5: UIView! = NSBundle.mainBundle().loadNibNamed("Page5-Tutorial",
            owner: self,
            options: nil)[0] as! UIView
        
        let page6: UIView! = NSBundle.mainBundle().loadNibNamed("Page6-Tutorial",
            owner: self,
            options: nil)[0] as! UIView
        
        let page7: UIView! = NSBundle.mainBundle().loadNibNamed("Page7-Tutorial",
            owner: self,
            options: nil)[0] as! UIView
        
        let pages: [UIView!] = [page1,page2, page3, page4, page5, page6, page7]
        
        var size = view.bounds.size
        size.width = CGFloat(pages.count) * view.bounds.size.width
        scrollView.contentSize = size
        
        for i in 0..<pages.count {
            let page = pages[i]
            let contentView = UIView()
            contentView.frame = self.view.frame
            contentView.addSubview(page)
            page.center = contentView.center
            scrollView.addSubview(contentView)
            var frame = contentView.frame
            frame.origin.x = contentView.frame.origin.x + CGFloat(i) * contentView.frame.size.width
            contentView.frame = frame
        }
        
        pageControl.currentPage = 0
        pageControl.numberOfPages = pages.count
    }
    
    func dismissTutorial(animated: Bool)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let viewController = storyboard.instantiateViewControllerWithIdentifier("NavigationID") as! UINavigationController
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        if let window = appDelegate.window{
            
            if animated {
                
                UIView.transitionWithView(window, duration: 0.5, options: .TransitionFlipFromRight, animations: {
                    window.rootViewController = viewController
                }, completion: nil)
                
            } else {
                
                window.rootViewController = viewController
                
            }
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let page = floor(scrollView.contentOffset.x /
            self.view.frame.width)
        
        pageControl.currentPage = Int(page)
        
        if pageControl.currentPage == 6 {
            
            start.hidden = false
        }
        else {
        
            start.hidden = true
        }
    }
}