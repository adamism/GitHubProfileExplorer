//
//  UserViewController.swift
//  GitHubProfileExplorer
//
//  Created by Ai on 3/24/22.
//

import UIKit


final class FollowerTableViewCell: UITableViewCell {
	@IBOutlet weak var photoImageView: UIImageView!
	@IBOutlet weak var usernameLabel: UILabel!
	@IBOutlet weak var followersCountLabel: UILabel!
	
	override func awakeFromNib() {
		photoImageView.layer.cornerRadius = photoImageView.frame.width / 2
	}
}

protocol UserViewControllerDelegate {
	func didSelectRowForUser(username: String)
}

final class UserViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
	var delegate: UserViewControllerDelegate?
	var userModel: UserModel?
	var followerData: [User]? {
		didSet {
			followers = followerData
		}
	}
	var followers: [User]? {
		didSet {
			DispatchQueue.main.async { [self] in
				self.tableView.reloadData()
			}
		}
	}
	
	@IBOutlet weak var photoImageView: UIImageView! {
		didSet {
			photoImageView.layer.cornerRadius = photoImageView.frame.width / 2
		}
	}
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
		userModel?.fetchUser { user in
			DispatchQueue.main.async { [self] in
				self.photoImageView.image = user.photo
				self.usernameLabel.text = user.username
				self.followersLabel.text = user.followers?.count.description ?? "0"
				self.followerData = user.followers
			}
		}
	}
	
	//MARK: - UITableViewDataSource
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		followers?.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(
			withIdentifier: "followerTableViewCell",
			for: indexPath) as! FollowerTableViewCell
		cell.usernameLabel.text = followers?[indexPath.row].username
		cell.photoImageView.image = followers?[indexPath.row].photo
		cell.followersCountLabel.text = followers?[indexPath.row].followers?.count.description ?? "0" + " followers"
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let username = followers?[indexPath.row].username else { return }
		delegate?.didSelectRowForUser(username: username)
	}
	
	//MARK: - UISearchBarDelegate
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
