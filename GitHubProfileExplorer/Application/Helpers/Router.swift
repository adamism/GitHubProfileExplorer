//
//  Router.swift
//  GitHubProfileExplorer
//
//  Created by Ai on 3/24/22.
//

import UIKit
import RealmSwift

protocol RouterType: AnyObject {
	var dependencyProvider: DependencyProviderType { get set }
	var navController: UINavigationController { get set }
	var searchViewController: SearchViewController { get set }
	var realmHelper: RealmHelper { get set }
}

final class Router: SearchViewControllerDelegate, UserViewControllerDelegate {
	var dependencyProvider: DependencyProviderType
	var navController: UINavigationController
	var searchViewController: SearchViewController
	var realmHelper: RealmHelper

	init(window: UIWindow,
		 navController: UINavigationController,
		 dependencyProvider: DependencyProvider,
		 realmHelper: RealmHelper) {
		self.navController = navController
		self.dependencyProvider = DependencyProvider()
		self.searchViewController = dependencyProvider.makeSearchViewController()
		self.realmHelper = realmHelper
		self.searchViewController.delegate = self
		
		self.navController.viewControllers = [searchViewController]
		window.rootViewController = navController
		window.makeKeyAndVisible()
	}
	
	// MARK: - SearchViewControllerDelegate
	
	func didPressGoWithString(string: String) {
		let userModel = dependencyProvider.makeUserModel(searchString: string, realmHelper: realmHelper)
		let userViewController = dependencyProvider.makeUserViewController(userModel: userModel)
		userViewController.delegate = self
		navController.pushViewController(userViewController, animated: true)
	}
	
	// MARK: - UserViewControllerDelegate
	
	func didSelectRowForUser(username: String) {
		let userModel = dependencyProvider.makeUserModel(searchString: username, realmHelper: realmHelper)
		let userViewController = dependencyProvider.makeUserViewController(userModel: userModel)
		userViewController.delegate = self
		navController.pushViewController(userViewController, animated: true)
	}
}
