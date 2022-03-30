//
//  UserEntity.swift
//  GitHubProfileExplorer
//
//  Created by Ai on 3/25/22.
//

import UIKit

struct GHUser: Hashable {
	var username: String?
	var photoURL: URL?
	var profileURL: URL?
	var followersURL: URL?
	var photo: UIImage?
	var followers: [GHUser]?
	
	enum CodingKeys: String, CodingKey {
		case username = "login"
		case photoURL = "avatar_url"
		case profileURL = "html_url"
		case followersURL = "followers_url"
	}
}

extension GHUser: Decodable {
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		
		username = try? values.decode(String.self, forKey: .username)
		photoURL = try? values.decode(URL.self, forKey: .photoURL)
		profileURL = try? values.decode(URL.self, forKey: .profileURL)
		followersURL = try? values.decode(URL.self, forKey: .followersURL)		
	}
}
