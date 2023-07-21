import UIKit
import ThenUIKit
import ThenFoundation

enum Animals: CaseIterable {
    case dog
    case cat
    case mouse
    case rabbit
    case horse
    case cow
    case sheep
    case chicken
    case monkey
    case duck
    case goose
    case leopard
    case tiger
    case lion
    case bear
    
    var name: String {
        switch self {
        case .dog:
            return "🐶狗"
        case .cat:
            return "😾猫"
        case .mouse:
            return "🐭鼠"
        case .rabbit:
            return "🐰兔"
        case .horse:
            return "🐴马"
        case .cow:
            return "🐮牛"
        case .sheep:
            return "🐑羊"
        case .chicken:
            return "🐔鸡"
        case .monkey:
            return "🙉猴"
        case .duck:
            return "🐣鸭"
        case .goose:
            return "🦢鹅"
        case .leopard:
            return "🐆豹"
        case .tiger:
            return "🐯虎"
        case .lion:
            return "🦁狮"
        case .bear:
            return "🐻‍❄️熊"
        }
    }
    
    var descriptions: String {
        switch self {
        case .dog:
            return "狗是一种友好的动物，喜欢和人一起玩耍，也能学习一些技能，比如抓拍、抓玩具等。"
        case .cat:
            return "猫是一种温顺的动物，喜欢独处，也喜欢抓猎物和玩游戏。"
        case .mouse:
            return "老鼠是一种活泼的动物，它们喜欢活动，喜欢吃小食物，也喜欢探索新的环境。"
        case .rabbit:
            return "兔子是一种可爱的动物，它们喜欢跳跃，也喜欢吃草和蔬菜。"
        case .horse:
            return "马是一种非常强壮的动物，它们能够承受很重的负荷，也能够跑很快。"
        case .cow:
            return "牛是一种坚强的动物，它们喜欢吃草，也喜欢和人类一起工作。"
        case .sheep:
            return "羊是一种温顺的动物，它们喜欢吃草，也喜欢和人类一起活动。"
        case .chicken:
            return "鸡是一种有趣的动物，它们喜欢吃小米，也喜欢和人类一起活动。"
        case .monkey:
            return "猴子是一种活泼的动物，它们喜欢玩耍，也喜欢探索新的环境。"
        case .duck:
            return "鸭子是一种温顺的动物，它们喜欢游泳和嬉戏，也喜欢吃小食物。"
        case .goose:
            return "鹅是一种温顺的动物，它们喜欢游泳和嬉戏，也喜欢吃小食物。"
        case .leopard:
            return "豹是一种强壮的动物，它们喜欢抓猎物，也喜欢独处。"
        case .tiger:
            return "虎是一种强壮的动物，它们喜欢抓猎物，也喜欢独处。"
        case .lion:
            return "狮子是一种强壮的动物，它们喜欢抓猎物，也喜欢独处。"
        case .bear:
            return "熊是一种可爱的动物，它们喜欢吃小食物，也喜欢探索新的环境。"
        }
    }
}

class ViewController: UIViewController {
    
    let Identifier = "com.cell.identifier.reuse"
    
    lazy var tableView: UITableView = {
        let table: UITableView
        if #available(iOS 13.0, *) {
            table = UITableView(frame: .zero, style: .insetGrouped)
        } else {
            table = UITableView(frame: .zero, style: .grouped)
        }
        table.separatorColor = UIColor.lightGray
        table.separatorStyle = .singleLine
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: Identifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configUI()
        
        print(Animals.allCases.count)
    }
    
    func configUI() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Animals.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier, for: indexPath)
        cell.textLabel?.text = Animals.allCases[indexPath.row].name
        cell.textLabel?.font = .systemFont(ofSize: 15)
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

