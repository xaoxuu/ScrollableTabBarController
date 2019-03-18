//
//  BaseTabBarVC.swift
//  Example
//
//  Created by xaoxuu on 2019/3/18.
//  Copyright © 2019 Titan Studio. All rights reserved.
//

import ScrollableTabBarController

class BaseTabBarVC: ScrollableTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    open override func setupBackgroundImage() -> UIImage? {
        return UIImage.init(named: "bg")
    }
    
    /// 设置子控制器
    ///
    /// - Returns: 子控制器
    open override func setupChildViewControllers() -> [MainViewController] {
        return [ArchiveVC(), HomeVC(), SettingVC()]
    }
    
    
    open override func setupTabBarButton(button: UIButton, for index: Int) {
        if index == 0 {
            button.setImage(UIImage.init(named: "icon_archive"), for: .normal)
        } else if index == 1 {
            button.setImage(UIImage.init(named: "icon_today"), for: .normal)
        } else if index == 2 {
            button.setImage(UIImage.init(named: "icon_setting"), for: .normal)
        }
    }
    
}
