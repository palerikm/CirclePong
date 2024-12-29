import Foundation
import SpriteKit

class Paddle: SKShapeNode {
    
    
    
   init(centerPoint: CGPoint) {
        super.init()
        var paddlePath = CGMutablePath()
    
        
        paddlePath = CGMutablePath()
        let delta = 1/4*CGFloat.pi
        let startAngle = (CGFloat.pi * 3 / 2 ) - (delta/2)
        paddlePath.addRelativeArc(center: CGPoint(), radius: centerPoint.x-12, startAngle: startAngle, delta: delta)
       
        let subPath = CGMutablePath()
        subPath.addRelativeArc(center: CGPoint(), radius: centerPoint.x-20, startAngle: startAngle, delta: delta+40)
       
        paddlePath = paddlePath.subtracting(subPath) as! CGMutablePath
        paddlePath.closeSubpath()
      
        path = paddlePath
        
        
        lineWidth = 1
        fillColor = .red
        strokeColor = .magenta
        glowWidth = 0.3
        position = centerPoint
        //physicsBody = SKPhysicsBody(polygonFrom: (path)!)
        physicsBody = SKPhysicsBody(edgeLoopFrom: path!)
        physicsBody?.mass = 200
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
