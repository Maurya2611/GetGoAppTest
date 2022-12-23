//
//  FilterViewController.swift
//  GetGoTestApp
//
//  Created by Chandresh on 21/12/22.
//

import Foundation
import UIKit
protocol FilterViewControllerProtocol: AnyObject {
    func didFetchFilterDataList(_ status: String?, _ spices: String?, _ gender: String?)
}
class FilterViewController: UIViewController {
    internal weak var delegate: FilterViewControllerProtocol?
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
        self.view.backgroundColor = .white
        self.tabBarController?.tabBar.isHidden = true
        
        // Mark - to filter from server response
        /*guard let model = viewModel else {
            return
        }
        let Status: String = "Status"
        let Status_List = uniqueElementsFrom(array: model.characterResult.sorted { $0.status ?? "" < $1.status ?? "" }.compactMap({ $0.status }))
        
        let Species: String = "Species"
        let Species_List = uniqueElementsFrom(array: model.characterResult.sorted { $0.species ?? "" < $1.species ?? "" }.compactMap({ $0.species }))
        
        let Gender: String = "Gender"
        let Gender_List = uniqueElementsFrom(array: model.characterResult.sorted { $0.gender ?? "" < $1.gender ?? "" }.compactMap({ $0.gender }))*/
        
        // Mark - As per Design filter Static
        let Status_List = ["Alive", "Dead", "Unknown"]
        let Species_List = ["Alien", "Animal", "Mythological Creature", "Human"]
        let Gender_List = ["Male", "Female", "Genderless", "Unknown"]
        
        let Params_Status: [String: Any] = ["title": "Status", "list": Status_List]
        let Params_Species: [String: Any] = ["title": "Species", "list": Species_List]
        let Params_Gender: [String: Any] = ["title": "Gender", "list": Gender_List]
        
        rootView?.listItems = [Params_Status, Params_Species, Params_Gender]
        rootView?.selectedValue = viewModel?.selectedValue ?? [:]
        rootView?.didTapButton = { dic in
            self.dismiss(animated: true)
            self.viewModel?.selectedValue = dic
            self.delegate?.didFetchFilterDataList(dic["Status"], dic["Species"], dic["Gender"])
        }
    }
}
