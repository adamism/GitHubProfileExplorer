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

final class Router: RouterType, SearchViewControllerDelegate, UserViewControllerDelegate {
	var dependencyProvider: DependencyProviderType
	var navController: UINavigationController
	var searchViewController: SearchViewController
	var realmHelper: RealmHelper

	init(window: UIWindow,
		 navController: UINavigationController,
		 dependencyProvider: DependencyProvider,
		 realmHelper: RealmHelper) {
		self.navController = navController
		self.realmHelper = realmHelper
		self.dependencyProvider = dependencyProvider
		
		self.searchViewController = dependencyProvider.makeSearchViewController()
		self.searchViewController.delegate = self
		self.navController.viewControllers = [searchViewController]
		window.rootViewController = navController
		window.makeKeyAndVisible()
	}
	
	// MARK: - SearchViewControllerDelegate
	
	func didPressGoWithString(string: String) {
		let userViewController = dependencyProvider.makeUserViewController(searchString: string)
		userViewController.delegate = self
		navController.pushViewController(userViewController, animated: true)
	}
	
	// MARK: - UserViewControllerDelegate
	
	func didSelectRowForUser(username: String) {
		let userViewController = dependencyProvider.makeUserViewController(searchString: username)
		userViewController.delegate = self
		navController.pushViewController(userViewController, animated: true)
	}
}
