//
//  CombineLatestViewController.swift
//  RxDemo
//
//  Created by 曾文斌 on 2017/9/4.
//  Copyright © 2017年 yww. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

class CombineLatestViewController: UIViewController {
    
    @IBOutlet weak var inputTextField1: UITextField!
    @IBOutlet weak var inputTextField2: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var resultLabel2: UILabel!
    @IBOutlet weak var button: UIButton!
    
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        Observable.combineLatest(self.inputTextField1.rx.text, self.inputTextField2.rx.text) {"\($0!): \($1!)" }
            .subscribe(onNext: {[unowned self] (str) in
                self.resultLabel.text = str
            })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(self.inputTextField1.rx.text, self.inputTextField2.rx.text) {"\($0!): \($1!)" }
            .bind(to: self.resultLabel2.rx.text)
            .disposed(by: disposeBag)
        Observable.combineLatest(self.inputTextField1.rx.text, self.inputTextField2.rx.text) {
            !$0!.isEmpty && !$1!.isEmpty}
            .bind(to: self.button.rx.isEnabled)
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
