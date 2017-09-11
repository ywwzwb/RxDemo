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

protocol URLRequestCovertable {
    var request: URLRequest {get}
}
extension URLRequest: URLRequestCovertable{
    var request: URLRequest { return self }
}
extension URL: URLRequestCovertable {
    var request: URLRequest{
        return URLRequest(url: self)
    }
}
extension String: URLRequestCovertable {
    var request: URLRequest {
        guard let url = URL(string: self) else {
            fatalError("cannot convert \(self) to valid URL")
        }
        return url.request
    }
}
extension Reactive where Base: URLSession {
    private class RequestDelegate: NSObject, URLSessionDelegate {
        init(customCredentialData: Data) {
            
        }
        func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
            
        }
    }
    static func request(_ request: URLRequestCovertable)
        -> Observable<(Data?, URLResponse?)> {
            return Observable<(Data?, URLResponse?)>.create({ (observer) -> Disposable in
                let session: URLSession = URLSession(configuration: .default)
                let task = session.dataTask(with: request.request) { (data, response, error) in
                    if error != nil {
                        observer.onError(error!)
                    } else {
                        observer.onNext((data, response))
                        observer.onCompleted()
                    }
                }
                task.resume()
                return Disposables.create {
                    task.cancel()
                }
            })
    }
}


enum GitHubUserSearchError: Error {
    case searchFail, emptyKeyword, resultError
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
            .flatMapLatest({
                [unowned self] (keyword) -> Observable<[(String, String)]> in
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
        return URLSession.rx.request("https://api.github.com/search/users?q=\(keyword)")
            .map { (data, _) -> [(String, String)] in
                guard let data = data,
                    let json = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any] else {
                        throw GitHubUserSearchError.resultError
                }
                guard json["errors"] == nil else {
                    throw GitHubUserSearchError.searchFail
                }
                guard let items = json["items"] as? [[String: Any]] else {
                    throw GitHubUserSearchError.resultError
                }
                var result = [(String, String)]()
                for item in items {
                    result.append((item["login"] as? String ?? "--", item["html_url"] as? String ?? "--"))
                }
                return result
        }
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
