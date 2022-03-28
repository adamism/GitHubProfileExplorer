//
//  DependencyProvider.swift
//  GitHubProfileExplorer
//
//  Created by Ai on 3/24/22.
//

import UIKit
import RealmSwift

protocol DependencyProviderType {
	func makeRealmHelper(realm: Realm) -> RealmHelper
	func makeSearchViewController() -> SearchViewController
	func makeUserViewController(userModel: UserModel) -> UserViewController
	func makeUserModel(searchString: String, realmHelper: RealmHelper) -> UserModel
}

final class DependencyProvider: DependencyProviderType {
	
	func makeRealmHelper(realm: Realm) -> RealmHelper {
		RealmHelper(realm: realm)
	}
	
 	func makeSearchViewController() -> SearchViewController {
		let storyboard = UIStoryboard(name: "Search", bundle: nil)
		let searchViewController = storyboard
			.instantiateViewController(withIdentifier: "searchViewController") as! SearchViewController
		return searchViewController
	}
	
	func makeUserViewController(userModel: UserModel) -> UserViewController {
		let storyboard = UIStoryboard(name: "User", bundle: nil)
		let userViewController = storyboard
			.instantiateViewController(withIdentifier: "userViewController") as! UserViewController
		userViewController.userModel = userModel
		return userViewController
	}
	
	func makeUserModel(searchString: String, realmHelper: RealmHelper) -> UserModel {
		UserModel(searchString: searchString, realmHelper: realmHelper)
	}
}
