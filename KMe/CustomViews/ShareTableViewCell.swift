//
//  NotificationTableViewCell.swift
//  KMe
//
//  Created by CSS on 21/09/23.
//

import UIKit

class ShareTableViewCell: UITableViewCell {
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var descriptionlbl: UILabel!
    @IBOutlet weak var timesince: UILabel!
    @IBOutlet weak var tolabel: UILabel!
    @IBOutlet weak var profileimage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
