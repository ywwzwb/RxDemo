//
//  CocoaTestViewController.swift
//  RxDemo
//
//  Created by 曾文斌 on 2017/9/8.
//  Copyright © 2017年 yww. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Notification.Name {
    static let TestNotificationName = Notification.Name("TestNotificationName")
}

class CocoaTestViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var button: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.button.rx.tap.subscribe(onNext: { () in
          print("button clicked")
        }).disposed(by: disposeBag)
        NotificationCenter.default.rx.notification(.TestNotificationName).subscribe(onNext: { (notify) in
          print("notication recived: ", notify.userInfo!)
        }).disposed(by: disposeBag)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func postClicked(_ sender: Any) {
        NotificationCenter.default.post(name: .TestNotificationName, object: nil, userInfo: ["Hello": "world"])
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
