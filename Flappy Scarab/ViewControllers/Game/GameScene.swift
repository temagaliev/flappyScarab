//
//  GameScene.swift
//  Flappy Scarab
//
//  Created by Artem Galiev on 19.10.2023.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var backgraundNode = SKSpriteNode(imageNamed: NameImage.gameBg.rawValue)
    var playerNode = SKSpriteNode(imageNamed: NameImage.player.rawValue)

    var arrayUseNode: [SKSpriteNode] = []
    
    let obstacle = Obstacles()
    
    var timer = Timer()
    var timerStar = Timer()
    var timerReverse = Timer()
    
    var isEnd: Bool = false
    var isPlayerDead: Bool = false
    
    var level: Int = 1
    var starPointValue: Int = 0
    var requiredQuantityValue: Int = 10
    
    var maxObstaclesValue: Int = 1
    var timeIntervalGenerateObstacles: TimeInterval = 1
    var timeIntervalGenerateStarPont: TimeInterval = 3
    var timeIntervalGenerateReverse: TimeInterval = 5
    var speedNode: TimeInterval = 5


    var gameCounterVCDelegate: GameViewControllerDelegate?
    
    override func didMove(to view: SKView) {
        backgraundNode.position = CGPoint(x: 0, y: 0)
        backgraundNode.size = CGSize(width: frame.width, height: frame.height)
        
        addChild(backgraundNode)
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.friction = 0
        self.physicsBody?.restitution = 0
        self.physicsBody?.angularDamping = 0
        self.physicsBody?.categoryBitMask = UInt32(BodyType.enemy)
        self.physicsBody?.contactTestBitMask = UInt32(BodyType.player)
        
        view.scene?.delegate = self
        physicsWorld.contactDelegate = self
    }
    
    //MARK: - Начало игры
    public func startGame() {
        levelComplexity()
        requiredQuantityValue = level * 5
        setupPlayer()
        generateObstacle()
        generateStarPoint()
        generateReverseObstacle()
        gameCounterVCDelegate?.counterStarValue(starValue: starPointValue, requiredQuantityValue: requiredQuantityValue)
        isEnd = false
    }
    
    //MARK: - Настройки модели игрока
    private func setupPlayer() {
        playerNode = SKSpriteNode(imageNamed: NameImage.player.rawValue)
        playerNode.size = CGSize(width: 40, height: 40)
        playerNode.position = CGPoint(x: frame.midX - 50, y: frame.midY)
        playerNode.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        playerNode.physicsBody?.categoryBitMask = UInt32(BodyType.player)
        playerNode.physicsBody?.collisionBitMask = 0
        playerNode.physicsBody?.contactTestBitMask = UInt32(BodyType.enemy)
        playerNode.physicsBody?.contactTestBitMask = UInt32(BodyType.star)
        playerNode.physicsBody?.affectedByGravity = false
        playerNode.physicsBody?.allowsRotation = false
        arrayUseNode.append(playerNode)
        addChild(playerNode)
    }
    
    //MARK: - Создание препятствий
    private func generateObstacle() {
        timer = Timer.scheduledTimer(timeInterval: timeIntervalGenerateObstacles, target: self, selector: #selector(createObstacle), userInfo: nil, repeats: true)
    }
    
    @objc func createObstacle() {
        let randomCountObstacle = Int.random(in: 1...maxObstaclesValue)
        let randomHard = Int.random(in: 1...10)
        if randomHard > 6 && level > 5 {
            let randomYPosition = CGFloat.random(in: (frame.minY + 50)...((frame.maxY - 50)))
            let obstacle = createNodeObstacle(position: CGPoint(x: frame.maxX + 50, y: randomYPosition))
            if randomYPosition > frame.midY {
                let obstacleOne = createNodeObstacle(position: CGPoint(x: frame.maxX + 50, y: randomYPosition + 50))
                obstacle.addChild(obstacleOne)
                let obstacleTwo = createNodeObstacle(position: CGPoint(x: frame.maxX + 50, y: randomYPosition + 100))
                obstacle.addChild(obstacleTwo)
                let obstacleThree = createNodeObstacle(position: CGPoint(x: frame.maxX + 50, y: randomYPosition + 150))
                obstacle.addChild(obstacleThree)
                let obstacleFour = createNodeObstacle(position: CGPoint(x: frame.maxX + 50, y: randomYPosition + 200))
                obstacle.addChild(obstacleFour)
                let obstacleFive = createNodeObstacle(position: CGPoint(x: frame.maxX + 50, y: randomYPosition + 250))
                obstacle.addChild(obstacleFive)
            } else {
                let obstacleOne = createNodeObstacle(position: CGPoint(x: frame.maxX + 50, y: randomYPosition - 50))
                obstacle.addChild(obstacleOne)
                let obstacleTwo = createNodeObstacle(position: CGPoint(x: frame.maxX + 50, y: randomYPosition - 100))
                obstacle.addChild(obstacleTwo)
                let obstacleThree = createNodeObstacle(position: CGPoint(x: frame.maxX + 50, y: randomYPosition - 150))
                obstacle.addChild(obstacleThree)
                let obstacleFour = createNodeObstacle(position: CGPoint(x: frame.maxX + 50, y: randomYPosition - 200))
                obstacle.addChild(obstacleFour)
                let obstacleFive = createNodeObstacle(position: CGPoint(x: frame.maxX + 50, y: randomYPosition - 250))
                obstacle.addChild(obstacleFive)
            }
            
            arrayUseNode.append(obstacle)

            addChild(obstacle)

            var actionArray = [SKAction]()
            
            actionArray.append(SKAction.move(to: CGPoint(x: frame.minX - 300, y: obstacle.position.y), duration: speedNode))
            actionArray.append(SKAction.removeFromParent())
            
            obstacle.run(SKAction.sequence(actionArray))
        } else {
            for _ in 0...randomCountObstacle - 1 {
                let randomYPosition = CGFloat.random(in: (frame.minY + 50)...((frame.maxY - 50)))
                let obstacle = createNodeObstacle(position: CGPoint(x: frame.maxX + 50, y: randomYPosition))
                
                arrayUseNode.append(obstacle)
                addChild(obstacle)
                
                var actionArray = [SKAction]()
                
                actionArray.append(SKAction.move(to: CGPoint(x: frame.minX - 300, y: obstacle.position.y), duration: speedNode))
                actionArray.append(SKAction.removeFromParent())
                
                obstacle.run(SKAction.sequence(actionArray))
                
            }
        }
    }
    
    private func createNodeObstacle(position: CGPoint) -> SKSpriteNode {
        let randomObstacle = Int.random(in: 0...obstacle.obstaclesList.count - 1)
        let obstacleType = obstacle.obstaclesList[randomObstacle]
        let obstacle = SKSpriteNode(imageNamed: obstacleType.imageName)
        obstacle.size = obstacleType.size
        obstacle.position = position
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacleType.physicsBodySize)
        obstacle.physicsBody?.affectedByGravity = false
        obstacle.physicsBody?.isDynamic = false
        obstacle.physicsBody?.collisionBitMask = 0
        obstacle.physicsBody?.categoryBitMask = UInt32(BodyType.enemy)
        obstacle.physicsBody?.contactTestBitMask = UInt32(BodyType.player)
        
        return obstacle
    }
    
    //MARK: - Создание бонуса
    private func generateStarPoint() {
        timerStar = Timer.scheduledTimer(timeInterval: timeIntervalGenerateStarPont, target: self, selector: #selector(createStarPont), userInfo: nil, repeats: true)
    }
    
    @objc func createStarPont() {
        let randomYPosition = CGFloat.random(in: (frame.minY + 50)...((frame.maxY - 50)))
        let star = SKSpriteNode(imageNamed: NameImage.bonusGame.rawValue)
        star.size = CGSize(width: 20, height: 20)
        star.position = CGPoint(x: frame.maxX + 50, y: randomYPosition)
        star.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 20, height: 20))
        star.physicsBody?.affectedByGravity = false
        star.physicsBody?.isDynamic = false
        star.physicsBody?.collisionBitMask = 0
        star.physicsBody?.categoryBitMask = UInt32(BodyType.star)
        star.physicsBody?.contactTestBitMask = UInt32(BodyType.player)

        arrayUseNode.append(star)
        addChild(star)
        
        var actionArray = [SKAction]()

        actionArray.append(SKAction.move(to: CGPoint(x: frame.minX - 300, y: star.position.y), duration: speedNode))
        actionArray.append(SKAction.removeFromParent())
        
        star.run(SKAction.sequence(actionArray))
    }
    
    //MARK: - Создание бонуса
    private func generateReverseObstacle() {
        timerReverse = Timer.scheduledTimer(timeInterval: timeIntervalGenerateReverse, target: self, selector: #selector(createReverseObstacle), userInfo: nil, repeats: true)
    }
    
    @objc func createReverseObstacle() {
        let randomYPosition = CGFloat.random(in: (frame.minY + 50)...((frame.maxY - 50)))
        let obstacle = createNodeObstacle(position: CGPoint(x: frame.minX - 50, y: randomYPosition))
        
        arrayUseNode.append(obstacle)
        addChild(obstacle)
        
        var actionArray = [SKAction]()
        
        actionArray.append(SKAction.move(to: CGPoint(x: frame.maxX + 300, y: obstacle.position.y), duration: speedNode))
        actionArray.append(SKAction.removeFromParent())
        
        obstacle.run(SKAction.sequence(actionArray))
    }
    
    //MARK: - Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        playerNode.physicsBody?.affectedByGravity = true
        playerNode.physicsBody?.velocity = CGVector.zero
        playerNode.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 30))
    }
    
    private func restartGame() {
        isEnd = true
        isPlayerDead = false
        timer.invalidate()
        timerStar.invalidate()
        timerReverse.invalidate()
        starPointValue = 0
        if arrayUseNode.count != 0 {
            for node in arrayUseNode {
                node.removeFromParent()
            }
            arrayUseNode = []
        }
    }

}

