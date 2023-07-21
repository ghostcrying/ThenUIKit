//
//  CoreController.swift
//  Example
//
//  Created by 陈卓 on 2023/7/21.
//

import UIKit

class CoreController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let sources = Core.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

extension CoreController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sources.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sources[section].items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "com.core.identifier", for: indexPath)
        cell.textLabel?.text = sources[indexPath.section].items[indexPath.row].rawValue
        return cell
    }
}

extension CoreController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
