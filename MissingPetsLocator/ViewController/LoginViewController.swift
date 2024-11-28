//
//  LoginViewController.swift
//  MissingPetsLocator
//
//  Created by Damotharan KG on 27/11/24.
//

import UIKit
import FirebaseAuth
import Firebase

class LoginViewController: BaseViewController {
    
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var emailIDTF: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!
    var viaLogin: Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginBtn.setTitle((self.viaLogin ?? false) ? "Login" : "SignUp", for: .normal)
        
        // Do any additional setup after loading the view.
        self.navigationItem.title = (self.viaLogin ?? false) ? "Login" : "SignUp"
    }
    
    @IBAction func loginAction(_ sender: Any) {
        self.showLoader()
        if self.viaLogin ?? false{
            Auth.auth().signIn(withEmail: self.emailIDTF.text ?? "", password: self.passwordTF.text ?? "") { authResult, error in
                print("authResult", authResult?.user.uid ?? "")
                
                guard let uIDValue = authResult?.user.uid else{
//                    let VC = AppConstant.storyBoard.instantiateViewController(withIdentifier: "MissingPetsDetailsViewController") as? MissingPetsDetailsViewController
//                    self.navigationController?.pushViewController(VC!, animated: true)
                    self.hideLoader()
                    self.showAlert(title: "Try again", message: "Invalid credantials, Please enter valid username and password")
                    return
                }
              

                ViewModels().getUserRecord(uID: uIDValue) { (response) in
                    print("response", response)
                    self.hideLoader()
                    let VC = AppConstant.storyBoard.instantiateViewController(withIdentifier: "MissingPetsDetailsViewController") as? MissingPetsDetailsViewController
                    self.navigationController?.pushViewController(VC!, animated: true)
                } failure: { failure in
                    self.hideLoader()
                    print("failure", failure?.localizedDescription ?? "")
                }
            }
        }else{
            Auth.auth().createUser(withEmail: self.emailIDTF.text ?? "", password: self.passwordTF.text ?? "") { authResult, error in
                self.hideLoader()
                let params = ["EmailID" : self.emailIDTF.text ?? "", "Password": self.passwordTF.text ?? ""]
                ViewModels().saveUserRecord(uID: authResult?.user.uid ?? "", param: params) { success in
                    self.navigationController?.popViewController(animated: true)
                } failure: { failure in
                    self.hideLoader()
                    print("failure", failure?.localizedDescription ?? "")
                }
            }
        }
    }
}
