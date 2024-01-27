import SwiftUI
import Kingfisher

struct PostCellView: View {
  var post: Post
  @Binding var numberGridColumns: Int
  
  var body: some View {
    switch post.type {
    case .photo:
      if !post.imageUrls.isEmpty {
        VStack(alignment: .leading, spacing: 4) {
          DateTextView(post: post)
          // Single image post
          if post.imageUrls.count == 1 {
            KFImage(URL(string: post.imageUrls[0]))
              .resizable()
              .scaledToFit()
              .aspectRatio(contentMode: .fit)
              .clipped()
              .cornerRadius(12)
              .frame(maxWidth: .infinity, maxHeight: .infinity)
              .overlay(
                RoundedRectangle(cornerRadius: 12)
                  .stroke(.gray, lineWidth: 1)
                  .opacity(0.4)
              )
          } else {  // Multiple image post
            TabView {
              ForEach(post.imageUrls, id: \.self) { imageUrl in
                KFImage(URL(string: imageUrl))
                  .resizable()
                  .scaledToFill()
                  .aspectRatio(contentMode: .fill)
                  .clipped()
              }
            }
            .tabViewStyle(PageTabViewStyle())
            .frame(height: 450 / CGFloat(numberGridColumns))
            .cornerRadius(12)
            .overlay(
              RoundedRectangle(cornerRadius: 12)
                .stroke(.gray, lineWidth: 1)
                .opacity(0.4)
            )
          }
          
          if post.caption != "" {
            Text(post.caption)
              .font(.subheadline)
              .padding(EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4))
          }
        }
      }
    case .text:
      VStack(alignment: .leading, spacing: 4) {
        DateTextView(post: post)
        Text(post.caption)
          .font(.title3)
          .fontWeight(.medium)
          .multilineTextAlignment(.center)
          .padding(22)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .overlay(
            RoundedRectangle(cornerRadius: 12)
              .stroke(.gray, lineWidth: 1)
              .opacity(0.7)
          )
       }
    }
  }
  
  struct DateTextView: View {
    var post: Post
    
    var body: some View {
      Text(post.timestamp.dateValue().formatted(date: .abbreviated, time: .omitted))
        .font(.system(size: 14).weight(.light))
        .padding(EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4))
        .monospaced()
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
  }
}

#Preview {
  PostCellView(post: .example, numberGridColumns: .constant(2))
}
