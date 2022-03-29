//
//  DependencyProvider.swift
//  GitHubProfileExplorer
//
//  Created by Ai on 3/24/22.
//

import UIKit
import RealmSwift

protocol DependencyProviderType {
	var realmHelper: RealmHelper { get set }
	var urlSession: URLSession { get set }
	func makeRealmHelper(realm: Realm) -> RealmHelper
	func makeSearchViewController() -> SearchViewController
	func makeUserViewController(searchString: String) -> UserViewController
}

final class DependencyProvider: DependencyProviderType {
	
	var realmHelper: RealmHelper
	var urlSession: URLSession
	
	init(realm: Realm) {
		self.realmHelper = RealmHelper(realm: realm)
		urlSession = URLSession(configuration: .default)
	}
	
	func makeRealmHelper(realm: Realm) -> RealmHelper {
		RealmHelper(realm: realm)
	}
	
	func makeRouter(window: UIWindow, navController: UINavigationController) -> Router {
		Router(
			window: window,
			navController: navController,
			dependencyProvider: self,
			realmHelper: realmHelper)
	}
	
 	func makeSearchViewController() -> SearchViewController {
		let storyboard = UIStoryboard(name: "Search", bundle: nil)
		let searchViewController = storyboard
			.instantiateViewController(withIdentifier: "searchViewController") as! SearchViewController
		
		return searchViewController
	}
	
	func makeUserViewController(searchString: String) -> UserViewController {
		let storyboard = UIStoryboard(name: "User", bundle: nil)
		let userViewController = storyboard
			.instantiateViewController(withIdentifier: "userViewController") as! UserViewController
		
		let userModel = UserModel(searchString: searchString, realmHelper: realmHelper, urlSession: urlSession)
		userViewController.userModel = userModel
		
		return userViewController
	}
}
