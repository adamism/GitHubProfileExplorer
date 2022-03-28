//
//  UserModel.swift
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
		
		if let photoURL = photoURL,
		   let photoData = try? Data(contentsOf: photoURL) {
			photo = UIImage(data: photoData)
		}
	}
}

protocol UserModelType: AnyObject {
	
}

final class UserModel: UserModelType {
	var searchString: String
	
	init(searchString: String) {
		self.searchString = searchString
	}
	
	func fetchUser(completionHandler: @escaping (User) -> Void) {
		if let url = URL(string: "https://api.github.com/users/" + searchString + "") {
			URLSession.shared.fetchData(for: url) { (result: Result<User, Error>) in
				switch result {
				case .success(var user):
					if let followersURL = user.followersURL {
						self.fetchFollowers(followersURL: followersURL) { followers in
							user.followers = followers
							completionHandler(user)
						}
					} else {
						completionHandler(user)
					}
				case .failure(let error):
					print("Error fetching user: ", error)
				}
			}
		}
	}
	
	func fetchFollowers(followersURL: URL, completionHandler: @escaping ([User]) -> Void) {
		URLSession.shared.fetchData(for: followersURL) { (result: Result<[User], Error>) in
			switch result {
			case .success(let followers):
				completionHandler(followers)
			case .failure(let error):
				print("Error fetching followers: ", error)
			}
		}
	}

}
