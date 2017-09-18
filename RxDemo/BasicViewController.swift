//
//  BasicViewController.swift
//  RxDemo
//
//  Created by 曾文斌 on 2017/9/4.
//  Copyright © 2017年 yww. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
class BasicViewController: UIViewController {
    let disposeBag = DisposeBag()
    @IBOutlet weak var output: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func just(_ sender: Any) {
        Observable.just("Hello, world").subscribe(onNext: { (str) in
            self.print(str)
        }).disposed(by: disposeBag)
    }
    @IBAction func just2(_ sender: Any) {
        Observable.just("Hello, world").subscribe { (event) in
            self.print(event)
            }.disposed(by: disposeBag)
    }
    
    @IBAction func of(_ sender: Any) {
        Observable.of("Hello", "world").subscribe { (event) in
            self.print(event)
            }.disposed(by: disposeBag)
    }
    @IBAction func simpleCreate(_ sender: Any) {
        Observable<String>.create { (observer) -> Disposable in
            observer.onNext("Hello, world")
            observer.onCompleted()
            return Disposables.create {}
            }.subscribe { (event) in
                self.print(event)
            }.disposed(by: disposeBag)
    }
    @IBAction func urlsession(_ sender: Any) {
        Observable<String?>.create { (observer) -> Disposable in
            let task = URLSession.shared.dataTask(with: URL(string: "https://httpbin.org/get")!, completionHandler: { (data, _, error) in
                if error != nil {
                    observer.onError(error!)
                } else {
                    if data == nil {
                        observer.onNext(nil)
                    } else {
                        observer.onNext(String(data: data!, encoding: .utf8))
                    }
                    observer.onCompleted()
                }
            })
            task.resume()
            return Disposables.create {
                task.cancel()
            }
            }.map{ $0 ?? "empty result" }
            .subscribe { (event) in
                self.print(event)
            }.disposed(by: disposeBag)
    }
    
    @IBAction func never(_ sender: Any) {
        Observable<String>.never().subscribe { (_) in
            self.print("nerver print")
        }.disposed(by: disposeBag)
    }
    @IBAction func neverCreate(_ sender: Any) {
        Observable<String>.create({ (observer) -> Disposable in
            return Disposables.create()
        }).subscribe { (_) in
            self.print("nerver print")
            }.disposed(by: disposeBag)
    }
    func print(_ obj: Any) {
        DispatchQueue.main.async {
            self.output.text = (self.output.text ?? "") + "\(obj)\n"
        }
    }
    @IBAction func clear(_ sender: Any) {
        self.output.text = ""
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
