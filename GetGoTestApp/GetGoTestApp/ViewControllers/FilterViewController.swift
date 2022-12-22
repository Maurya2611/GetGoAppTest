//
//  FilterViewController.swift
//  GetGoTestApp
//
//  Created by Chandresh on 21/12/22.
//

import Foundation
import UIKit
class FilterViewController: UIViewController {
    var viewModel: CharacterViewModel?
    init(viewModel: CharacterViewModel?) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    var rootView: ContainerBottomSheetView? {
        view as? ContainerBottomSheetView
    }
    
    // MARK: - Lifecycle
    override func loadView() {
        view = ContainerBottomSheetView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let Status: String = "Status"
        let Status_List = ["Alive", "Dead", "Unknown"]
        
        let Species: String = "Species"
        let Species_List = ["Alien", "Animal", "Mythological Creature", "Unknown"]
        
        let Gender: String = "Gender"
        let Gender_List = ["Male", "Female", "Genderless", "Unknown"]
        
        let Params_Status:[String: Any] = ["title": Status, "list": Status_List]
        let Params_Species:[String: Any] = ["title": Species, "list": Species_List]
        let Params_Gender:[String: Any] = ["title": Gender, "list": Gender_List]
        rootView?.listItems = [Params_Status, Params_Species, Params_Gender]
        self.view.backgroundColor = .white
        rootView?.didTapButton = { [weak self] in
            self?.dismiss(animated: true)
        }
        self.tabBarController?.tabBar.isHidden = true
    }
}
