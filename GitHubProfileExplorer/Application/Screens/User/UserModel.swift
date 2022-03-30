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
	func fetchUser(completionHandler: @escaping (Bool, GHUser?) -> Void)
	func fetchFollowers(followersURL: URL, completionHandler: @escaping ([GHUser]) -> Void)
}

final class UserModel: UserModelType {
	var searchString: String
	var realmHelper: RealmHelperType
	var api: APIType
	
	init(searchString: String, realmHelper: RealmHelperType, api: APIType) {
		self.searchString = searchString
		self.realmHelper = realmHelper
		self.api = api
	}
	
	func fetchUser(completionHandler: @escaping (Bool, GHUser?) -> Void) {
		if let url = URL(string: Constants.baseURL + Constants.usersPath + searchString) {
			if var cachedRealmUser = realmHelper.validRealmUserForUsername(username: searchString),
			   let followersURL = cachedRealmUser.followersURL {
				self.fetchFollowers(followersURL: followersURL) { [self] followers in
					realmHelper.saveUser(user: cachedRealmUser)
					cachedRealmUser.followers = followers
					completionHandler(true, cachedRealmUser)
				}
			} else {
				api.fetchUser(for: url) { (result: Result<GHUser, Error>) in
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
	
	func fetchFollowers(followersURL: URL, completionHandler: @escaping ([GHUser]) -> Void) {
		api.fetchFollowers(for: followersURL) { (result: Result<[GHUser], Error>) in
			switch result {
			case .success(let followers):
				let populatedFollowers = followers.map { user -> GHUser in
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
