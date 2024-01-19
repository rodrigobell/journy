import SwiftUI

struct LoginView: View {
  @State private var email = ""
  @State private var password = ""
  @EnvironmentObject var model: AuthViewModel
  
  var body: some View {
    NavigationView {
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
        
        HStack {
          Spacer()
          NavigationLink(
            destination: ResetPasswordView(email: $email),
            label: {
              Text("Forgot Password?")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white)
                .padding(.top)
                .padding(.trailing, 28)
            })
        }
        
        Button(action: {
          model.login(withEmail: email, password: password)
        }, label: {
          Text("Sign In")
            .font(.headline)
            .foregroundColor(.white)
            .frame(width: 360, height: 50)
            .background(Color.gray)
            .clipShape(Capsule())
            .padding()
        })
        
        Spacer()
        
        NavigationLink(
          destination: RegistrationView().navigationBarHidden(true),
          label: {
            HStack {
              Text("Don't have an account?")
                .font(.system(size: 14))
              
              Text("Register")
                .font(.system(size: 14, weight: .semibold))
            }.foregroundColor(.white)
          }).padding(.bottom, 16)
      }
      .padding(.top, -44)
      .background(.black)
    }
  }
}

struct LoginView_Previews: PreviewProvider {
  static var previews: some View {
    LoginView()
  }
}
