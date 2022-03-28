//
//  DependencyProvider.swift
//  GitHubProfileExplorer
//
//  Created by Ai on 3/24/22.
//

import UIKit

protocol DependencyProviderType {
	func makeSearchViewController() -> SearchViewController
	func makeUserViewController(with userModel: UserModel) -> UserViewController
	func makeUserModel(searchString: String) -> UserModel
}

final class DependencyProvider: DependencyProviderType {
	
	func makeSearchViewController() -> SearchViewController {
		let storyboard = UIStoryboard(name: "Search", bundle: nil)
		let searchViewController = storyboard
			.instantiateViewController(withIdentifier: "searchViewController") as! SearchViewController
		return searchViewController
	}
	
	func makeUserViewController(with userModel: UserModel) -> UserViewController {
		let storyboard = UIStoryboard(name: "User", bundle: nil)
		let userViewController = storyboard
			.instantiateViewController(withIdentifier: "userViewController") as! UserViewController
		userViewController.userModel = userModel
		return userViewController
	}
	
	func makeUserModel(searchString: String) -> UserModel {
		UserModel(searchString: searchString)
	}
}
