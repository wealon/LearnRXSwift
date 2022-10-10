//
//  DriverViewController.swift
//  LearnRXSwift
//
//  Created by lzx on 2022/10/10.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class DriverViewController: BaseViewController {
    
    deinit {
        print("DriverViewController deinit")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "DriverViewController"
        createUI()
        bind3()

    }
    
    fileprivate func bind3() {
        // Driver 会对新观察者回放上一个元素
        let results = query.rx.text.asDriver()
            .throttle(.microseconds(300))
            .flatMapLatest { [self] query in
                fetchAutoCompleteItems(query: query)
                    .asDriver(onErrorJustReturn: ["error occured"])
            }
        
        results
            .map { items in
                "\(items.count)"
            }
            .drive(resultCount.rx.text)
            .disposed(by: disposedBag)
        
        results
            .drive(resultTableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) {
                (_, item, cell) in
                cell.textLabel?.text = item
            }
            .disposed(by: disposedBag)
    }
    
    fileprivate func bind2() {
        let results = query.rx.text
            .throttle(.milliseconds(100), scheduler: MainScheduler.instance)
            .flatMapLatest { query in
                self.fetchAutoCompleteItems(query: query)
                    .observe(on: MainScheduler.instance)
                    .catchAndReturn(["error occured"])
            }
            .share(replay: 1)
        
        results
            .map { items in
                "\(items.count)"
            }
            .bind(to: resultCount.rx.text)
            .disposed(by: disposedBag)
        
        results
            .bind(to: resultTableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) {
                (_, item, cell) in
                cell.textLabel?.text = item
            }
            .disposed(by: disposedBag)
    }
    
    fileprivate func bind1() {
        /// 方法一
        let results = query.rx.text.asObservable().flatMapLatest { query in
            self.fetchAutoCompleteItems(query: query)
        }
        
        results
            .map { items in
                "\(items.count)"
            }
            .bind(to: resultCount.rx.text)
            .disposed(by: disposedBag)
        results
            .bind(to: resultTableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) {
                (_, item, cell) in
                cell.textLabel?.text = item
            }
            .disposed(by: disposedBag)
    }
    
    fileprivate func fetchAutoCompleteItems(query: String?) -> Observable<[String]> {
        print("query = \(query ?? "")")
        // 生产一个序列
        let numbers: Observable<[String]> = Observable.create { (observer) -> Disposable in
            var items: [String] = [String]()
            var queryCount = 0
            if let query = query {
                queryCount = query.count
            }
            for index in 0..<queryCount {
                items.append("\(index + 1)")
            }
            if queryCount == 5 {
                observer.onError(NSError(domain: "com.deepway.error", code: 999))
                return Disposables.create()
            }
            observer.onNext(items)
            observer.onCompleted()

            return Disposables.create()
        }
        return numbers
    }
    
    fileprivate func createUI() {
        view.addSubview(resultTableView)
        view.addSubview(resultCount)
        view.addSubview(query)
        
        query.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalToSuperview()
            make.right.equalToSuperview().offset(-100)
            make.height.equalTo(44)
        }
        
        resultCount.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.top.bottom.equalTo(query)
            make.width.equalTo(100)
        }
        
        resultTableView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(query.snp.bottom)
        }
    }
    
    lazy var resultTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    lazy var resultCount: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = .yellow
        return label
    }()

    lazy var query: UITextField = {
        let field = UITextField()
        field.placeholder = "error will occur with 5"
        field.backgroundColor = .secondaryLabel
        return field
    }()
    
}
