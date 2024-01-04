import Foundation

class CloudDocumentManager {
  static let sharedInstance = CloudDocumentManager() // Singleton
  struct DocumentsDirectory {
    static let localDocumentsURL: URL? = FileManager.documentsDirectory
    static let iCloudDocumentsURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents")
  }

  func isCloudEnabled() -> Bool {
    if DocumentsDirectory.iCloudDocumentsURL != nil { return true }
    else { return false }
  }

  /// Delete all files at URL
  func deleteFilesInDirectory(url: URL?) {
    let fileManager = FileManager.default
    let enumerator = fileManager.enumerator(atPath: url!.path)
    while let file = enumerator?.nextObject() as? String {
      do {
        let furl = url!.appendingPathComponent(file)
        var isDir : ObjCBool = false
        if fileManager.fileExists(atPath: furl.path, isDirectory: &isDir) {
          if isDir.boolValue {
            deleteFilesInDirectory(url: furl)
            try fileManager.removeItem(at: furl)
          }
          else {
            try fileManager.removeItem(at: furl)
          }
        }
        print("Delete " + file + " at dir " + url!.appendingPathComponent(file).relativeString)
      } catch let error as NSError {
        print("Failed deleting files : \(error)")
      }
    }
  }

  /// Move local files to iCloud
  /// iCloud will be cleared before any operation
  /// No data merging
  func moveFileToCloud(completion: (Int) -> ()) {
    var copied : Int = 0
    if isCloudEnabled() {
      do {
        if(!FileManager.default.fileExists(atPath: DocumentsDirectory.iCloudDocumentsURL!.path)) {
          try FileManager.default.createDirectory(atPath: DocumentsDirectory.iCloudDocumentsURL!.path, withIntermediateDirectories: true, attributes: nil)
        }
        
        deleteFilesInDirectory(url: DocumentsDirectory.iCloudDocumentsURL!)
        
        let fileManager = FileManager.default
        let enumerator = fileManager.enumerator(atPath: DocumentsDirectory.localDocumentsURL!.path)
        while let file = enumerator?.nextObject() as? String {
          do {
            print("Move " + file + " to cloud dir " + String(DocumentsDirectory.iCloudDocumentsURL!.appendingPathComponent(file).relativeString))
            
            try fileManager.copyItem(at: DocumentsDirectory.localDocumentsURL!.appendingPathComponent(file), to: DocumentsDirectory.iCloudDocumentsURL!.appendingPathComponent(file))
            copied = copied + 1
          } catch let error as NSError {
            print("Failed to move file to Cloud : \(error)")
          }
        }
      }
      catch {
        print("fail");
      }
    }
    completion(copied)
  }

  /// Move iCloud files to local directory
  /// Local dir will be cleared
  /// No data merging
  func moveFileToLocal( completion: (Int) -> ())  {
    var copied : Int = 0
    if isCloudEnabled() {
      deleteFilesInDirectory(url: DocumentsDirectory.localDocumentsURL)
      let fileManager = FileManager.default
      let enumerator = fileManager.enumerator(atPath: DocumentsDirectory.iCloudDocumentsURL!.path)
      while let file = enumerator?.nextObject() as? String {
        do {
          print("Move " + file + " to local dir " + String(DocumentsDirectory.localDocumentsURL!.appendingPathComponent(file).relativeString))
          
          var destFile = file
          let myURL = DocumentsDirectory.iCloudDocumentsURL!.appendingPathComponent(file)
          var lastPathComponent = myURL.lastPathComponent
          if lastPathComponent.contains(".icloud") {
            do {
              try fileManager.startDownloadingUbiquitousItem(at: myURL )
            } catch {
              print("Unexpected error: \(error).")
              continue
            }
            
            // Delete the "." which is at the beginning of the icloud file name
            lastPathComponent.removeFirst()
            // Get folder path without the last component
            let folderPath = myURL.deletingLastPathComponent().path
            // Create the downloaded file path
            var destFileParts = destFile.components(separatedBy: "/")
            destFileParts[destFileParts.count-1] = lastPathComponent.replacingOccurrences(of: ".icloud", with: "")
            destFile = destFileParts[0]
            if destFileParts.count > 1 {
              for d in 1..<destFileParts.count {
                destFile = destFile + "/" + destFileParts[d]
              }
            }
            let downloadedFilePath = folderPath + "/" + lastPathComponent.replacingOccurrences(of: ".icloud", with: "")
            var isDownloaded = false
            // Create a loop until isDownloaded is true
            while !isDownloaded {
              // Check if the file is downloaded
              if fileManager.fileExists(atPath: downloadedFilePath) {
                isDownloaded = true
              }
              else {
                usleep(10000)
              }
            }
          }
          
          try fileManager.copyItem(at: DocumentsDirectory.iCloudDocumentsURL!.appendingPathComponent(destFile), to: DocumentsDirectory.localDocumentsURL!.appendingPathComponent(destFile))
          
          copied = copied + 1
        } catch let error as NSError {
          print("Failed to move file to local dir : \(error)")
        }
      }
    }
    completion(copied)
  }
}
