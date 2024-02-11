//
//  NotificationTableViewCell.swift
//  KMe
//
//  Created by CSS on 21/09/23.
//

import UIKit

class CalendarTableViewCell: UITableViewCell {
    @IBOutlet weak var profileimage: UIImageView!
    @IBOutlet weak var profilename: UILabel!
    @IBOutlet weak var flagview: UIImageView!
    @IBOutlet weak var doctypename: UILabel!
    @IBOutlet weak var expirelabel: UILabel!
    @IBOutlet weak var expireview: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
