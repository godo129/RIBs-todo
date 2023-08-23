//
//  NetworkProvider.swift
//  ToDoApp
//
//  Created by hong on 2023/08/23.
//  Copyright © 2023 co.godo. All rights reserved.
//

import Foundation
import Combine

public struct NetworkProvider<T: RemoteTargetType> {
    
    private enum NetworkProviderError: LocalizedError {
        case urlRequestDoesntExist
        case urlResponseDeosntExist
        case responseFailed
        case responseDataDeosntExist
    }
    
    public func request(_ type: T) async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            guard let urlReqeust = type.asRequest() else {
                continuation.resume(throwing: NetworkProviderError.urlRequestDoesntExist)
                return
            }
            let task = URLSession.shared.dataTask(with: urlReqeust) { data, response, error in
                print("--------")
                print("🪂🪂🪂🪂")
                print("Response")
                print(urlReqeust.description)
                if let error {
                    print("error: \(error)")
                    continuation.resume(throwing: error)
                    return
                }
                guard let responseStatus = response as? HTTPURLResponse else {
                    continuation.resume(throwing: NetworkProviderError.urlResponseDeosntExist)
                    return
                }
                print("reponseStatusCode: \(responseStatus.statusCode)")
                if responseStatus.statusCode != 200 {
                    continuation.resume(throwing: NetworkProviderError.responseFailed)
                    return
                }
                guard let data else {
                    continuation.resume(throwing: NetworkProviderError.responseDataDeosntExist)
                    return
                }
                print("responseData: \(String(data: data, encoding: .utf8) ?? "")")
                
                continuation.resume(returning: data)
            }
            task.resume()
        }
    }
}
