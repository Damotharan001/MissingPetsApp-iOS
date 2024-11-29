//
//  PetsDetailsViewController.swift
//  MissingPetsLocator
//
//  Created by Damotharan KG on 27/11/24.
//

import UIKit

class PetsDetailsViewController: BaseViewController {

    @IBOutlet weak var descriptionLbl: UITextView!
    @IBOutlet weak var contactNo: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var speciesName: UILabel!
    @IBOutlet weak var petNameLbl: UILabel!
    @IBOutlet weak var petImage: UIImageView!
    
    var userList: MissingPet?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Missing Pets Details"
        self.petNameLbl.text = self.userList?.petName
        self.descriptionLbl.text = self.userList?.description
        let imageUrl = self.userList?.petImage ?? ""
        self.petImage.load(url: imageUrl)
        self.speciesName.text = self.userList?.species
        self.contactNo.text = self.userList?.contactNo
        self.location.text = self.userList?.location
    }

}
