//
//  BaseViewController.swift
//  LearnRXSwift
//
//  Created by lzx on 2022/10/9.
//

import UIKit
import RxSwift
import RxCocoa

class BaseViewController: UIViewController {

    let disposedBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
