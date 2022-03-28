//
//  UserModel.swift
//  GitHubProfileExplorer
//
//  Created by Ai on 3/25/22.
//

import UIKit

protocol UserModelType: AnyObject {
	var searchString: String { get set }
}

final class UserModel: UserModelType {
	var searchString: String
	
	init(searchString: String) {
		self.searchString = searchString
	}
	
	func fetchUser(completionHandler: @escaping (User) -> Void) {
		if let url = URL(string: Constants.baseURL + Constants.usersPath + searchString) {
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
