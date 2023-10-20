//
//  WinOrLooseViewController.swift
//  Flappy Scarab
//
//  Created by Artem Galiev on 19.10.2023.
//

import UIKit

class WinOrLooseViewController: UIViewController {

    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var replayButton: UIButton!
    @IBOutlet weak var resultView: UIImageView!
    @IBOutlet weak var bgView: UIImageView!
    
    var saveHighScore: Int = 0
    
    var isWin: Bool
    var level: Int
    
    init(isWin: Bool, level: Int) {
        self.isWin = isWin
        self.level = level
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        highScoreCounter()
        switch isWin {
        case true:
            replayButton.setImage(UIImage(named: NameImage.nextButton.rawValue), for: .normal)
            resultView.image = UIImage(named: NameImage.winView.rawValue)
            bgView.image = UIImage(named: NameImage.winBg.rawValue)
            scoreLabel.text = "Current level - \(level)"
            highScoreLabel.text = "High level - \(saveHighScore)"
        case false:
            replayButton.setImage(UIImage(named: NameImage.replayButton.rawValue), for: .normal)
            resultView.image = UIImage(named: NameImage.loseView.rawValue)
            bgView.image = UIImage(named: NameImage.gameBg.rawValue)
            scoreLabel.text = "Current level - \(level)"
            highScoreLabel.text = "High level - \(saveHighScore)"
        }
    }
    
    @IBAction func onReplayButtonClick(_ sender: UIButton) {
        MainRouter.shared.closeWinViewScreen()
    }
    
    @IBAction func onMenuButtonClick(_ sender: UIButton) {
        MainRouter.shared.showMenuViewScreen()
    }
    
    private func highScoreCounter() {
        saveHighScore = UserDefaults.standard.integer(forKey: "saveScore")
        if saveHighScore < level  {
            UserDefaults.standard.set(level, forKey: "saveScore")
            saveHighScore = level
        }
    }

    
}
