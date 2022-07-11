//
//  GithubClient.swift
//  GithubViewer
//
//  Created by Masami on 2022/07/08.
//

import Alamofire
import Foundation

/// Github API client
protocol GithubClient {

    /// API  request
    /// - Parameter endpoint: End point
    /// - Returns: Github Response
    func request<T: Decodable>(endpoint: EndPoint) async throws -> T

    /// API  request
    /// - Parameters:
    ///   - endpoint: End point
    ///   - parameter: Request parameter
    /// - Returns: Github Response
    func request<T: Decodable>(endpoint: EndPoint, parameter: RequestParameter?) async throws -> T

}

/// Github API client 実装部
final class GithubClientImpl: GithubClient {

    /// API  request
    /// - Parameter endpoint: End point
    /// - Returns: Github Response
    func request<T: Decodable>(endpoint: EndPoint) async throws -> T {
        return try await request(endpoint: endpoint, parameter: nil)
    }

    /// API  request
    /// - Parameters:
    ///   - endpoint: End point
    ///   - parameter: Request parameter
    /// - Returns: Github Response
    func request<T: Decodable>(endpoint: EndPoint, parameter: RequestParameter?) async throws -> T {
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<T, Error>) -> Void in
            let url: URLConvertible = endpoint.url
            AF.request(url,
                       method: .get,
                       parameters: parameter?.toDictionary(),
                       headers: .init(
                        [
                            .accept("application/vnd.github+json"),
                            .authorization(Environment.Key.githubToken.rawValue)
                        ]
                       )
            ).responseDecodable { (response: DataResponse<T, AFError>) in
                if let error = response.error {
                    continuation.resume(throwing: error)
                    return
                }
                guard let value = response.value else {
                    continuation.resume(throwing: APIClientError.notFoundResponse)
                    return
                }
                continuation.resume(returning: value)
            }
        }
    }

}
