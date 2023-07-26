//
//  BasicController.swift
//  Example
//
//  Created by ghost on 2023/7/21.
//

import UIKit

class BasicController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let sources = Basic.allCases
}

extension BasicController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sources.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sources[section].items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "com.basic.identifier", for: indexPath)
        cell.textLabel?.text = sources[indexPath.section].items[indexPath.row].rawValue
        return cell
    }
}

extension BasicController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = sources[indexPath.section].items[indexPath.row].controller
        navigationController?.pushViewController(vc, animated: true)
    }
}
