import SwiftUI

struct ResetPasswordView: View {
  @EnvironmentObject var model: AuthViewModel
  @Environment(\.presentationMode) var mode
  @Binding private var email: String
  
  init(email: Binding<String>) {
    self._email = email
  }
  
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
      }
      
      Button(action: {
        model.resetPassword(withEmail: email)
      }, label: {
        Text("Send Reset Password Link")
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
    .padding(.top, -44)
    .background(.black)
    .onReceive(model.$didSendResetPasswordLink, perform: { _ in
      self.mode.wrappedValue.dismiss()
    })
  }
}

struct ResetPasswordView_Previews: PreviewProvider {
  static let authViewModel = AuthViewModel()
  static var previews: some View {
    ResetPasswordView(email: .constant("")).environmentObject(authViewModel)
  }
}
