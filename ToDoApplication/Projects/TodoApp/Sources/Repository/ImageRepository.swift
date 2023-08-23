//
//  ImageRepository.swift
//  ToDoApp
//
//  Created by hong on 2023/08/11.
//  Copyright © 2023 co.godo. All rights reserved.
//

import UIKit

protocol ImageRepositoryProtocol {
    func getPngData(_ viewController: UIViewController) async throws -> Data
    func getPressedData(_ viewController: UIViewController, compressionRatio: CGFloat) async throws -> Data
}

struct ImageRepository: ImageRepositoryProtocol {
    enum ImageRpositoryError: LocalizedError {
        case imageConvertError
        
        var errorDescription: String? {
            switch self {
            case .imageConvertError:
                return "이미지 변환에 실패했습니다."
            }
        }
    }
    
    private let imageProvider: ImageProviderProtocol
    init(imageProvider: ImageProviderProtocol) {
        self.imageProvider = imageProvider
    }
    
    func getPngData(_ viewController: UIViewController) async throws -> Data {
        let imageData: Data
        do {
            guard let imageConvertedData = try await imageProvider.pickImage(viewController).pngData() else {
                throw ImageRpositoryError.imageConvertError
            }
            imageData = imageConvertedData
        } catch {
            throw error
        }
        return imageData
    }
 
    func getPressedData(_ viewController: UIViewController, compressionRatio: CGFloat) async throws -> Data {
        let imageData: Data
        do {
            guard let imageConvertedData = try await imageProvider.pickImage(viewController).jpegData(compressionQuality: compressionRatio) else {
                throw ImageRpositoryError.imageConvertError
            }
            imageData = imageConvertedData
        } catch {
            throw error
        }
        return imageData
    }
}
