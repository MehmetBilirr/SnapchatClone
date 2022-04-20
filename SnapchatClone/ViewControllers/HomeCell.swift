//
//  HomeCell.swift
//  SnapchatClone
//
//  Created by Mehmet Bilir on 21.04.2022.
//

import UIKit

class HomeCell: UITableViewCell {

    @IBOutlet weak var homeImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
