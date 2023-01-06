import Foundation
import SpriteKit
import SwiftUI



class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var paddle:Paddle?
    var ball:Ball?
    var centerPoint:CGPoint {
        return CGPoint(x: size.width/2, y: size.height/2)
    }
    
    
    fileprivate func createBall() -> Ball {
        let newBall = Ball()
        newBall.position = centerPoint
        return newBall
    }
    
    fileprivate func createPaddle() -> Paddle {
        let newPaddle = Paddle(centerPoint: centerPoint)
        return newPaddle
    }
    
    override func didMove(to view: SKView) {
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.gravity = .init(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self

        
        addChild(PlayArea(centerPoint: centerPoint))
        
        paddle = createPaddle()
        addChild(paddle!)
        ball = createBall()
        addChild(ball!)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        paddle?.zRotation = location.x / 10
    }
    
    
    func handlePaddleSmash(paddle: Paddle, ball: Ball, contact: SKPhysicsContact){
        let dxVelocity:CGFloat = (ball.physicsBody?.velocity.dx)!
        let dyVelocity:CGFloat = (ball.physicsBody?.velocity.dy)!
        
        let dxPaddle = abs(sin(paddle.zRotation + CGFloat.pi))
        let dyPaddle = abs(cos(paddle.zRotation + CGFloat.pi))
        
        let dxContact = contact.contactNormal.dx*(-1)
        let dyContact = contact.contactNormal.dy*(-1)
        
        //let newVector = CGVector(dx: dxVelocity*(-3)+(dxPaddle*20), dy: dyVelocity*(-3)+(dyPaddle*20))
        
        let newVector = CGVector(dx: (dxVelocity*(-2))-dxContact*50,  dy: (dyVelocity*(-2))-dyContact*50)
        
        print("Velocity: \(ball.physicsBody!.velocity) Contact:\(contact.contactNormal)")
        print("New Vector: \(newVector)")
        ball.physicsBody?.applyImpulse(newVector)
    }
    
    func handleBallOutsidePlayArea(playarea: PlayArea, ball: Ball){
        ball.removeFromParent()
        ball.position = centerPoint
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: -30)
        addChild(ball)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
      var firstBody: SKPhysicsBody
      var secondBody: SKPhysicsBody
      if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
       
        firstBody = contact.bodyA
        secondBody = contact.bodyB
      } else {
         
        firstBody = contact.bodyB
        secondBody = contact.bodyA
      }
     
      if ((firstBody.categoryBitMask & PhysicsCategory.ball != 0) &&
          (secondBody.categoryBitMask & PhysicsCategory.paddle != 0)) {
          if let ball = firstBody.node as? Ball,
             let paddle = secondBody.node as? Paddle {
              handlePaddleSmash(paddle: paddle, ball: ball, contact: contact)
          }
          
      }
        
    if ((firstBody.categoryBitMask & PhysicsCategory.ball != 0) &&
        (secondBody.categoryBitMask & PhysicsCategory.playArea != 0)) {
        if let ball = firstBody.node as? Ball,
           let playArea = secondBody.node as? PlayArea {
            handleBallOutsidePlayArea(playarea: playArea, ball: ball)
        }
    }
            
            
    }
}
