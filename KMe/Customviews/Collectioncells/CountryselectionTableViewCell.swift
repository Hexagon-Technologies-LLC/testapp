//
//  CountryselectionTableViewCell.swift
//  KMe
//
//  Created by CSS on 15/09/23.
//

import UIKit

class CountryselectionTableViewCell: UITableViewCell {
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var coiuntryflag: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
