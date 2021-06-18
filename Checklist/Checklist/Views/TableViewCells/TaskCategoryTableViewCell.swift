//
//  TaskCategoryTableViewCell.swift
//  Checklist
//
//  Created by Rizwan Ali on 20/04/2021.
//

import UIKit
protocol TaskCategoryTableViewCellDelegate: NSObjectProtocol {
    func callBackMoveOnContoller(index: Int)
}

class TaskCategoryTableViewCell: BaseTableViewCell {
    @IBOutlet weak var viewCollection: UICollectionView!
    
    
    weak var delegate: TaskCategoryTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
//MARK: - EXTENSION COLLECTION VIEW METHODS
extension TaskCategoryTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return HomeMenu.MENU_LIST.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.HomeCollectionViewCell, for: indexPath) as! HomeCollectionViewCell
        cell.configureMenu(data: HomeMenu.MENU_LIST[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collection = collectionView.bounds.width
        return CGSize(width: (collection-10) / 2 ,height: collection / 2)//200)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.callBackMoveOnContoller(index: indexPath.row)
    }
}
