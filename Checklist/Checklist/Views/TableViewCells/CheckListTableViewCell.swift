//
//  CheckListTableViewCell.swift
//  Checklist
//
//  Created by Rizwan Ali on 20/04/2021.
//

import UIKit

class CheckListTableViewCell: BaseTableViewCell {
    //MARK: -- IBOUTLETS
    @IBOutlet weak var taskTitleLbl: UILabel!
    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var btnNo: UIButton!
    @IBOutlet weak var btnNotAvailable: UIButton!
    
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
        }else{
            self.btnYes.isSelected = true
        }
    }
    
    @IBAction func actionNo(_ sender: UIButton){
        self.configureDefaultsBtn()
        if self.btnNo.isSelected{
            self.btnNo.isSelected = false
        }else{
            self.btnNo.isSelected = true
        }
    }
    
    @IBAction func actionNotAvailable(_ sender: UIButton){
        self.configureDefaultsBtn()
        if self.btnNotAvailable.isSelected{
            self.btnNotAvailable.isSelected = false
        }else{
            self.btnNotAvailable.isSelected = true
        }
    }

}
