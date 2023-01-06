import Foundation
import SpriteKit


class Ball: SKShapeNode {
    
    var smashForce:CGFloat = 60
    
    override init() {
        super.init()
        let ballPath = CGMutablePath()
        ballPath.addArc(center: CGPoint.zero,
                        radius: 5,
                        startAngle: 0,
                        endAngle: CGFloat.pi * 2,
                        clockwise: true)
        path = ballPath
        lineWidth = 0.1
        fillColor = .green
        strokeColor = .black
        glowWidth = 0.5
        physicsBody = SKPhysicsBody(circleOfRadius: 5)
        physicsBody?.mass = 1
        physicsBody?.velocity = CGVector(dx: 0, dy: -30)
        physicsBody?.isDynamic = true // 2
        physicsBody?.categoryBitMask = PhysicsCategory.ball // 3
        physicsBody?.contactTestBitMask = PhysicsCategory.paddle // 4
        physicsBody?.collisionBitMask = PhysicsCategory.none // 5
        
     
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
