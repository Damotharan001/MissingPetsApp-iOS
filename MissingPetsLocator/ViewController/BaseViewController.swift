//
//  BaseViewController.swift
//  MissingPetsLocator
//
//  Created by Damotharan KG on 27/11/24.
//

import UIKit

class BaseViewController: UIViewController {
    var activityIndicator = UIActivityIndicatorView(style: .large)
    var loaderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black.withAlphaComponent(0.4)
        view.tag = 29112024
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.backButtonDisplayMode = .minimal
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    func showLoader() {
        let existingView = self.view.subviews.first(where: { $0.tag == 29112024})
        if let existingView {
            existingView.removeFromSuperview()
        }
        loaderView.addSubview(activityIndicator)
        view.addSubview(loaderView)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loaderView.topAnchor.constraint(equalTo: self.view.topAnchor),
            loaderView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            loaderView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            loaderView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            activityIndicator.widthAnchor.constraint(equalToConstant: 60.0),
            activityIndicator.heightAnchor.constraint(equalToConstant: 60.0),
            activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        ])
        activityIndicator.startAnimating()
    }
    
    func hideLoader() {
        loaderView.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func popupAlert(title: String?, message: String?, actionTitles:[String?], actions:[((UIAlertAction) -> Void)?]) {
        let alert = UIAlertController(title: NSLocalizedString(title!, comment: ""), message: NSLocalizedString(message!, comment: ""), preferredStyle: .alert)
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: NSLocalizedString(title!, comment: ""), style: .default, handler: actions[index])
            alert.addAction(action)
        }
        self.present(alert, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func showAlert(title: String = "", message: String, action: (() -> Void)? = nil) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action1 = UIAlertAction(title: "OK", style: .default) { _ in
            action?()
        }
        alertVC.addAction(action1)
        self.present(alertVC, animated: true)
    }
}
