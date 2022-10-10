//
//  SignalViewController.swift
//  LearnRXSwift
//
//  Created by lzx on 2022/10/10.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa

class SignalViewController: BaseViewController {
    
    var state: SharedSequence<DriverSharingStrategy, String?>?
    var event: SharedSequence<SignalSharingStrategy, Void>?
    var eventDriver: SharedSequence<DriverSharingStrategy, Void>?
    let isEventDriver: Bool = true
    let isTextDemo: Bool = false
    
    /// Signal 不会对新观察者回话上一个元素
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "SignalViewController"
        
        createUI()
        
        if isTextDemo {
            rxTextMethod()
        } else {
            if isEventDriver {
                rxButtonMethodWithDriver()
            } else {
                rxButtonMethod()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if isTextDemo {
            handleTextWithDriver()
        } else {
            if isEventDriver {
                // 会回放一下上一次的事件
                handleButtonEventWithDriver()
            } else {
                handleButtonEventWithSignal()
            }
        }
    }
    
    // MARK: Button Handlers
    
    fileprivate func handleButtonEventWithDriver() {
        let observer = { print("Alert222 - Driver") }
        if let eventDriver = eventDriver {
            eventDriver.drive(onNext: observer).disposed(by: disposedBag)
        }
    }
    
    fileprivate func handleButtonEventWithSignal() {
        let observer = { print("Alert222 - Signal") }
        if let event = event {
            event.emit(onNext: observer).disposed(by: disposedBag)
        }
    }
    
    fileprivate func rxButtonMethodWithDriver() {
        eventDriver = button.rx.tap.asDriver()
        let observer = { print("Alert - Driver") }
        if let eventDriver = eventDriver {
            eventDriver.drive(onNext: observer).disposed(by: disposedBag)
        }
    }
    
    fileprivate func rxButtonMethod() {
        event = button.rx.tap.asSignal()
        let observer = { print("Alert - Signal") }
        if let event = event {
            event.emit(onNext: observer).disposed(by: disposedBag)
        }
    }
    
    // MARK: TextField Handlers
    
    fileprivate func handleTextWithDriver() {
        if let state = state {
            // Driver会回放上一个元素
            let observer = nameSizeLabel.rx.text
            state
                .map { text in
                    "count = \(text?.count.description ?? "0")"
                }
                .drive(observer)
                .disposed(by: disposedBag)
        }
    }
    
    fileprivate func rxTextMethod() {
        state = textField.rx.text.asDriver()
        
        let observer = nameLabel.rx.text
        if let state = state {
            state.drive(observer).disposed(by: disposedBag)
        }
        
    }
    
    fileprivate func createUI() {
        view.addSubview(textField)
        view.addSubview(nameLabel)
        view.addSubview(nameSizeLabel)
        view.addSubview(line)
        view.addSubview(button)
        
        textField.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.height.equalTo(44)
        }
        nameLabel.snp.makeConstraints { make in
            make.left.right.height.equalTo(textField)
            make.top.equalTo(textField.snp.bottom).offset(10)
        }
        nameSizeLabel.snp.makeConstraints { make in
            make.left.right.height.equalTo(textField)
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
        }
        
        line.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        button.snp.makeConstraints { make in
            make.top.equalTo(line.snp.bottom).offset(60)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 200, height: 44))
        }
    }
    
    lazy var button: UIButton = {
        let btn = UIButton()
        btn.setTitle("Click Me", for: .normal)
        btn.backgroundColor = .blue
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    
    lazy var line: UIView = {
        let line = UIView()
        line.backgroundColor = .yellow
        return line
    }()
    
    lazy var nameSizeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()

    lazy var textField: UITextField = {
        let field = UITextField()
        field.placeholder = "Please Enter Content"
        field.text = "99"
        field.backgroundColor = .secondaryLabel
        return field
    }()
}
