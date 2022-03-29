//
//  UserModel.swift
//  GitHubProfileExplorer
//
//  Created by Ai on 3/25/22.
//

import UIKit
import RealmSwift

protocol UserModelType: AnyObject {
	var searchString: String { get set }
	func fetchUser(completionHandler: @escaping (Bool, User?) -> Void)
	func fetchFollowers(followersURL: URL, completionHandler: @escaping ([User]) -> Void)
}

final class UserModel: UserModelType {
	var searchString: String
	var realmHelper: RealmHelper
	var urlSession: URLSession
	
	init(searchString: String, realmHelper: RealmHelper, urlSession: URLSession) {
		self.searchString = searchString
		self.realmHelper = realmHelper
		self.urlSession = urlSession
	}
	
	func fetchUser(completionHandler: @escaping (Bool, User?) -> Void) {
		if let url = URL(string: Constants.baseURL + Constants.usersPath + searchString) {
			if var cachedRealmUser = realmHelper.validRealmUserForUsername(username: searchString),
			   let followersURL = cachedRealmUser.followersURL {
				self.fetchFollowers(followersURL: followersURL) { [self] followers in
					realmHelper.saveUser(user: cachedRealmUser)
					cachedRealmUser.followers = followers
					completionHandler(true, cachedRealmUser)
				}
			} else {
				urlSession.fetchData(for: url) { (result: Result<User, Error>) in
					switch result {
					case .success(var user):
						guard user.profileURL != nil else {
							completionHandler(false, nil)
							return
						}
						
						if let photoURL = user.photoURL,
						   let photoData = try? Data(contentsOf: photoURL) {
							user.photo = UIImage(data: photoData)
						}
						if let followersURL = user.followersURL {
							self.fetchFollowers(followersURL: followersURL) { followers in
								self.realmHelper.saveUser(user: user)
								user.followers = followers
								completionHandler(true, user)
							}
						} else {
							self.realmHelper.saveUser(user: user)
							completionHandler(true, user)
						}
					case .failure(let error):
						print("Error fetching user: ", error)
					}
				}
			}
		}
	}
	
	func fetchFollowers(followersURL: URL, completionHandler: @escaping ([User]) -> Void) {
		URLSession.shared.fetchData(for: followersURL) { (result: Result<[User], Error>) in
			switch result {
			case .success(let followers):
				let populatedFollowers = followers.map { user -> User in
					var populatedUser = user
					if let photoURL = user.photoURL,
					   let photoData = try? Data(contentsOf: photoURL) {
						populatedUser.photo = UIImage(data: photoData)
					}
					return populatedUser
				}
				completionHandler(populatedFollowers)
			case .failure(let error):
				print("Error fetching followers: ", error)
			}
		}
	}
	
}
