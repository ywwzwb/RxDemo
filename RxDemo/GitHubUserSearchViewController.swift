//
//  GitHubUserSearchViewController.swift
//  RxDemo
//
//  Created by 曾文斌 on 2017/9/8.
//  Copyright © 2017年 yww. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum GitHubUserSearchError: Error {
    case searchFail, emptyKeyword
}

class GitHubUserSearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar
            .rx
            .text
            .orEmpty
            .throttle(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest({[unowned self] (keyword) -> Observable<[(String, String)]> in
                if keyword.isEmpty {
                    return .just([(String, String)]())
                }
                return self.searchOnGitHub(keyword).catchErrorJustReturn([(String, String)]())
            })
            .bind(to: self.tableView.rx.items(cellIdentifier: "cell")) {
                (index, data, cell) in
                cell.textLabel?.text = data.0
                cell.detailTextLabel?.text = data.1
        }.disposed(by: disposeBag)
        // Do any additional setup after loading the view.
    }
    func searchOnGitHub(_ keyword: String) -> Observable<[(String, String)]>{
        return Observable<[(String, String)]>.create({ (observer) -> Disposable in
            let session = URLSession(configuration: .default)
            let url = URL(string: "https://api.github.com/search/users?q=\(keyword)")!
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    observer.onError(error!)
                } else {
                    let json = (try! JSONSerialization.jsonObject(with: data!)) as! [String: Any]
                    if json["errors"] != nil {
                        observer.onError(GitHubUserSearchError.searchFail)
                    } else {
                        let items = json["items"] as! [[String: Any]]
                        var result = [(String, String)]()
                        for item in items {
                            result.append((item["login"] as! String, item["html_url"] as! String))
                        }
                        observer.onNext(result)
                        observer.onCompleted()
                    }
                }
            }
            task.resume()
            return Disposables.create {
                print("dosposed", keyword)
                task.cancel()
            }
        })
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
