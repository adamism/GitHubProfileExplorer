//
//  FollowerTableViewCell.swift
//  GitHubProfileExplorer
//
//  Created by Ai on 3/25/22.
//

import UIKit

final class FollowerTableViewCell: UITableViewCell {
	@IBOutlet weak var photoImageView: PhotoImageView!
	@IBOutlet weak var usernameLabel: UILabel!
	
	override func awakeFromNib() {
//		photoImageView.layer.cornerRadius = photoImageView.circularRadius
	}
}