//MARK: - SKSceneDelegate
extension GameScene: SKSceneDelegate {
    override func update(_ currentTime: TimeInterval) {
        if isEnd == false {
            if isPlayerDead {
                MainRouter.shared.showWinViewScreen(isWin: false, level: level)
                restartGame()
                level = 1
            }
        }
    }
}

//MARK: - SKPhysicsContactDelegate
extension GameScene: SKPhysicsContactDelegate {
    //Столкновения
    func didBegin(_ contact: SKPhysicsContact) {
        //Переменные контакта
        let bodyA = contact.bodyA.categoryBitMask
        let bodyB = contact.bodyB.categoryBitMask
        
        let enemy = UInt32(BodyType.enemy)
        let wall = UInt32(BodyType.wallGame)
        let player = UInt32(BodyType.player)
        let starNode = UInt32(BodyType.star)

        if bodyA == player && bodyB == starNode {
            contact.bodyB.node?.removeFromParent()
            starPointValue = starPointValue + 1
            gameCounterVCDelegate?.counterStarValue(starValue: starPointValue, requiredQuantityValue: requiredQuantityValue)
            if starPointValue == requiredQuantityValue {
                MainRouter.shared.showWinViewScreen(isWin: true, level: level)
                restartGame()
                level = level + 1
            }
        }
        
        if bodyA == starNode && bodyB == player {
            contact.bodyA.node?.removeFromParent()
            starPointValue = starPointValue + 1
            gameCounterVCDelegate?.counterStarValue(starValue: starPointValue, requiredQuantityValue: requiredQuantityValue)
            if starPointValue == requiredQuantityValue {
                MainRouter.shared.showWinViewScreen(isWin: true, level: level)
                restartGame()
                level = level + 1
            }
        }
        
        if bodyA == wall && bodyB == player {
            isPlayerDead = true
        }
        
        if bodyA == player && bodyB == wall {
            isPlayerDead = true
        }
        
        if bodyA == player && bodyB == enemy || bodyA == enemy && bodyB == player {
            isPlayerDead = true
        }
    }
}

