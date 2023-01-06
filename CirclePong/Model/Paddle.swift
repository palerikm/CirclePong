import Foundation
import SpriteKit

class Paddle: SKShapeNode {
    
    
    
   init(centerPoint: CGPoint) {
        super.init()
        var paddlePath = CGMutablePath()
    
        
        paddlePath = CGMutablePath()
        let delta = 1/3*CGFloat.pi
        let startAngle = (CGFloat.pi * 3 / 2 ) - (delta/2)
        paddlePath.addRelativeArc(center: CGPoint.zero, radius: centerPoint.x-12, startAngle: startAngle, delta: delta)
        
        path = paddlePath
        
        
        lineWidth = 1
        fillColor = .red
        strokeColor = .magenta
        glowWidth = 0.3
        position = centerPoint
        physicsBody = SKPhysicsBody(polygonFrom: (path)!)
        physicsBody?.mass = 20
        physicsBody?.isDynamic = true
        physicsBody?.categoryBitMask = PhysicsCategory.paddle
        physicsBody?.contactTestBitMask = PhysicsCategory.ball
        physicsBody?.collisionBitMask = PhysicsCategory.none
        physicsBody?.usesPreciseCollisionDetection = true
       

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
