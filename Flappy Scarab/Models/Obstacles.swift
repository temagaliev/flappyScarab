//
//  Obstacles.swift
//  Flappy Scarab
//
//  Created by Artem Galiev on 19.10.2023.
//

import Foundation

struct Obstacle {
    let imageName: String
    let size: CGSize
    let physicsBodySize: CGSize
}

struct Obstacles {
    let obstaclesList: [Obstacle] = [Obstacle(imageName: NameImage.obstacleOne.rawValue, size: CGSize(width: 30, height: 40), physicsBodySize:   CGSize(width: 25, height: 35)),
                                     Obstacle(imageName: NameImage.obstacleTwo.rawValue, size: CGSize(width: 25, height: 25), physicsBodySize: CGSize(width: 20, height: 20)),
                                     Obstacle(imageName: NameImage.obstacleThree.rawValue, size: CGSize(width: 45, height: 45), physicsBodySize: CGSize(width: 40, height: 40)),
                                     Obstacle(imageName: NameImage.obstacleFour.rawValue, size: CGSize(width: 25, height: 25), physicsBodySize: CGSize(width: 20, height: 20))]
}
