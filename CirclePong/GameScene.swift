import Foundation
import SpriteKit
import SwiftUI



class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var paddle:Paddle?
    var ball:Ball?
    
    var lastHitPoint = CGPoint();
    
    var lastPath = SKShapeNode()
    var projectedPath = SKShapeNode()
    
    var score:Int = 0
    let scoreNode = SKLabelNode(fontNamed: "Chalkduster")
    let gameOverNode = SKLabelNode(fontNamed: "Chalkduster")
    
    
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
        
        
      
        scoreNode.text = String(score)
        scoreNode.fontSize = 65
        scoreNode.fontColor = SKColor.green
        scoreNode.position = centerPoint
        addChild(scoreNode)
        
        gameOverNode.text = "Game Over"
        gameOverNode.fontSize = 40
        gameOverNode.fontColor = SKColor.red
        gameOverNode.position = CGPoint(x: centerPoint.x, y: centerPoint.y-30)
        gameOverNode.isHidden = true
        addChild(gameOverNode)
       
        lastHitPoint = centerPoint
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        if !gameOverNode.isHidden{
            ball!.physicsBody?.velocity = CGVector(dx: 0, dy: -ball!.smashForce)
            gameOverNode.isHidden = true
            score=0
            ball?.smashForce = 60
            scoreNode.text = String(score)
        }

    }
    
    func rotationToVec(rotation: CGFloat) -> CGVector{
        return CGVector(dx: sin(paddle!.zRotation + CGFloat.pi), dy: cos(paddle!.zRotation + CGFloat.pi))
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        paddle?.zRotation = location.x / 10
        
        //print("Paddle rot: \(rotationToVec(rotation: paddle!.zRotation))" )
    }
    
    
    func drawLastPath(from: CGPoint, to: CGPoint){
        lastPath.removeFromParent()
        let path = CGMutablePath()
        path.move(to: from)
        path.addLine(to: to)
        lastPath = SKShapeNode(path: path)
        self.addChild(lastPath)
    }
    
    func drawProjectedPath(from: CGPoint, to: CGPoint){
        projectedPath.removeFromParent()
        let path = CGMutablePath()
        path.move(to: from)
        path.addLine(to: to)
        projectedPath = SKShapeNode(path: path)
        self.addChild(projectedPath)
    }
    
    func handlePaddleSmash(paddle: Paddle, ball: Ball, contact: SKPhysicsContact){
        //let dxVelocity:CGFloat = (ball.physicsBody?.velocity.dx)!
        //let dyVelocity:CGFloat = (ball.physicsBody?.velocity.dy)!
        
        //let paddleRotVec = rotationToVec(rotation: paddle.zRotation)
        //let dxPaddle = paddleRotVec.dx
        //let dyPaddle = paddleRotVec.dy
        
        let dxContact = contact.contactNormal.dx
        let dyContact = contact.contactNormal.dy
        
        
        ball.smashForce+=10
        let newVector = CGVector(dx: dxContact*ball.smashForce,
                                 dy: dyContact*ball.smashForce)
        
        
        //print("Contact:\(contact.contactNormal)")
        //print("New Vector: \(newVector)")
        
        /*
        drawProjectedPath(from: contact.contactPoint,
                 to: CGPoint(x:contact.contactPoint.x + newVector.dx,y:contact.contactPoint.y + newVector.dy))
        
        drawLastPath(from: contact.contactPoint, to: lastHitPoint)
        */
         
         //Stopp all movment
        ball.physicsBody?.velocity = CGVector()
        //Smash it
        ball.physicsBody?.applyImpulse(newVector)
        
        score+=1
        scoreNode.text = String(score)
        lastHitPoint = contact.contactPoint
    }
    
    func handleBallOutsidePlayArea(playarea: PlayArea, ball: Ball){
        lastHitPoint = centerPoint
        gameOverNode.isHidden = false
        lastPath.removeFromParent()
        projectedPath.removeFromParent()
        ball.removeFromParent()
        ball.position = centerPoint
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
