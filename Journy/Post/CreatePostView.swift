import SwiftUI
import PhotosUI
import Photos
import Firebase

struct CreatePostView: View {
  @ObservedObject var model: PostViewModel
  @State private var caption: String = "test"
  @State private var selectedItems = [PhotosPickerItem]()
  @State private var selectedImages = [UIImage]()
  @State private var date = Date.now
  @Environment(\.dismiss) var dismiss
  
  var body: some View {
    NavigationView {
      ScrollView(.vertical, showsIndicators: false) {
        TextField("Caption", text: $caption)
          .padding()
        
        if !selectedImages.isEmpty {
          TabView {
            ForEach(selectedImages, id: \.self) { image in
              Image(uiImage: image)
                .resizable()
                .scaledToFill()
            }
          }
          .tabViewStyle(PageTabViewStyle())
          .frame(width: 250, height: 300)
          .cornerRadius(12)
        }
        
        PhotosPicker(
          selection: $selectedItems,
          matching: .images,
          photoLibrary: .shared()) {
            Text("Upload photo")
          }
          .onChange(of: selectedItems) { newItems in
            newItems.forEach { item in
              if let localID = item.itemIdentifier {
                let result = PHAsset.fetchAssets(withLocalIdentifiers: [localID], options: nil)
                if let asset = result.firstObject, let creationDate = asset.creationDate {
                  date = creationDate // todo: update to only the most recent images date
                }
              }
              
              Task {
                selectedImages = [UIImage]()
                guard let data = try? await item.loadTransferable(type: Data.self) else { return }
                guard let image = UIImage(data: data) else { return }
                selectedImages.append(image)
              }
            }
          }
        
        DatePicker("", selection: $date, displayedComponents: .date)
          .labelsHidden()
          .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
      }
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button("Cancel") {
            dismiss()
          }
        }
        ToolbarItem(placement: .navigationBarTrailing) {
          Button("Create") {
            let type = self.selectedImages.isEmpty ? PostType.text : PostType.photo
            model.createPost(timestamp: Timestamp(date: date), type: type, caption: self.caption, images: selectedImages, completion: { _ in
              dismiss()
            })
          }
          .disabled(caption.isEmpty && selectedItems.isEmpty)
        }
      }
    }
  }
}

#Preview {
  CreatePostView(model: PostViewModel(passionUid: Passion.example.id!, passionName: Passion.example.name))
}
