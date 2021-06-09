//
//  ChangePasswordPopUpViewController.swift
//  Checklist
//
//  Created by Rizwan Ali on 22/04/2021.
//

import UIKit

protocol ChangePasswordPopUpViewControllerDelegate: NSObjectProtocol {
    func callBackActionSubmit()
}

class ChangePasswordPopUpViewController: BaseViewController {

    
    //MARK: - OBJECT AND VERIABLES
    weak var delegate: ChangePasswordPopUpViewControllerDelegate?
    
    //MARK: - OVERRIDE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
     
    //MARK: - IBACTION METHODS
    @IBAction func actionSubmit(_ sender: UIButton){
        delegate?.callBackActionSubmit()
    }
    @IBAction func actionClose(_ sender: UIButton){
        delegate?.callBackActionSubmit()
    }

}