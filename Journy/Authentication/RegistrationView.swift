import SwiftUI
import PhotosUI

struct RegistrationView: View {
  @State private var email = ""
  @State private var fullname = ""
  @State private var username = ""
  @State private var password = ""
  @State private var selectedItem: PhotosPickerItem?
  @State private var selectedImage: UIImage?
  @State private var image: Image?
  @State var imagePickerPresented = false
  @Environment(\.presentationMode) var mode
  @EnvironmentObject var model: AuthViewModel
  
  var body: some View {
    VStack {
      Spacer()
      
      VStack(spacing: 20) {
        CustomTextField(text: $email, placeholder: Text("Email"), imageName: "envelope")
          .padding()
          .background(Color(.init(white: 1, alpha: 0.15)))
          .cornerRadius(10)
          .foregroundColor(.white)
          .padding(.horizontal, 32)
          .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
          .disableAutocorrection(true)
        
        CustomSecureField(text: $password, placeholder: Text("Password"))
          .padding()
          .background(Color(.init(white: 1, alpha: 0.15)))
          .cornerRadius(10)
          .foregroundColor(.white)
          .padding(.horizontal, 32)
          .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
          .disableAutocorrection(true)
      }
      
      Button(action: {
        model.register(withEmail: email, password: password)
      }, label: {
        Text("Sign Up")
          .font(.headline)
          .foregroundColor(.white)
          .frame(width: 360, height: 50)
          .background(Color.gray)
          .clipShape(Capsule())
          .padding()
      })
      
      Spacer()
      
      Button(action: { mode.wrappedValue.dismiss() }, label: {
        HStack {
          Text("Already have an account?")
            .font(.system(size: 14))
          
          Text("Sign In")
            .font(.system(size: 14, weight: .semibold))
        }.foregroundColor(.white)
      })
    }
    .background(.black)
  }
}

extension RegistrationView {
  func loadImage() {
    guard let selectedImage = selectedImage else { return }
    image = Image(uiImage: selectedImage)
  }
}

struct RegistrationView_Previews: PreviewProvider {
  static var previews: some View {
    RegistrationView()
  }
}
