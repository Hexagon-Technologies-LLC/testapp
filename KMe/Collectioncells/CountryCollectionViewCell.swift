//
//  CountryCollectionViewCell.swift
//  KMe
//
//  Created by CSS on 06/09/23.
//

import UIKit

class CountryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cellbg: UIView!
    @IBOutlet weak var badgeview: UIView!
    @IBOutlet weak var badgetxt: UILabel!
    @IBOutlet weak var badgeimg: UIImageView!
    @IBOutlet weak var flagview: UIView!

    class var reuseIdentifier: String {
        return "CollectionViewCellReuseIdentifier"
    }
    class var nibName: String {
        return "CountryCollectionViewCell"
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        print("=====>>>>")
        print(cellbg.frame.size.height/2)
        
        
        cellbg.layer.cornerRadius = cellbg.frame.size.height/2
        cellbg.layer.borderWidth = 1
        cellbg.clipsToBounds = true

    }
    func configureCell(name: String) {
        print("=====>>>>")
        print(name)
        self.nameLabel.text = name
    }
}
