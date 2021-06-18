//
//  AboutUsViewController.swift
//  Checklist
//
//  Created by Muaaz Ahmad on 17/06/2021.
//

import Foundation
import UIKit

class AboutUsViewController: BaseViewController, TopBarDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("this is aboutUs")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let container = self.mainContainer{
            container.delegate = self
            container.setMenuButton(true, true, title: TitleNames.About_Us)
        }
    }
    func actionBack() {
        self.loadHomeController()
    }
}
