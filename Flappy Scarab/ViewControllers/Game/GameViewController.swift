//
//  GameViewController.swift
//  Flappy Scarab
//
//  Created by Artem Galiev on 19.10.2023.
//

import UIKit
import SpriteKit
import GameplayKit

protocol GameViewControllerDelegate {
    func counterStarValue(starValue: Int, requiredQuantityValue: Int)
}

extension GameViewController: GameViewControllerDelegate {
    func counterStarValue(starValue: Int, requiredQuantityValue: Int) {
        starLabel.text = "\(starValue)/\(requiredQuantityValue)"
    }
}

class GameViewController: UIViewController {
    
    let buttonMenu: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: NameImage.menuButton.rawValue), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let starLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    
    let starImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: NameImage.bonus.rawValue)
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let skScene: GameScene = SKScene(fileNamed: "GameScene") as! GameScene

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)

        buttonMenu.addTarget(self, action: #selector(onMenuButtonClick), for: .touchUpInside)
        
        let skView = SKView(frame: view.frame)
        view.addSubview(skView)
        
        skScene.size = CGSize(width: view.frame.width, height: view.frame.height)
        skScene.scaleMode = .aspectFill
        skView.presentScene(skScene)
            
        view.addSubview(buttonMenu)
        
        buttonMenu.widthAnchor.constraint(equalToConstant: 50).isActive = true
        buttonMenu.heightAnchor.constraint(equalToConstant: 50).isActive = true
        buttonMenu.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        buttonMenu.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        
        view.addSubview(starLabel)
        
        starLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        starLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        starLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        starLabel.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -16).isActive = true
        
        view.addSubview(starImage)
        
        starImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
        starImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
        starImage.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 14).isActive = true
        starImage.rightAnchor.constraint(equalTo: starLabel.leftAnchor, constant: -16).isActive = true
        
        skScene.gameCounterVCDelegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        skScene.startGame()
    }
    
    @objc func onMenuButtonClick() {
        MainRouter.shared.closeGameViewScreen()
    }


}
