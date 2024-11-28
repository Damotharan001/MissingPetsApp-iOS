//
//  AppConstant.swift
//  MissingPetsLocator
//
//  Created by Damotharan KG on 27/11/24.
//

import Foundation
import UIKit

protocol GetAddress {
    func getAddress(address: String)
}

class AppConstant:NSObject{
    static let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    
    static let YourProfile:String = "Your photo will be posted onto your profile"
    static let ChooseFromLibrary:String = "Choose From Library"
    static let TakePhoto:String = "Take Photo"
    static let ThisdevicehasnoCamera:String = "This device has no Camera"
    static let CameraNotFound:String = "Camera Not Found"
    static let OK:String = "Ok"
    static let Cancel:String = "Cancel"
    
}
extension UIImage{
    func fixOrientation(img:UIImage) -> UIImage {
        
        if (img.imageOrientation == UIImage.Orientation.up) {
            return img;
        }
        
        UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale);
        let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        img.draw(in: rect)
        
        let normalizedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        return normalizedImage;
        
    }
}
extension UIImageView {
    func load(url: String) {
        guard let urlString = URL(string: url) else {return}
        DispatchQueue.global(qos: .background).async { [weak self] in
            if let data = try? Data(contentsOf: urlString) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
