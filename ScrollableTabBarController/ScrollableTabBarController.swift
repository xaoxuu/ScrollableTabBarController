//
//  ScrollableTabBarController.swift
//  ScrollableTabBarController
//
//  Created by xaoxuu on 2019/3/15.
//  Copyright © 2019 Titan Studio. All rights reserved.
//

import UIKit
import SnapKit
import AXKit

fileprivate let marginX = CGFloat(16)
fileprivate let bgx = CGFloat(120)
fileprivate let kScreenSize = UIScreen.main.bounds.size
fileprivate let kStatusBarHeight = CGConstGetStatusBarHeight()
fileprivate let navBtnWidth = CGFloat(32)

open class ScrollableTabBarController: UIViewController, UIScrollViewDelegate {

    
    
    public let backgroundImageView = UIImageView()
    public let scrollView = UIScrollView()
    
    public var viewControllers = [MainViewController]()
    public var tabBarButtons = [UIButton]()
    
    private let tabBarIndicator = UIView()
    private var isAllLoaded = false
    
    /// 设置背景图片
    ///
    /// - Returns: 图片
    open func setupBackgroundImage() -> UIImage? {
        return UIImage()
    }
    
    /// 设置子控制器
    ///
    /// - Returns: 子控制器
    open func setupChildViewControllers() -> [MainViewController] {
        return [MainViewController()]
    }
    
    open func setupTabBarButton(button: UIButton, for index: Int) {}
    
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        backgroundImageView.image = setupBackgroundImage()
        view.addSubview(backgroundImageView)
        backgroundImageView.snp.remakeConstraints { (make) in
            make.top.bottom.equalTo(view)
            make.width.equalTo(kScreenSize.width + bgx)
            make.centerX.equalTo(view)
        }
        
        viewControllers.append(contentsOf: setupChildViewControllers())
        
