//
//  VehicleDetailPopUpViewController.swift
//  Checklist
//
//  Created by Rizwan Ali on 03/05/2021.
//

import UIKit

protocol VehicleDetailPopUpViewControllerDelegate: NSObjectProtocol {
    func callBackActionSave()
}

class VehicleDetailPopUpViewController: BaseViewController {
    //MARK: - IBOUTLETS
    @IBOutlet weak var txtVehicleNumber: UITextField!
    @IBOutlet weak var txtCustomerName: UITextField!
    
    
    //MARK: - OBJECT AND VERIBALES
    weak var delegate: VehicleDetailPopUpViewControllerDelegate?
    
    //MARK: - OVERRIDE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - IBACTION METHODS
    @IBAction func actionSave(_ sender: UIButton){
        if self.checkValidations(){
            delegate?.callBackActionSave()
        }
    }
    
    //MARK: - FUNCTIONS
    func checkValidations() -> Bool{
        var isValid: Bool = true
        
        if self.txtVehicleNumber.text!.isEmpty{
            self.showAlertView(message: PopupMessages.Empty_Vehicle_Number)
            isValid = false
        }else if self.txtCustomerName.text!.isEmpty{
            self.showAlertView(message: PopupMessages.Enter_Customer_Name)
            isValid = false
        }
        
        return isValid
    }
}