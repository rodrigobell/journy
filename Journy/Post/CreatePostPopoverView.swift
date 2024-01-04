import SwiftUI
import PhotosUI


struct CreatePostPopoverView: View {
  @ObservedObject var model: PostGridViewModel
  @State private var caption: String = ""
  @State private var selectedItem: PhotosPickerItem? = nil
  @State private var imageData: Data? = nil
  @State private var date = Date.now
  @Environment(\.dismiss) var dismiss
  
  var body: some View {
    NavigationView {
      ScrollView(.vertical, showsIndicators: false) {
        DatePicker("", selection: $date, displayedComponents: .date)
          .labelsHidden()
          .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
        
        TextField("Caption", text: $caption)
          .padding()
        
        PhotosPicker(
          selection: $selectedItem,
          matching: .images,
          photoLibrary: .shared()) {
            Text("Upload photo")
          }
          .onChange(of: selectedItem) { newItem in
            Task {
              if let data = try? await newItem?.loadTransferable(type: Data.self) {
                imageData = data
              }
            }
          }
        if let imageData,
           let uiImage = UIImage(data: imageData) {
          Image(uiImage: uiImage)
            .resizable()
            .scaledToFit()
            .cornerRadius(12)
            .frame(width: 250, height: 250)
        }
      }
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button("Cancel") {
            dismiss()
          }
        }
        ToolbarItem(placement: .navigationBarTrailing) {
          Button("Create") {
            var newPost = Post()
            newPost.caption = caption
            if imageData != nil {
              newPost.type = .photo
              newPost.imageData = imageData
            }
            newPost.date = date
            model.add(post: newPost)
            dismiss()
          }
          .disabled(caption.isEmpty && imageData == nil)
        }
      }
    }
  }
}

#Preview {
  CreatePostPopoverView(model: PostGridViewModel(passion: .example))
}
