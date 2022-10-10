//
//  CompletableViewController.swift
//  LearnRXSwift
//
//  Created by lzx on 2022/10/9.
//

import UIKit
import RxSwift

class CompletableViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cacheLocal(obj: "1").subscribe(onCompleted: {
            print("onCompleted")
        }, onError: { error in
            print("onError \(error.localizedDescription)")
        }).disposed(by: disposedBag)
    }
    
    func cacheLocal(obj: String) -> Completable {
        return Completable.create { completable in
            
            var isSuccess: Bool = false
            isSuccess = obj == "1"
            
            guard isSuccess else {
                let error = NSError(domain: "", code: 99)
                completable(.error(error))
                return Disposables.create { }
            }
            completable(.completed)
            return Disposables.create { }
        }
    }
    

}
