//
//  RealmHelper.swift
//  GitHubProfileExplorer
//
//  Created by Ai on 3/27/22.
//

import UIKit
import RealmSwift

struct CachedUser {
	var user: User
	var insertionDate: Date
}

class RealmCachedUser: Object {
	@objc dynamic var insertionDate: Date = Date()
	@objc dynamic var username: String = ""
	@objc dynamic var photoURL: String = ""
	@objc dynamic var profileURL: String = ""
	@objc dynamic var followersURL: String = ""
	@objc dynamic var photo: Data = Data()
	
	func toCachedUser() -> CachedUser {
		let user = User(
			username: username,
			photoURL: URL(string: photoURL),
			profileURL: URL(string: profileURL),
			followersURL: URL(string: followersURL),
			photo: UIImage(data: photo),
			followers: [])
		
		return CachedUser(user: user, insertionDate: insertionDate)
	}
}

final class RealmHelper {
	var realm: Realm

	init(realm: Realm) {
		self.realm = realm
	}
	
	func validRealmUserForUsername(username: String) -> User? {
		return realm
			.objects(RealmCachedUser.self)
			.first(where: { realmCachedUser in
				realmCachedUser.toCachedUser().user.username?.lowercased() == username.lowercased() &&
				realmCachedUser.insertionDate < Date().addingTimeInterval(Constants.cachedContentExpiration)
			})?
			.toCachedUser()
			.user
	}
	
	func saveUser(user: User) {
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
