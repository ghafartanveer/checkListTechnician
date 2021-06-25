//
//  CheckListTableViewCell.swift
//  Checklist
//
//  Created by Rizwan Ali on 20/04/2021.
//

import UIKit

protocol CheckListTableViewCellDelegate: NSObjectProtocol {
    func yesBtn(btn:UIButton)
    func noBtn(btn:UIButton)
    func notAvalable(btn:UIButton)
}

class CheckListTableViewCell: BaseTableViewCell {
    //MARK: -- IBOUTLETS
    @IBOutlet weak var taskTitleLbl: UILabel!
    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var btnNo: UIButton!
    @IBOutlet weak var btnNotAvailable: UIButton!
    
    //MARK: -Variables/Objects
    weak var delegate: CheckListTableViewCellDelegate?
    
    //MARK: - OVERRIDE METHODS
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    // MARK: - FUNCTIONS
    func cofigureCellData(info:TaskSubcatgoryViewModel, index: Int) {
        let indexStr = String(index+1)
        self.taskTitleLbl.text = indexStr + ") " + info.subcategoryName
    }
    
    func setBtnState(yes: Bool = false, no: Bool = false, notAvailable: Bool = false, default: Bool = false) {
        configureDefaultsBtn()
        if yes {
            self.btnYes.isSelected = true
        }
        if no{
            self.btnNo.isSelected = true
        }
        if notAvailable {
            self.btnNotAvailable.isSelected = true
        }
    }
    
    func configureDefaultsBtn(){
        self.btnYes.isSelected = false
        self.btnNo.isSelected = false
        self.btnNotAvailable.isSelected = false
    }
    
    //MARK: - IBACTION METHODS
    @IBAction func actionYes(_ sender: UIButton){
        self.configureDefaultsBtn()
        if self.btnYes.isSelected{
            self.btnYes.isSelected = false
            delegate?.yesBtn(btn: sender)
        }else{
            self.btnYes.isSelected = true
            delegate?.yesBtn(btn: sender)
            
        }
    }
    
    @IBAction func actionNo(_ sender: UIButton){
        self.configureDefaultsBtn()
        if self.btnNo.isSelected{
            self.btnNo.isSelected = false
            delegate?.noBtn(btn: sender)
        }else{
            self.btnNo.isSelected = true
            delegate?.noBtn(btn: sender)
        }
    }
    
    @IBAction func actionNotAvailable(_ sender: UIButton){
        self.configureDefaultsBtn()
        if self.btnNotAvailable.isSelected{
            self.btnNotAvailable.isSelected = false
            delegate?.notAvalable(btn: sender)
        }else{
            self.btnNotAvailable.isSelected = true
            delegate?.notAvalable(btn: sender)
        }
    }

}
