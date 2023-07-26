//
//  CropRouter.swift
//  Example
//
//  Created ghost on 2023/7/26.
//

import UIKit
import Foundation

// MARK: Wireframe -
protocol CropWireframeProtocol: AnyObject {
    
}

// MARK: Presenter -
protocol CropPresenterProtocol: AnyObject {
    
    func viewDidLoad()
    func viewWillAppear(_ animated: Bool)
    func viewDidAppear(_ animated: Bool)
    func viewWillDisappear(_ animated: Bool)
    func viewDidDisappear(_ animated: Bool)
    func viewWillLayoutSubviews()
    func viewDidLayoutSubviews()
}
extension CropPresenterProtocol {
    
    func viewDidLoad() {}
    func viewWillAppear(_ animated: Bool) {}
    func viewDidAppear(_ animated: Bool) {}
    func viewWillDisappear(_ animated: Bool) {}
    func viewDidDisappear(_ animated: Bool) {}
    func viewWillLayoutSubviews() {}
    func viewDidLayoutSubviews() {}
}

// MARK: View -
protocol CropViewProtocol: AnyObject {

    var presenter: CropPresenterProtocol?  { get set }
}

final class CropPresenter: CropPresenterProtocol {

    weak private var view: CropViewProtocol?
    private let router: CropWireframeProtocol

    init(interface: CropViewProtocol, router: CropWireframeProtocol) {
        self.view = interface
        self.router = router
    }

}


final class CropRouter: CropWireframeProtocol {
    
    weak var view: UIViewController?
    
    static func createModule() -> UIViewController {
        let view = CropViewController(nibName: nil, bundle: nil)
        let router = CropRouter()
        let presenter = CropPresenter(interface: view, router: router)
        
        view.presenter = presenter
        router.view = view
        
        return view
    }
}
