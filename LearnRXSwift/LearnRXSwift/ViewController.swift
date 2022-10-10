//
//  ViewController.swift
//  LearnRXSwift
//
//  Created by lzx on 2022/10/8.
//
import UIKit

class ViewController: UIViewController {

    var data: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "RXSwift"
        
        view.backgroundColor = .white
        data.append("ObservableViewController")
        data.append("SingleViewController")
        data.append("CompletableViewController")
        data.append("MaybeViewController")
        data.append("DriverViewController")
        data.append("SignalViewController")
        

        view.addSubview(tableView)
        tableView.frame = view.bounds
        
    }
    
    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "rx")
        return table
    }()
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "rx", for: indexPath)
        cell.textLabel?.text = item
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = data[indexPath.row]
        
        if item == "ObservableViewController" {
            let target = ObservableViewController()
            navigationController?.pushViewController(target, animated: true)
        } else if item == "SingleViewController" {
            let target = SingleViewController()
            navigationController?.pushViewController(target, animated: true)
        } else if item == "CompletableViewController" {
            let target = CompletableViewController()
            navigationController?.pushViewController(target, animated: true)
        } else if item == "MaybeViewController" {
            let target = MaybeViewController()
            navigationController?.pushViewController(target, animated: true)
        } else if item == "DriverViewController" {
            let target = DriverViewController()
            navigationController?.pushViewController(target, animated: true)
        } else if item == "SignalViewController" {
            let target = SignalViewController()
            navigationController?.pushViewController(target, animated: true)
        }
    }
}

