//
//  UserEntity.swift
//  GitHubProfileExplorer
//
//  Created by Ai on 3/25/22.
//

import UIKit

struct User: Hashable, Equatable {
	var username: String?
	var photoURL: URL?
	var profileURL: URL?
	var followersURL: URL?
	var photo: UIImage?
	var followers: [User]?
	
	enum CodingKeys: String, CodingKey {
		case username = "login"
		case photoURL = "avatar_url"
		case profileURL = "html_url"
		case followersURL = "followers_url"
	}
}

extension User: Decodable {
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		
		username = try? values.decode(String.self, forKey: .username)
		photoURL = try? values.decode(URL.self, forKey: .photoURL)
		profileURL = try? values.decode(URL.self, forKey: .profileURL)
		followersURL = try? values.decode(URL.self, forKey: .followersURL)		
	}
}
