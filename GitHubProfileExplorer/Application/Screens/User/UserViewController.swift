//
//  UserViewController.swift
//  GitHubProfileExplorer
//
//  Created by Ai on 3/24/22.
//

import UIKit

protocol UserViewControllerDelegate {
	func didSelectRowForUser(username: String)
}

protocol UserViewControllerType {
	var delegate: UserViewControllerDelegate? { get set }
	var userModel: UserModel? { get set }
	var followerData: [GHUser]? { get set }
	var followers: [GHUser]? { get set }
}

final class UserViewController:
	UIViewController,
	UITableViewDataSource,
	UITableViewDelegate,
	UISearchBarDelegate,
	UserViewControllerType {
	var delegate: UserViewControllerDelegate?
	var userModel: UserModel?
	
	// In a State based architecture, this "followerData" cache would be stored within
	// the Model, and used to compare with before being inserted into a
	// returned ViewModel or wired directly through an Rx TableViewDataSourceDriver.
	var followerData: [GHUser]? {
		didSet {
			followers = followerData
		}
	}
	var followers: [GHUser]? {
		didSet {
			DispatchQueue.main.async { [self] in
				self.tableView.reloadData()
			}
		}
	}
	
	@IBOutlet weak var photoImageView: PhotoImageView!
	@IBOutlet weak var usernameTitleLabel: UILabel!
	@IBOutlet weak var usernameLabel: UILabel!
	@IBOutlet weak var followersTitleLabel: UILabel!
	@IBOutlet weak var followersLabel: UILabel!
	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var tableView: UITableView!
		
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.navigationBar.barTintColor = .systemBlue
		navigationController?.navigationBar.tintColor = .white
		navigationController?.navigationBar.isTranslucent = false
		navigationController?.navigationBar.shadowImage = UIImage()
		navigationController?.setNavigationBarHidden(false, animated: false)
	}
	
	override func viewDidLoad() {
		tableView.dataSource = self
		tableView.delegate = self
		searchBar.delegate = self
		tableView.keyboardDismissMode = .onDrag
		userModel?.fetchUser { (userFound, user) in
			// Typically, logic like this is best kept out of the VC.
			// In a more robust architecture, these values would be returned in
			// an observable ViewModel.
			DispatchQueue.main.async { [self] in
				if userFound, let user = user {
					self.photoImageView.image = user.photo
					self.usernameLabel.text = user.username
					self.followersLabel.text = user.followers?.count.description ?? "0"
					self.followerData = user.followers
				} else {
					self.usernameLabel.text = Constants.userNotFoundString
				}
			}
		}
	}
	
	//MARK: - UITableViewDataSource
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		followers?.count ?? 0
	}
	
	// With a more robust RxSwift implementation, I would utilize an
	// RxTableViewSectionedAnimatedDataSource here. This would be accomplished
	// by instantiating a Driver on the Model, fed by a subscription to an observable
	// of the API endpoint.
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(
			withIdentifier: "followerTableViewCell",
			for: indexPath) as! FollowerTableViewCell
		cell.usernameLabel.text = followers?[indexPath.row].username
		cell.photoImageView.image = followers?[indexPath.row].photo
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		guard let username = followers?[indexPath.row].username else { return }
		delegate?.didSelectRowForUser(username: username)
	}
	
	//MARK: - UISearchBarDelegate
	
	// Again, with an observable implementation, I would create a local observable of the
	// searchBar's text field, mapped through a presenter, to the model, asking the transformer
	// for the filtered results.
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		if let searchBarText = searchBar.searchTextField.text?.lowercased(), !searchBarText.isEmpty {
			followers = followerData?.filter { $0.username?.contains(searchBarText) ?? false }
		} else {
			followers = followerData
		}
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		view.endEditing(true)
	}
	
	//MARK: - UIViewControllerDelegate

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		view.endEditing(true)
	}
}
