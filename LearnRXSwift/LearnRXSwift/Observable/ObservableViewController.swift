//
//  ObservableViewController.swift
//  RXSwiftLearn
//
//  Created by lzx on 2022/10/8.
//

import UIKit
import RxSwift

/// 可以发出多个元素
class ObservableViewController: BaseViewController {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Observable"
        view.backgroundColor = .white
        
        numberObservable()
    }
    
    func temperatureObservable() {
        let temps: Observable<CGFloat> = Observable.create { (observer) -> Disposable in
            observer.onNext(22.0)
            observer.onNext(25.0)
            observer.onNext(30.0)
            
            // MARK: onError
//            let error = NSError(domain: "rxswift", code: 9999)
//            observer.onError(error)
            
            observer.onNext(34.0)
            observer.onNext(39.0)
            observer.onCompleted()
            return Disposables.create()
        }
        
//        temps.subscribe { temp in
//            print("temp = \(temp)")
//        }.disposed(by: disposeBag)
        
//        temps.asMaybe().subscribe(onSuccess: <#T##((CGFloat) -> Void)?##((CGFloat) -> Void)?##(CGFloat) -> Void#>, onError: <#T##((Error) -> Void)?##((Error) -> Void)?##(Error) -> Void#>, onCompleted: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>, onDisposed: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
        
//        temps.subscribe(onNext: <#T##((CGFloat) -> Void)?##((CGFloat) -> Void)?##(CGFloat) -> Void#>, onError: <#T##((Error) -> Void)?##((Error) -> Void)?##(Error) -> Void#>, onCompleted: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>, onDisposed: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
        temps.subscribe { temp in
            
        } onError: { error in
            
        } onCompleted: {
            
        } onDisposed: {
            
        }.disposed(by: disposeBag)

        temps.subscribe { temp in
            print("temp = \(temp)")
        } onError: { error in
            print("error = \(error)")
        } onCompleted: {
            print("completed")
        }.disposed(by: disposeBag)

    }
    
    func numberObservable() {
        // 生产一个序列
        let numbers: Observable<Int> = Observable.create { (observer) -> Disposable in

            observer.onNext(0)
            observer.onNext(1)
            observer.onNext(2)
            observer.onNext(3)
            observer.onNext(4)
            observer.onNext(5)
            observer.onNext(6)
            observer.onNext(7)
            observer.onNext(8)
            observer.onNext(9)
            observer.onCompleted()

            return Disposables.create()
        }
        
        // 消费生产出来的数据
        numbers.subscribe { num in
            print("num = \(num)  type = \(type(of: num))")
        }.disposed(by: disposeBag)

    }
    

}
