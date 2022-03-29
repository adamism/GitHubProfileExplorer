//
//  URLSession+Fetch.swift
//  GitHubProfileExplorer
//
//  Created by Ai on 3/25/22.
//

import UIKit

extension URLSession {
  func fetchData<T: Decodable>(for url: URL, completion: @escaping (Result<T, Error>) -> Void) {
	// I'm curious what your other submissions do in this scenario, where I want to make sure
	// you all can run this as many times as you want from your IP without hitting the rate limit.
	// But I also don't want to commit secure info into a public repo!
	
	// That's pretty cool.. Github actually just noticed the token, and revoked it!
	// Looks like without implementing an auth flow, the users endpoint is capped to
	// 60 anonymous API calls, per IP, per day.

	self.dataTask(with: url) { (data, response, error) in
	  if let error = error {
		completion(.failure(error))
	  }

	  if let data = data {
		do {
		  let object = try JSONDecoder().decode(T.self, from: data)
		  completion(.success(object))
		} catch let decoderError {
		  completion(.failure(decoderError))
		}
	  }
	}.resume()
  }
}
