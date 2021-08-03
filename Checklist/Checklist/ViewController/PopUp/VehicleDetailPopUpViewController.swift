//
//  VehicleDetailPopUpViewController.swift
//  Checklist
//
//  Created by Rizwan Ali on 03/05/2021.
//

import UIKit

protocol VehicleDetailPopUpViewControllerDelegate: NSObjectProtocol {
    func callBackActionSave(txtVehicleNumber: String, txtCustomerName: String )
}

class VehicleDetailPopUpViewController: BaseViewController {
    //MARK: - IBOUTLETS
    @IBOutlet weak var txtVehicleNumber: UITextField!
    @IBOutlet weak var txtCustomerName: UITextField!
    
    @IBOutlet weak var numberTFCOntainer: UIView!
    
    @IBOutlet weak var nameTFContainer: UIView!
    
    //MARK: - OBJECT AND VERIBALES
    weak var delegate: VehicleDetailPopUpViewControllerDelegate?
    
    //MARK: - OVERRIDE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        numberTFCOntainer.dropShadow()
        nameTFContainer.dropShadow()
    }
    
    //MARK: - IBACTION METHODS
    @IBAction func actionSave(_ sender: UIButton){
        if self.checkValidations(){
            delegate?.callBackActionSave(txtVehicleNumber: txtVehicleNumber.text!, txtCustomerName: txtCustomerName.text!)
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
