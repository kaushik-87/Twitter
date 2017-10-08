//
//  AccountsCell.swift
//  Twitter
//
//  Created by Kaushik on 10/8/17.
//  Copyright © 2017 Dev. All rights reserved.
//

import UIKit

class AccountsCell: UITableViewCell {
    @IBOutlet weak var accountName: UILabel!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var addAcountLabel: UILabel!

    @IBOutlet weak var profileScreenName: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
