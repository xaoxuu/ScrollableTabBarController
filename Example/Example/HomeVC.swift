//
//  HomeVC.swift
//  Example
//
//  Created by xaoxuu on 2019/3/18.
//  Copyright © 2019 Titan Studio. All rights reserved.
//

import ScrollableTabBarController

class HomeVC: MainViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Welcome Alex"
        rightNavBtn.setImage(UIImage.init(named: "icon_avatar"), for: .normal)
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
