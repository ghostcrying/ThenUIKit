//
//  ExController.swift
//  Example
//
//  Created by 陈卓 on 2023/7/21.
//

import UIKit

class ExController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let sources = Ex.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
}

extension ExController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sources.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sources[section].items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "com.ex.identifier", for: indexPath)
        cell.textLabel?.text = sources[indexPath.section].items[indexPath.row].rawValue
        return cell
    }
}

extension ExController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
