//
//  RealmHelper.swift
//  GitHubProfileExplorer
//
//  Created by Ai on 3/27/22.
//

import UIKit
import RealmSwift

protocol RealmHelperType: AnyObject {
	var realm: Realm { get set }
	func validRealmUserForUsername(username: String) -> GHUser?
	func saveUser(user: GHUser)
}

final class RealmHelper: RealmHelperType {
	var realm: Realm

	init(realm: Realm) {
		self.realm = realm
	}
	
	func validRealmUserForUsername(username: String) -> GHUser? {
		return realm
			.objects(RealmCachedUser.self)
			.first(where: { realmCachedUser in
				realmCachedUser.toCachedUser().user.username?.lowercased() == username.lowercased() &&
				realmCachedUser.insertionDate < Date().addingTimeInterval(Constants.cachedContentExpiration)
			})?
			.toCachedUser()
			.user
	}
	
	func saveUser(user: GHUser) {
		guard let username = user.username,
			  let photoURL = user.photoURL,
			  let profileURL = user.profileURL,
			  let followersURL = user.followersURL,
			  let photo = user.photo else { return }
		let realmCachedUser = RealmCachedUser()
		realmCachedUser.username = username
		realmCachedUser.photoURL = photoURL.absoluteString
		realmCachedUser.profileURL = profileURL.absoluteString
		realmCachedUser.followersURL = followersURL.absoluteString
		realmCachedUser.photo = photo.jpegData(compressionQuality: 100) ?? Data()
		realmCachedUser.insertionDate = Date()
		// Intentionally not storing followers, since they are the property most likely to change.
		// Instead of storing them, I'm fetching them every time a userModel is instantiated so they're up to date.
		
		DispatchQueue.main.async {
			try! self.realm.write {
				self.realm.add(realmCachedUser)
			}
		}
	}
}
