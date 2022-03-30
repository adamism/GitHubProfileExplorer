//
//  API.swift
//  GitHubProfileExplorer
//
//  Created by Ai on 3/29/22.
//

import Foundation


protocol APIType {
	func fetchUser(for url: URL, completion: @escaping (Result<GHUser, Error>) -> Void)
	func fetchFollowers(for url: URL, completion: @escaping (Result<[GHUser], Error>) -> Void)
}

final class API: APIType {
	var urlSession: URLSession
	
	init(urlSession: URLSession) {
		self.urlSession = urlSession
	}
	
	func fetchUser(for url: URL, completion: @escaping (Result<GHUser, Error>) -> Void) {
		urlSession.fetchData(for: url, completion: completion)
	}
	
	func fetchFollowers(for url: URL, completion: @escaping (Result<[GHUser], Error>) -> Void) {
		urlSession.fetchData(for: url, completion: completion)
	}

}
