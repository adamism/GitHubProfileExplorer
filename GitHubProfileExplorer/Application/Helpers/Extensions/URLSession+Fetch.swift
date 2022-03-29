//
//  URLSession+Fetch.swift
//  GitHubProfileExplorer
//
//  Created by Ai on 3/25/22.
//

import UIKit

extension URLSession {
  func fetchData<T: Decodable>(for url: URL, completion: @escaping (Result<T, Error>) -> Void) {
	var request = URLRequest(url: url)
	
	// I'm curious what your other submissions do in this scenario, where I want to make sure
	// you all can run this as many times as you want from your IP without hitting the rate limit..
	// But I also don't want to commit secure info into a public repo!
	request.httpMethod = "GET"
	request.setValue("token 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", forHTTPHeaderField:"Authorization")

	self.dataTask(with: request) { (data, response, error) in
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
