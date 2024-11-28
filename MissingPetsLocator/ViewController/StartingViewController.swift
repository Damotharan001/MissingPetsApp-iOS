//
//  StartingViewController.swift
//  MissingPetsLocator
//
//  Created by Damotharan KG on 27/11/24.
//

import UIKit

class StartingViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func loginAction(_ sender: Any) {
        let VC = AppConstant.storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
        VC?.viaLogin = true
        self.navigationController?.pushViewController(VC!, animated: true)
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        let VC = AppConstant.storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
        VC?.viaLogin = false
        self.navigationController?.pushViewController(VC!, animated: true)
    }
    @IBAction func continueAsGuestAction(_ sender: Any) {
        let VC = AppConstant.storyBoard.instantiateViewController(withIdentifier: "MissingPetsDetailsViewController") as? MissingPetsDetailsViewController
        VC?.isViaGuestMode = true
        self.navigationController?.pushViewController(VC!, animated: true)
    }
    
    

}
