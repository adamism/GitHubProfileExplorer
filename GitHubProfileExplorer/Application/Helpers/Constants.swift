//
//  Constants.swift
//  GitHubProfileExplorer
//
//  Created by Ai on 3/25/22.
//

import Foundation

struct Constants {
	static let baseURL = "https://api.github.com/"
	static let usersPath = "users/"
	static let cachedContentExpiration: TimeInterval = -300
	static let userNotFoundString = "No user found"
}
