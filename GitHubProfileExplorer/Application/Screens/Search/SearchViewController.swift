//
//  SearchViewController.swift
//  GitHubProfileExplorer
//
//  Created by Ai on 3/24/22.
//

import UIKit

protocol SearchViewControllerDelegate {
	func didPressGoWithString(string: String)
}

protocol SearchViewControllerType: AnyObject {
	var delegate: SearchViewControllerDelegate? { get set }
	func submitSearch()
}

class SearchViewController:
	UIViewController,
	UITextFieldDelegate,
	UISearchBarDelegate,
	SearchViewControllerType {
	
	var delegate: SearchViewControllerDelegate?
	
	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var goButton: UIButton! {
		didSet {
			goButton.layer.cornerRadius = 8
		}
	}
	@IBAction func goButtonPressed(_ sender: Any) {
		submitSearch()
	}
		
	override func viewDidLoad() {
		super.viewDidLoad()
		goButton.isEnabled = false
		searchBar.searchTextField.delegate = self
		searchBar.delegate = self
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.setNavigationBarHidden(true, animated: false)
		searchBar.becomeFirstResponder()
	}
	
	func submitSearch() {
		guard let searchString = searchBar.text else { return }
		self.delegate?.didPressGoWithString(string: searchString)
	}

	//MARK: - UITextFieldDelegate
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		submitSearch()
		return true
	}
	
	//MARK: - UISearchBarDelegate

	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		goButton.isEnabled = (searchBar.searchTextField.text?.count ?? 0) > 0
	}
	
	//MARK: - UIViewControllerDelegate

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		view.endEditing(true)
	}
}

