//
//  CachedUser.swift
//  GitHubProfileExplorer
//
//  Created by Ai on 3/29/22.
//

import UIKit
import RealmSwift

struct CachedUser {
	var user: GHUser
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
		let user = GHUser(
			username: username,
			photoURL: URL(string: photoURL),
			profileURL: URL(string: profileURL),
			followersURL: URL(string: followersURL),
			photo: UIImage(data: photo),
			followers: [])
		
		return CachedUser(user: user, insertionDate: insertionDate)
	}
}
