//
//  BindViewController.swift
//  RxDemo
//
//  Created by 曾文斌 on 2017/9/18.
//  Copyright © 2017年 yww. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BindViewController: UIViewController {
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var resultLabel2: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        inputTextField.rx.text.subscribe(onNext: {[unowned self] str in
            self.resultLabel.text = str
        }).disposed(by: disposeBag)
        inputTextField.rx.text.bind(to:self.resultLabel2.rx.text).disposed(by: disposeBag)
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
