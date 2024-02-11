//
//  SearchResultTableViewCell.swift
//  KMe
//
//  Created by CSS on 06/10/23.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    @IBOutlet weak var profileimage: UIImageView!
    @IBOutlet weak var profilename: UILabel!
    @IBOutlet weak var emailid: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
