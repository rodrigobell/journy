import UIKit
import FirebaseStorage

enum ImageType {
  case profile
  case post
  
  var filePath: StorageReference {
    let filename = NSUUID().uuidString
    switch self {
    case .profile:
      return Storage.storage().reference(withPath: "/profile_images/\(filename)")
    case .post:
      return Storage.storage().reference(withPath: "/post_images/\(filename)")
    }
  }
}

struct ImageService {
  static func uploadImages(images: [UIImage], type: ImageType, completion: @escaping(Array<String>) -> Void) {
    // TODO: Upload in parallel
    var imageUrls = [String]()
    for image in images {
      uploadImage(image: image, type: type) { imageUrl in
        imageUrls.append(imageUrl)
        if imageUrls.count == images.count {
          completion(imageUrls)
        }
      }
    }
  }
  
  static func uploadImage(image: UIImage, type: ImageType, completion: @escaping(String) -> Void) {
    guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
    let ref = type.filePath
    ref.putData(imageData, metadata: nil) { _, error in
      if let error = error {
        print("DEBUG: Failed to upload image \(error.localizedDescription)")
        return
      } else {
        print("Successfully uploaded image")
      }
      
      ref.downloadURL { url, _ in
        guard let imageUrl = url?.absoluteString else { return }
        completion(imageUrl)
      }
    }
  }
  
  static func deleteImage(imageUrl: String, type: ImageType) {
    let ref = type.filePath
    ref.delete { error in
      if let error = error {
        print(error)
      } else {
        print("Successfully deleted image")
      }
    }
  }
}