//MARK: - Уровень сложности
extension GameScene {
    private func levelComplexity() {
        switch level {
        case 1...3:
            maxObstaclesValue = 1
            timeIntervalGenerateObstacles = 0.7
            timeIntervalGenerateStarPont = 2
            timeIntervalGenerateReverse = 5
            speedNode = 5
        case 4...15:
            maxObstaclesValue = 1
            timeIntervalGenerateObstacles = 0.7
            timeIntervalGenerateStarPont = 3
            timeIntervalGenerateReverse = 4
            speedNode = 4
        case 16...40:
            maxObstaclesValue = 1
            timeIntervalGenerateObstacles = 0.6
            timeIntervalGenerateStarPont = 3
            timeIntervalGenerateReverse = 4
            speedNode = 4
        case 41...100:
            maxObstaclesValue = 1
            timeIntervalGenerateObstacles = 0.5
            timeIntervalGenerateStarPont = 3
            timeIntervalGenerateReverse = 3
            speedNode = 3
        case 101...1000:
            maxObstaclesValue = 1
            timeIntervalGenerateObstacles = 0.4
            timeIntervalGenerateStarPont = 3
            timeIntervalGenerateReverse = 3
            speedNode = 2
            requiredQuantityValue = 10
        default:
            requiredQuantityValue = 10
            maxObstaclesValue = 1
            timeIntervalGenerateObstacles = 1
            timeIntervalGenerateStarPont = 3
            speedNode = 5
        }
    }
}
