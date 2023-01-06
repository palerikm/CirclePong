import Foundation
import SpriteKit


class PlayArea: SKShapeNode {
 
    
    init(centerPoint: CGPoint) {
        super.init()
        let playPath = CGMutablePath()
        playPath.addArc(center: CGPoint.zero,
                    radius: centerPoint.x-10,
                    startAngle: 0,
                    endAngle: CGFloat.pi * 2,
                    clockwise: true)
        path = playPath
        lineWidth = 1
        fillColor = .blue
        strokeColor = .white
        glowWidth = 0.5
        position = centerPoint
        physicsBody = SKPhysicsBody(edgeLoopFrom: path!)
        physicsBody?.categoryBitMask = PhysicsCategory.playArea
        physicsBody?.contactTestBitMask = PhysicsCategory.ball
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
