//
//  ImageRepository.swift
//  ToDoApp
//
//  Created by hong on 2023/08/11.
//  Copyright © 2023 co.godo. All rights reserved.
//

import UIKit
import NetworkProvider
import LocalProvider

protocol ImageRepositoryProtocol {
    func getPngData(_ viewController: UIViewController) async throws -> Data
    func getPressedData(_ viewController: UIViewController, compressionRatio: CGFloat) async throws -> Data
    func getCatAndDogRandomImageDatas(_ type: CatAndDogAPI) async throws -> [Data]
    func fetchCachedData(_ type: LocalTargetType) -> [Data]?
}

struct ImageRepository: ImageRepositoryProtocol {
    
    private enum ImageRpositoryError: LocalizedError {
        case imageConvertError
        case catAndDogResponseConvertError
        
        var errorDescription: String? {
            switch self {
            case .imageConvertError:
                return "이미지 변환에 실패했습니다."
            case .catAndDogResponseConvertError:
                return "개, 고양이 response 정보가 옳지 않습니다."
            }
        }
    }
    
    private let imageProvider: ImageProviderProtocol
    private let catAndDogProvider: NetworkProviderProtocol
    private let anyProvider: NetworkProviderProtocol
    private let nsChacheProvider: LocalProviderProtocol
    private let plistProvider: LocalProviderProtocol
    private let userdefaultsProvier: LocalProviderProtocol
    
    init(
        imageProvider: ImageProviderProtocol,
        catAndDogProvider: NetworkProviderProtocol,
        anyProvider: NetworkProviderProtocol,
        nsChacheProvider: LocalProviderProtocol,
        plistProvider: LocalProviderProtocol,
        userdefaultsProvier: LocalProviderProtocol
    ) {
        self.imageProvider = imageProvider
        self.catAndDogProvider = catAndDogProvider
        self.anyProvider = anyProvider
        self.nsChacheProvider = nsChacheProvider
        self.plistProvider = plistProvider
        self.userdefaultsProvier = userdefaultsProvier
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
    
    private func getCatAndDogRandomImages(_ type: CatAndDogAPI) async throws -> [CatAndDogAPIResponse] {
        return try await catAndDogProvider.request(type).toObject([CatAndDogAPIResponse].self)
    }
    
    private func getImageDataFromNetwork(_ url: String) async throws -> Data {
        return try await anyProvider.request(AnyAPI.any(url: url, httpMethod: .get, data: nil, headers: nil, paramters: nil))
    }
     
    func getCatAndDogRandomImageDatas(_ type: CatAndDogAPI) async throws -> [Data] {
        do {
            let catAndDogRandomImages = try await getCatAndDogRandomImages(type)
            var imageDatas: [Data] = []
            for catAndDogRandomImage in catAndDogRandomImages {
                let imageData = try await getImageDataFromNetwork(catAndDogRandomImage.url)
                imageDatas.append(imageData)
            }
            switch type {
            case .catImageSearch:
                cachingData(.catImage(imageDatas))
            case .dogImageSearch:
                cachingData(.dogImage(imageDatas))
            }
            return imageDatas
        } catch {
            throw error
        }
    }
    
    private func cachingData(_ type: LocalTargetType) {
        do {
            try nsChacheProvider.create(type)
            try userdefaultsProvier.create(type)
            try plistProvider.create(type)
        } catch {
            print(error)
        }
    }
    
    func fetchCachedData(_ type: LocalTargetType) -> [Data]? {
        if let cachedDatas = try? nsChacheProvider.read(type) {
            return cachedDatas as? [Data]
        }
        if let userdefaultsCachedDatas = try? userdefaultsProvier.read(type) {
            return userdefaultsCachedDatas as? [Data]
        }
        if let plistCachedDatas = try? plistProvider.read(type) {
            return plistCachedDatas as? [Data]
        }
        return nil
    }
}
