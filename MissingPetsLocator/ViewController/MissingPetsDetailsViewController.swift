//
//  MissingPetsDetailsViewController.swift
//  MissingPetsLocator
//
//  Created by Damotharan KG on 27/11/24.
//

import UIKit
import FirebaseAuth

class MissingPetsDetailsViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var isViaGuestMode: Bool = false
    var userList =  [MissingPet]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Missing Pets Lists"
        if !isViaGuestMode {
            let addItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(MissingPetsDetailsViewController.addAction))
            let logoutItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(MissingPetsDetailsViewController.logoutAction))
            self.navigationItem.leftBarButtonItem = logoutItem
            self.navigationItem.rightBarButtonItem = addItem
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getMissingPetsList()
    }
    
    @objc func addAction() {
        // ADD Action
        let VC = AppConstant.storyBoard.instantiateViewController(withIdentifier: "AddPetsDetailsViewController") as? AddPetsDetailsViewController
        self.navigationController?.pushViewController(VC!, animated: true)
    }
    
    @objc func logoutAction() {
        // Logout Action
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func getMissingPetsList(){
        if self.isViaGuestMode{
            ViewModels().getMissingData(uID: Auth.auth().currentUser?.uid ?? "") { success in
                self.userList = success
                self.tableView.reloadData()
            } failure: { failure in
                print("failure", failure?.localizedDescription ?? "")
            }
        }else{
            ViewModels().getParticularRecord(key: "uID", value: Auth.auth().currentUser?.uid ?? "") { success in
                self.userList = success
                self.tableView.reloadData()
            } failure: { failure in
                print("failure", failure?.localizedDescription ?? "")
            }
        }
    }
    
    @IBAction func loginAction(_ sender: Any) {
        if self.isViaGuestMode{
            let VC = AppConstant.storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
            VC?.viaLogin = false
            self.navigationController?.pushViewController(VC!, animated: true)
        }else{
            let VC = AppConstant.storyBoard.instantiateViewController(withIdentifier: "StartingViewController") as? StartingViewController
            self.navigationController?.pushViewController(VC!, animated: true)
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension MissingPetsDetailsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PetsDetailsCell", for: indexPath) as! PetsDetailsCell
        cell.petName.text = self.userList[indexPath.row].petName
        
        cell.descriptionLbl.text = self.userList[indexPath.row].description
        let imageUrl = self.userList[indexPath.row].petImage
        cell.petImage.load(url: imageUrl)
        cell.date.text = self.userList[indexPath.row].species
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let VC = AppConstant.storyBoard.instantiateViewController(withIdentifier: "PetsDetailsViewController") as? PetsDetailsViewController
        VC?.userList = self.userList[indexPath.row]
        self.navigationController?.pushViewController(VC!, animated: true)
    }
}

