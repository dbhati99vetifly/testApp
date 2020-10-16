//
//  testTVC.swift
//  testApp
//
//  Created by Deepak on 16/10/20.
//

import UIKit

class testTVC: UITableViewCell {

    @IBOutlet var userName: UILabel!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var postTitle: UILabel!
    @IBOutlet var postImage: UIImageView!
    @IBOutlet var postDesc: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
