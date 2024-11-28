//
//  ViewModels.swift
//  MissingPetsLocator
//
//  Created by Damotharan KG on 27/11/24.
//

import Foundation
import Firebase

class ViewModels: NSObject{
    var ref = Database.database().reference()
    
    
    func saveUserRecord(uID:String, param: [String:Any], success : @escaping(_ success : Any)-> Void, failure : @escaping(_ failure : Error?)-> Void){
        ref.child("MissingPetList/user_details/\(uID)").setValue(param)
        success(param)
    }
    
    func getUserRecord(uID:String, success : @escaping(_ success : Any)-> Void, failure : @escaping(_ failure : Error?)-> Void){
        ref.child("user_details/\(uID)").getData(completion:  { error, snapshot in
            guard error == nil else {
                failure(error)
                return;
            }
            success(snapshot?.value ?? "")
//            if let responseData = snapshot?.value{
//                let decoder = JSONDecoder()
//                let data = try? JSONSerialization.data(withJSONObject: responseData)
//                if let valueData = data {
//                    do {
//                        let data = try decoder.decode(User.self, from: valueData)
//                        print(data)
//                        success(data)
//                    } catch {
//                        print(error.localizedDescription)
//                        failure(error)
//                    }
//                }
//            }
        });
    }
    func getParticularRecord(key: String, value: String, success : @escaping(_ success : [MissingPet])-> Void, failure : @escaping(_ failure : Error?)-> Void)
    {
        ref.child("MissingPetList/").child("missingPetList").queryOrdered(byChild: key).queryEqual(toValue: value).observeSingleEvent(of: .value) { snapShot   in
            if let responseData = snapShot.value as? NSArray {
                let json = responseData.filter { !($0 is NSNull) }
                let decoder = JSONDecoder()
                let data = try? JSONSerialization.data(withJSONObject: json)
                if let valueData = data {
                    do {
                        let data = try decoder.decode([MissingPet].self, from: valueData)
                        print(data)
                        success(data)
                    } catch {
                        print(error.localizedDescription)
                        failure(error)
                    }
                }
            }
        }
        
    }
    
    
    func getMissingData(uID:String, success : @escaping(_ success : [MissingPet])-> Void, failure : @escaping(_ failure : Error?)-> Void){
        ref.child("MissingPetList/").child("missingPetList").getData(completion:  { error, snapshot in
            guard error == nil else {
                failure(error)
                return;
            }
            if let responseData = snapshot?.value{
                let decoder = JSONDecoder()
                let data = try? JSONSerialization.data(withJSONObject: responseData)
                if let valueData = data {
                    do {
                        let data = try decoder.decode([MissingPet].self, from: valueData)
                        print(data)
                        success(data)
                    } catch {
                        print(error.localizedDescription)
                        failure(error)
                    }
                }
            }
        });
    }
    
    func saveMissingPetList(uID:String, param: [String:Any], success : @escaping(_ success : Any)-> Void, failure : @escaping(_ failure : Error?)-> Void){
        var arrayOfParams = [[String:Any]]()
        self.ref.child("MissingPetList/").child("missingPetList").observeSingleEvent(of: .value, with: { snapshot in
            if let existingData = snapshot.value as? [[String: Any]] {
                // Append new params to the existing data
                var updatedArray = existingData
                updatedArray.append(param)
                success(param)
                // Upload the updated array back to Firebase
                self.ref.child("MissingPetList/").child("missingPetList").setValue(updatedArray) { error, _ in
                    if let error = error {
                        print("Error uploading data: \(error.localizedDescription)")
                    } else {
                        print("Data successfully added!")
                    }
                }
            } else {
                // If no existing data, create the array and set the value
                arrayOfParams.append(param)
                self.ref.child("MissingPetList/").child("missingPetList").setValue(arrayOfParams) { error, _ in
                    if let error = error {
                        print("Error uploading data: \(error.localizedDescription)")
                    } else {
                        print("Data successfully added!")
                        success(param)
                    }
                }
            }
        })
    }
    
   
    func getMissingData(success : @escaping(_ success : Any)-> Void, failure : @escaping(_ failure : Error?)-> Void){
        ref.child("user_details/").getData(completion:  { error, snapshot in
            guard error == nil else {
                failure(error)
                return;
            }
            success(snapshot?.value ?? "")
        });
    }
}

