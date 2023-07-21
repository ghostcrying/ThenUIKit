import UIKit

class InheritController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let sources = Inherit.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}

extension InheritController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sources.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sources[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "com.inherit.identifier", for: indexPath)
        cell.textLabel?.text = sources[indexPath.section].items[indexPath.row].rawValue
        return cell
    }
}

extension InheritController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = sources[indexPath.section].items[indexPath.row]
        navigationController?.pushViewController(item.controller, animated: true)
    }
}
