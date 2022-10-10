//
//  SingleViewController.swift
//  LearnRXSwift
//
//  Created by lzx on 2022/10/8.
//

import UIKit
import RxSwift

class SingleViewController: BaseViewController {
    
    /// 要么只能发出一个元素，要么产生一个 failure 事件
    
    let disposedBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// subscribe 消费 success & failure
        getRepo("deepway").subscribe(onSuccess: { json in
            print(json)
        }, onFailure: { error in
            print(error)
        }).disposed(by: disposedBag)
        
    }
    
    func getRepo(_ repo: String) -> Single<[String: Any]> {
        
        return Single<[String: Any]>.create { single in
            let url = URL(string: "https://api.github.com/repos/\(repo)")!
            let req = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
            let task = URLSession.shared.dataTask(with: req) { data, _, error in
                
                if let error = error {
                    single(.failure(error))
                    return
                }
                
                guard let data = data,
                      let json = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves),
                      let result = json as? [String: Any]
                else {
                    single(.failure(NSError(domain: "", code: 0001)))
                    return
                }
                
                single(.success(result))
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    

}
