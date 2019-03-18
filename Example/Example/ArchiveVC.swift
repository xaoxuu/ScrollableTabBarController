//
//  ArchiveVC.swift
//  Example
//
//  Created by xaoxuu on 2019/3/18.
//  Copyright © 2019 Titan Studio. All rights reserved.
//

import ScrollableTabBarController

class ArchiveVC: MainViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "2018年度"
        rightNavBtn.setImage(UIImage.init(named: "icon_search"), for: .normal)
        rightNavBtn.ax_addTouchUp { (sender) in
            self.navigationController?.pushViewController(DetailVC(), animated: true)
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
