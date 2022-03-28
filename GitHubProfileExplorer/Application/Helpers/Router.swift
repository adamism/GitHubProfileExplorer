//
//  Router.swift
//  GitHubProfileExplorer
//
//  Created by Ai on 3/24/22.
//

import UIKit

final class Router: SearchViewControllerDelegate, UserViewControllerDelegate {
	var dependencyProvider: DependencyProviderType
	var navController: UINavigationController
	var searchViewController: SearchViewController

	init(window: UIWindow, dependencyProvider: DependencyProvider) {
		self.dependencyProvider = DependencyProvider()
		self.navController = UINavigationController()
		self.searchViewController = dependencyProvider.makeSearchViewController()
		self.searchViewController.delegate = self
		
		navController.viewControllers = [searchViewController]
		window.rootViewController = navController
		window.makeKeyAndVisible()
	}
	
	// MARK: - SearchViewControllerDelegate
	
	func didPressGoWithString(string: String) {
		let userModel = dependencyProvider.makeUserModel(searchString: string)
		let userViewController = dependencyProvider.makeUserViewController(with: userModel)
		userViewController.delegate = self
		navController.pushViewController(userViewController, animated: true)
	}
	
	// MARK: - UserViewControllerDelegate
	func didSelectRowForUser(username: String) {
		let userModel = dependencyProvider.makeUserModel(searchString: username)
		let userViewController = dependencyProvider.makeUserViewController(with: userModel)
		userViewController.delegate = self
		navController.pushViewController(userViewController, animated: true)
	}
}
