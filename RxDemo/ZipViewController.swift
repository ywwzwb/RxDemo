//
//  ZipViewController.swift
//  RxDemo
//
//  Created by 曾文斌 on 2017/9/4.
//  Copyright © 2017年 yww. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ZipViewController: UIViewController {
    @IBOutlet weak var inputTextField1: UITextField!
    @IBOutlet weak var inputTextField2: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var resultLabel2: UILabel!
    
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        Observable.zip(self.inputTextField1.rx.text, self.inputTextField2.rx.text) {"\($0!): \($1!)" }
            .subscribe(onNext: {[unowned self] (str) in
                self.resultLabel.text = str
            })
            .disposed(by: disposeBag)
        
        Observable.zip(self.inputTextField1.rx.text, self.inputTextField2.rx.text) {"\($0!): \($1!)" }
            .bind(to: self.resultLabel2.rx.text)
            .disposed(by: disposeBag)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
