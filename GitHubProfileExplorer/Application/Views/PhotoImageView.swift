//
//  PhotoImageView.swift
//  GitHubProfileExplorer
//
//  Created by Ai on 3/25/22.
//

import UIKit

final class PhotoImageView: UIImageView {
	override func awakeFromNib() {
		self.layer.cornerRadius = self.circularRadius
	}
}
