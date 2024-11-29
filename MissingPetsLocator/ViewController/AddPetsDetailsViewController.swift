//
//  AddPetsDetailsViewController.swift
//  MissingPetsLocator
//
//  Created by Damotharan KG on 27/11/24.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseStorage

class AddPetsDetailsViewController: BaseViewController {
    
    @IBOutlet weak var descriptionLbl: UITextView!
    @IBOutlet weak var petImages: UIImageView!
    @IBOutlet weak var locationBtn: UIButton!
    @IBOutlet weak var speciesTF: UITextField!
    @IBOutlet weak var petNameTF: UITextField!
    @IBOutlet weak var contactNo: UITextField!
    
    private var counter = 0
    var picker:UIImagePickerController?=UIImagePickerController()
    var imageArray = [Data]()
    var selectedImage: UIImage?
    var imageURLString: String?
    var address: String = ""
    var storageRef:StorageReference?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Add Missing Pets Details"
    }
    @IBAction func selectLocationAction(_ sender: Any) {
        let VC = AppConstant.storyBoard.instantiateViewController(withIdentifier: "LocationViewController") as? LocationViewController
        VC?.delegate = self
        let navigationVC = UINavigationController(rootViewController: VC!)
        self.navigationController?.present(navigationVC, animated: true)
    }
    
    @IBAction func uploadPhotoAction(_ sender: Any) {
        let alert = UIAlertController(title: "", message: NSLocalizedString(AppConstant.YourProfile, comment: ""), preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: NSLocalizedString(AppConstant.ChooseFromLibrary, comment: ""), style: .default , handler:{ (UIAlertAction)in
            print("User click Library button")
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                self.picker?.delegate = self
                self.picker?.sourceType = .photoLibrary;
                self.picker?.allowsEditing = false
                self.present(self.picker!, animated: true, completion: nil)
            }
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString(AppConstant.TakePhoto, comment: ""), style: .default , handler:{ (UIAlertAction)in
            print("User click Camera button")
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.picker?.delegate = self
                self.picker?.sourceType = .camera;
                self.picker?.allowsEditing = false
                self.present(self.picker!, animated: true, completion: nil)
            }else{
                self.popupAlert(title: NSLocalizedString(AppConstant.CameraNotFound, comment: ""), message: NSLocalizedString(AppConstant.ThisdevicehasnoCamera, comment: ""), actionTitles: [NSLocalizedString(AppConstant.OK, comment: "")], actions:[nil])
            }
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString(AppConstant.Cancel, comment: ""), style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = sender as? UIView
            popoverController.sourceRect = (sender as AnyObject).bounds
        }
        self.present(alert, animated: true, completion: nil)
        
    }
    /// Update profile picture to Firebase Storage
    func updatePicAPI(completion: @escaping (_ url: String?) -> Void){
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        let uploadTask = storageRef?.putData(self.imageArray.first!, metadata: metadata, completion: {(metadata, error) in
            if(error != nil){
                self.storageRef?.downloadURL(completion: { url, error in
                    if error != nil{
                        print("error", error?.localizedDescription ?? "")
                    }
                    completion(url?.absoluteString)
                })
            }else{
                print(error?.localizedDescription ?? "")
            }
        })
        
        uploadTask?.observe(.progress) { snapshot  in
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
            if(percentComplete == 100.0){
            }
        }
    }
    
    @IBAction func submitAction(_ sender: Any) {
        if(!self.imageArray.isEmpty){
            self.storageRef = Storage.storage().reference().child(Auth.auth().currentUser?.uid ?? "").child("profileImages")
            self.updatePicAPI(completion: {(url) in
                print("url", url ?? "")
                let params = ["uID": "\(Auth.auth().currentUser?.uid ?? "")" ,"PetName" : self.petNameTF.text ?? "", "Species": self.speciesTF.text ?? "", "Location": self.address, "Description": self.descriptionLbl.text ?? "", "PetImage": "\(String(describing: url))", "ContactNo": self.contactNo.text ?? ""]
                ViewModels().saveMissingPetList(uID: Auth.auth().currentUser?.uid ?? "", param: params) { success in
                    let userDic = success as? NSDictionary
                    print("userDic", userDic as Any)
//                    let VC = AppConstant.storyBoard.instantiateViewController(withIdentifier: "MissingPetsDetailsViewController") as? MissingPetsDetailsViewController
//                    self.navigationController?.pushViewController(VC!, animated: true)
                    self.navigationController?.popViewController(animated: true)
                } failure: { failure in
                    print("failure", failure as Any)
                    
                }
            })
        }
        
    }
}
extension AddPetsDetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        petImages.image = selectedImage
        let fixOrientationImage = selectedImage?.fixOrientation(img: selectedImage!)
        let data: NSData = fixOrientationImage!.jpegData(compressionQuality: 0.1)! as NSData
        let photoLocalUrl = (info[UIImagePickerController.InfoKey.imageURL] as? URL)!
        self.imageURLString = "\(photoLocalUrl)"
        picker.dismiss(animated: true, completion: {
            self.imageArray.append(data as Data)
        })
    }
}
extension AddPetsDetailsViewController: GetAddress{
    func getAddress(address: String) {
        self.address = address
        self.locationBtn.setTitle(address, for: .normal)
        self.dismiss(animated: true, completion: nil)
    }
}
extension AddPetsDetailsViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
extension AddPetsDetailsViewController: UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}



