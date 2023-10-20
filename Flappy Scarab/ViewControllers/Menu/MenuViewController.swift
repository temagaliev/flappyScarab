//
//  MenuViewController.swift
//  Flappy Scarab
//
//  Created by Artem Galiev on 19.10.2023.
//

import UIKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func onPlayButtonClick(_ sender: UIButton) {
        MainRouter.shared.showGameViewScreen()
        
    }
    @IBAction func onPrivacyPolicyButtonClick(_ sender: UIButton) {
        MainRouter.shared.showTermsViewScreen()
    }

}
