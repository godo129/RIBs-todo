//
//  ImageProvider.swift
//  ToDoApp
//
//  Created by hong on 2023/08/03.
//

import UIKit
import PhotosUI
import Combine

protocol ImageProviderProtocol {
    func pickImage(_ viewController: UIViewController) async throws -> UIImage
}

final class ImageProvider: NSObject, ImageProviderProtocol {
    
    enum ImageProviderError: LocalizedError {
        case phpickerAuthorizationNotAuthoried
        case imageCantFetch
        
        var errorDescription: String? {
            switch self {
            case .phpickerAuthorizationNotAuthoried:
                return "이미지 선택권한이 없습니다.\n설정에서 권한 제한을 풀어주세요."
            case .imageCantFetch:
                return "이미지를 가져오는 데 오류가 발생했습니다."
            }
        }
    }
    
    private let imagePickerController: UIImagePickerController
    private let phpickerController: PHPickerViewController
    private var imageContinuation: CheckedContinuation<UIImage, Error>? = nil
    
    override init() {
        
        self.imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.modalPresentationStyle = .fullScreen
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .any(of: [.images, .livePhotos])
        self.phpickerController = PHPickerViewController(configuration: configuration)
        super.init()
        
        imagePickerController.delegate = self
        phpickerController.delegate = self
    }
    
    func pickImage(_ viewController: UIViewController) async throws -> UIImage {
        
        return try await withCheckedThrowingContinuation { continuation in
            Task {
                imageContinuation = continuation
                do {
                    if #available(iOS 14.0, *) {
                        try await phpickerAuthorization()
                        await viewController.present(phpickerController, animated: true)
                    } else {
                        await viewController.present(imagePickerController, animated: true)
                    }
                } catch let error {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    private func phpickerAuthorization() async throws {
        return try await withCheckedThrowingContinuation { continuation in
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                switch status {
                case .authorized, .limited:
                    continuation.resume(returning: ())
                default:
                    continuation.resume(throwing: ImageProviderError.phpickerAuthorizationNotAuthoried)
                }
            }
        }

    }
}

extension ImageProvider: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            picker.dismiss(animated: true) { [weak self] in
                    self?.imageContinuation?.resume(returning: image)
                    self?.imageContinuation = nil
            }
        }
    }
}

extension ImageProvider: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        if let itemProvider = results.last?.itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) { // 3
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in // 4
                if let image = image as? UIImage {
                    self?.imageContinuation?.resume(returning: image)
                    self?.imageContinuation = nil
                }
            }
                
        } else {
            imageContinuation?.resume(throwing: ImageProviderError.imageCantFetch)
            imageContinuation = nil
        }

    }
}
