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
    var imageUrls = [String](repeating: "", count: images.count)
    var uploadedImagesCount = 0
    for (i, image) in images.enumerated() {
      uploadImage(image: image, type: type) { imageUrl in
        imageUrls[i] = imageUrl
        uploadedImagesCount += 1
        if uploadedImagesCount == images.count {
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
    let ref = Storage.storage().reference(forURL: imageUrl)
    ref.delete { error in
      if let error = error {
        print(error)
      } else {
        print("Successfully deleted image")
      }
    }
  }
}