        view.addSubview(scrollView)
        scrollView.snp.remakeConstraints { (make) in
            make.top.equalTo(view).offset(kStatusBarHeight)
            make.bottom.left.right.equalTo(self.view)
            make.width.equalTo(kScreenSize.width)
            make.height.equalTo(kScreenSize.height - kStatusBarHeight)
        }
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSize.init(width: CGFloat(viewControllers.count)*kScreenSize.width, height: 0)
        
        
        let tabBar = UIView()
        tabBar.tintColor = .white
        tabBar.backgroundColor = UIColor.init(white: 0, alpha: 0.15)
        view.addSubview(tabBar)
        tabBar.snp.remakeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view)
            make.height.equalTo(CGConstGetTabBarHeight())
        }
        
        
        for i in 0..<viewControllers.count {
            let vc = viewControllers[i]
            addChild(vc)
            scrollView.addSubview(vc.view)
            vc.view.snp.remakeConstraints { (make) in
                make.top.bottom.equalTo(self.scrollView)
                make.width.equalTo(kScreenSize.width)
                make.height.equalTo(kScreenSize.height-kStatusBarHeight)
                if (i == 0) {
                    make.left.equalTo(self.scrollView)
                } else {
                    make.left.equalTo(self.viewControllers[i-1].view.snp.right)
                }
                if (i == self.viewControllers.count-1) {
                    make.right.equalTo(self.scrollView.snp.right)
                }
            }
            // tabbar buttons
            let tabBarBtn = UIButton.init(type: .system)
            tabBarButtons.append(tabBarBtn)
            tabBarBtn.addTarget(self, action: #selector(tabbarButtonDidTapped(sender:)), for: .touchUpInside)
            tabBarBtn.tag = i
            tabBar.addSubview(tabBarBtn)
            tabBarBtn.snp.remakeConstraints { (make) in
                make.top.equalTo(tabBar)
                make.bottom.equalTo(tabBar.snp.bottom).offset(-CGConstGetScreenBottomSafeAreaHeight())
                if (i > 0) {
                    make.left.equalTo(self.tabBarButtons[i-1].snp.right)
                    make.width.equalTo(self.tabBarButtons[i-1].snp.width)
                } else {
                    make.left.equalTo(tabBar)
                }
                if (i == self.viewControllers.count-1) {
                    make.right.equalTo(tabBar)
                }
            }
            setupTabBarButton(button: tabBarBtn, for: i)
        }
        
        // indicator
        tabBar.addSubview(tabBarIndicator)
        tabBarIndicator.backgroundColor = UIColor.white
        tabBarIndicator.layer.cornerRadius = 1.5
        tabBarIndicator.snp.remakeConstraints { (make) in
            make.height.equalTo(3)
            make.width.equalTo(12)
            make.top.equalTo(tabBar.snp.bottom).offset(-CGConstGetScreenBottomSafeAreaHeight()-8)
        }
        
        
        
        
        
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        if isAllLoaded == false {
            scrollView.scrollRectToVisible(viewControllers[viewControllers.count/2].view.frame, animated: false)
            isAllLoaded = true
        }
        
    }
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x/kScreenSize.width
        let count = viewControllers.count
        backgroundImageView.snp.updateConstraints { (make) in
            make.centerX.equalTo(view).offset(limit(input: bgx/2 - bgx*offset/CGFloat(count-1), minValue: -bgx/2, maxValue: bgx/2))
        }
        let leftPage = min(max(floor(offset), 0), CGFloat(tabBarButtons.count-1))
        let rightPercent = offset-leftPage
        let targetBtn = tabBarButtons[Int(leftPage)]
        tabBarIndicator.snp.remakeConstraints { (make) in
            make.height.equalTo(3)
            make.width.equalTo(12)
            make.top.equalTo(targetBtn.snp.bottom).offset(-8)
            if Int(leftPage) == count-1 {
                make.centerX.equalTo(targetBtn.snp.centerX)
            } else {
                make.centerX.equalTo(targetBtn.snp.centerX).offset((kScreenSize.width/CGFloat(count)*max(rightPercent, 0)))
            }
        }
        
        let safeMargin = 2*marginX
        for i in 0..<tabBarButtons.count {
            let btn = tabBarButtons[i]
            btn.alpha = 1 - 0.5*min(abs(offset-CGFloat(i)), 1)
            btn.transform = CGAffineTransform.init(translationX: 0, y: 2*min(abs(offset-CGFloat(i)), 1)-2)
        }
        
        var i = Int(leftPage)
        var x = CGFloat(rightPercent*kScreenSize.width)
        if x < 0 {
            x = kScreenSize.width - x
        } else if x > kScreenSize.width/2 {
            i = Int(leftPage)+1
        }
        if x > kScreenSize.width/2 {
            viewControllers[i].rightNavBtn.alpha = 1 - limit(input: abs(x-kScreenSize.width)/safeMargin, minValue: 0, maxValue: 1)
        } else {
            viewControllers[i].rightNavBtn.alpha = 1 - limit(input: abs(x)/safeMargin, minValue: 0, maxValue: 1)
        }
        
        let alpha = viewControllers[i].rightNavBtn.alpha
        viewControllers[i].rightNavBtn.snp.remakeConstraints { (make) in
            make.top.equalTo(viewControllers[i].view)
            make.height.equalTo(kNavBarHeight)
            make.width.equalTo(navBtnWidth)
            if x > kScreenSize.width/2 {
                make.right.equalTo(viewControllers[i].view).offset(-marginX-20*(1-alpha))
            } else {
                make.right.equalTo(viewControllers[i].view).offset(-marginX+20*(1-alpha))
            }
        }
    }
    
    @objc public func tabbarButtonDidTapped(sender: UIButton){
        if (sender.tag < self.viewControllers.count) {
            scrollView.scrollRectToVisible(viewControllers[sender.tag].view.frame, animated: true)
        }
    }

    private func limit(input: CGFloat, minValue: CGFloat, maxValue: CGFloat) -> CGFloat {
        var x = input
        x = max(x, minValue)
        x = min(x, maxValue)
        return x
    }
    
}

open class MainViewController: UIViewController {
    
    public let titleLabel = UILabel()
    public let rightNavBtn = UIButton()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = UIColor.white
        view.addSubview(titleLabel)
        titleLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(view)
            make.height.equalTo(kNavBarHeight)
            make.left.equalTo(view).offset(marginX)
        }
        
        view.addSubview(rightNavBtn)
        rightNavBtn.snp.remakeConstraints { (make) in
            make.top.equalTo(view)
            make.height.equalTo(kNavBarHeight)
            make.width.equalTo(navBtnWidth)
            make.right.equalTo(view).offset(-marginX)
        }
        rightNavBtn.tintColor = UIColor.white
        rightNavBtn.alpha = 0
    }
    
    override open var title: String?{
        didSet{
            titleLabel.text = title
        }
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    open override func viewDidAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    open override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    open override func viewDidDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
}
