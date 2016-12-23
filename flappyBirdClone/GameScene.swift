//
//  GameScene.swift
//  flappyBirdClone
//
//  Created by Abhinav Khare on 22/12/16.
//  Copyright © 2016 learn. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var bird = SKSpriteNode();
    var bg = SKSpriteNode();
    var ground = SKNode();
    
    var score = 0
    var gameOver = false
    var scoreLabel = SKLabelNode();
    var gameOverLabel = SKLabelNode();
    
    var timer = Timer()
   
    enum ColliderType: UInt32
    {
        case Bird = 1
        case Object = 2
        case Gap = 4
    }
    
    
    func makePipes()
    {
        let movePipes = SKAction.move(by: CGVector(dx: -2 * self.frame.width, dy:0), duration: TimeInterval(self.frame.width/100))
        
        let gapHeight = bird.size.height*5
        
        let movementAmount = arc4random() % UInt32(self.frame.height/2)
        
        let pipeOffset = CGFloat(movementAmount) -  self.frame.height/4
        
        
        let pipeTexture = SKTexture(imageNamed: "pipe1.png")
       
        let pipe1 = SKSpriteNode(texture: pipeTexture)
       
        pipe1.position = CGPoint(x:self.frame.midX + self.frame.width,y: self.frame.midY + pipeTexture.size().height/2 + gapHeight/2 + pipeOffset)
        
        pipe1.run(movePipes)
        
        pipe1.physicsBody = SKPhysicsBody(rectangleOf: pipeTexture.size())
       
        pipe1.physicsBody!.isDynamic = false
       
        pipe1.physicsBody!.contactTestBitMask=ColliderType.Object.rawValue
       
        pipe1.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
       
        pipe1.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
       
        self.addChild(pipe1)
       
        let pipeTexture2 = SKTexture(imageNamed: "pipe2.png")
       
        let pipe2 = SKSpriteNode(texture: pipeTexture2)
      
        pipe2.position = CGPoint(x:self.frame.midX + self.frame.width,y:self.frame.midY - pipeTexture2.size().height/2 - gapHeight/2 + pipeOffset)
        
      
        pipe2.run(movePipes)
        
        pipe2.physicsBody = SKPhysicsBody(rectangleOf: pipeTexture2.size())
       
        pipe2.physicsBody!.isDynamic = false
       
        pipe2.physicsBody!.contactTestBitMask=ColliderType.Object.rawValue
       
        pipe2.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
       
        pipe2.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
      
        self.addChild(pipe2)
        
        let gap = SKNode()
        gap.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY + pipeOffset)
        gap.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: pipeTexture.size().width,height:gapHeight))
        gap.physicsBody!.isDynamic = false;
        gap.run(movePipes)
        
        gap.physicsBody!.contactTestBitMask=ColliderType.Bird.rawValue
        gap.physicsBody!.categoryBitMask = ColliderType.Gap.rawValue
        gap.physicsBody!.collisionBitMask = ColliderType.Gap.rawValue
        self.addChild(gap)
        

    }
    func didBegin(_ contact: SKPhysicsContact) {
        if(gameOver == false){
        if contact.bodyA.categoryBitMask == ColliderType.Gap.rawValue || contact.bodyB.categoryBitMask == ColliderType.Gap.rawValue{
            print("add one to score")
            score += 1;
            scoreLabel.text=String(score)
        }
        else{
            
        
        print("We have contact")
        self.speed = 0
        gameOver = true
        timer.invalidate()
        gameOverLabel.fontName = "Helvetica"
        gameOverLabel.fontSize = 30
        gameOverLabel.text = "Game Over !! \n Tap to play again"
        gameOverLabel.position = CGPoint(x:self.frame.midX,y:self.frame.midY)
        self.addChild(gameOverLabel)
        }
        }
    }
    
    func setUpGame()
    {
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.makePipes), userInfo: nil, repeats: true)
        
        let backgroundTexture = SKTexture(imageNamed: "bg.png")
        let bgAnimation = SKAction.move(by: CGVector(dx:-backgroundTexture.size().width,dy:0), duration: 5)
        let shiftBGAnimation = SKAction.move(by: CGVector(dx: backgroundTexture.size().width,dy:0),duration : 0)
        let bgForever = SKAction.repeatForever(SKAction.sequence([bgAnimation,shiftBGAnimation]))
        var i: CGFloat = 0;
        while i<3 {
            bg = SKSpriteNode(texture:backgroundTexture)
            bg.size.height=self.frame.height
            bg.position = CGPoint(x: i*backgroundTexture.size().width ,y:self.frame.midY)
            bg.run(bgForever)
            self.addChild(bg)
            i+=1
            bg.zPosition = -1
        }
        let birdTexture = SKTexture(imageNamed:"flappy1.png")
        let birdTexture2 = SKTexture(imageNamed:"flappy2.png")
        let animation = SKAction.animate(with: [birdTexture,birdTexture2], timePerFrame: 0.1)
        let makeBirdFlap = SKAction.repeatForever(animation)
        bird = SKSpriteNode(texture:birdTexture)
        bird.position = CGPoint(x:self.frame.midX,y:self.frame.midY)
        bird.physicsBody = SKPhysicsBody(circleOfRadius: birdTexture.size().height-4)
        bird.physicsBody!.isDynamic = false
        
        bird.physicsBody!.contactTestBitMask=ColliderType.Object.rawValue
        bird.physicsBody!.categoryBitMask = ColliderType.Bird.rawValue
        bird.physicsBody!.collisionBitMask = ColliderType.Bird.rawValue
        bird.run(makeBirdFlap)
        self.addChild(bird)
        ground.position  = CGPoint(x:self.frame.midX,y: -self.frame.height/2)
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width:self.frame.width,height:1))
        ground.physicsBody!.isDynamic = false
        ground.physicsBody!.contactTestBitMask=ColliderType.Object.rawValue
        ground.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        ground.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        self.addChild(ground)
        
        scoreLabel.fontName = "Helvatica"
        scoreLabel.fontSize = 60
        scoreLabel.text = "0"
        scoreLabel.position = CGPoint(x: self.frame.midX,y:self.frame.height/2 - 70)
        self.addChild(scoreLabel)

    }
    
    override func didMove(to view: SKView)
    {
        
        self.physicsWorld.contactDelegate = self
        
        setUpGame()
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
        if(gameOver==false)
        {
        
            bird.physicsBody!.isDynamic = true
            bird.physicsBody!.velocity = CGVector(dx:0,dy:0)
            bird.physicsBody!.applyImpulse(CGVector(dx:0,dy:300))
        
        }
            
        else
        {
            
            gameOver = false
            score = 0
            self.speed = 1
            self.removeAllChildren()
            setUpGame()
            
        }
        

    }
    
    
    override func update(_ currentTime: TimeInterval)
    {
        // Called before each frame is rendered
    }
}
