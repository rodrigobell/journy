import SwiftUI
import PhotosUI
import Photos
import Firebase

struct CreatePostView: View {
  @ObservedObject var model: PostViewModel
  @State private var caption: String = ""
  @State private var selectedItems = [PhotosPickerItem]()
  @State private var selectedImages = [UIImage]()
  @State private var date = Date.now
  @State private var isCreatingPost = false
  @Environment(\.dismiss) var dismiss
  
  var body: some View {
    NavigationView {
      ScrollView(.vertical, showsIndicators: false) {
        VStack(spacing: 20) {
          TextField("Caption", text: $caption)
            .padding(EdgeInsets(top: 20, leading: 30, bottom: 0, trailing: 30))
          
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
            selectionBehavior: .ordered,
            matching: .images,
            photoLibrary: .shared()) {
              Text("Upload photo")
            }
            .onChange(of: selectedItems) { newItems in
              selectedImages = [UIImage](repeating: UIImage(), count: newItems.count)
              for (i, item) in newItems.enumerated() {
                if let localID = item.itemIdentifier {
                  let result = PHAsset.fetchAssets(withLocalIdentifiers: [localID], options: nil)
                  if let asset = result.firstObject, let creationDate = asset.creationDate {
                    date = creationDate
                  }
                }
                
                Task {
                  guard let data = try? await item.loadTransferable(type: Data.self) else { return }
                  guard let image = UIImage(data: data) else { return }
                  selectedImages[i] = image
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
              if self.isCreatingPost {
                return
              }
              self.isCreatingPost = true
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
}

#Preview {
  CreatePostView(model: PostViewModel(passionUid: Passion.example.id!, passionName: Passion.example.name))
}
