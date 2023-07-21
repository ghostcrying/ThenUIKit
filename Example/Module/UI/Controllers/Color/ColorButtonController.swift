import UIKit
import ThenUIKit
import ThenFoundation

class ColorButtonController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Color Button"
        view.backgroundColor = UIColor.systemGroupedBackground
        
        configUI()
    }

    var button: ThenColorButton!
    
    func configUI() {
        
        button = ThenColorButton(type: .custom)
        button
            .then
            .force {
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
            .setBorderColor(.green, for: .normal)
            .setBorderColor(.black, for: .highlighted)
            .setBackgroundColor(.red.withAlphaComponent(0.5), for: .normal)
            .setBackgroundColor(.red, for: .highlighted)
            .on {
                $0.layer.then.popup(3)
            }
//            .layer {
//                $0.borderWidth = 2
//                $0.cornerRadius = 10
//                $0.masksToBounds = true
//            }
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 200),
            button.heightAnchor.constraint(equalToConstant: 50),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
        ])
        
    }
    
    override func viewDidLayoutSubviews() {
        button.layer.then.border.make { border in
            border.lineColor = UIColor.black
            border.lineWidth = 5
            border.radius = 10
            border.corner = .all
            border.style = ThenCALayerBorder.BorderStyle.all
        }
    }
}
