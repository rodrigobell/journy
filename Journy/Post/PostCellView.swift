import SwiftUI

struct PostCellView: View {
  var post: Post
  
  var body: some View {
    switch post.type {
    case .photo:
      if let imageData = post.imageData,
         let uiImage = UIImage(data: imageData) {
        VStack(alignment: .leading) {
          Image(uiImage: uiImage)
            .resizable()
            .scaledToFit()
            .aspectRatio(contentMode: .fit)
            .clipped()
            .cornerRadius(12)
            .overlay(
              RoundedRectangle(cornerRadius: 12)
                .stroke(.gray, lineWidth: 1)
                .opacity(0.4)
            )
          if post.caption != "" {
            Text(post.caption)
              .font(.subheadline)
              .padding(EdgeInsets(top: 0, leading: 4, bottom: 2, trailing: 4))
          }
          DateTextView(post: post)
        }
      }
    case .text:
      VStack(alignment: .leading) {
        Text(post.caption)
          .font(.title3)
          .fontWeight(.medium)
          .padding(22)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .overlay(
            RoundedRectangle(cornerRadius: 12)
              .stroke(.gray, lineWidth: 1)
              .opacity(0.7)
          )
        DateTextView(post: post)
       }
    }
  }
  
  struct DateTextView: View {
    var post: Post
    
    var body: some View {
      Text(post.date.formatted(date: .abbreviated, time: .omitted))
        .font(.system(size: 12).weight(.light))
        .padding(EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4))
        .monospaced()
    }
  }
}

#Preview {
  PostCellView(post: .example)
}
