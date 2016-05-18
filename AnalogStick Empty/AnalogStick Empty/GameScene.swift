//
//  GameScene.swift
//
//  Created by Dmitriy Mitrophanskiy on 28.09.14.
//  Copyright (c) 2014 Dmitriy Mitrophanskiy. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var appleNode: SKSpriteNode?
    //let toOtherSceneBtn = SKSpriteNode(imageNamed: "gear")
    
    let moveAnalogStick =  AnalogJoystick(diameters: (88, 44), colors: (UIColor.darkGrayColor(), UIColor.grayColor()))
    let rotateAnalogStick = AnalogJoystick(diameters: (88, 44), colors: (UIColor.darkGrayColor(), UIColor.grayColor()))
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        backgroundColor = UIColor.whiteColor()
        physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
        
        moveAnalogStick.position = CGPointMake(moveAnalogStick.radius + 15, moveAnalogStick.radius + 15)
        addChild(moveAnalogStick)
        
        rotateAnalogStick.position = CGPointMake(CGRectGetMaxX(self.frame) - rotateAnalogStick.radius - 15, rotateAnalogStick.radius + 15)
        addChild(rotateAnalogStick)
        
        //MARK: Handlers begin
        
        moveAnalogStick.startHandler = { [unowned self] in
            
            guard let aN = self.appleNode else { return }
            aN.runAction(SKAction.sequence([SKAction.scaleTo(0.5, duration: 0.5), SKAction.scaleTo(1, duration: 0.5)]))
        }
        
        moveAnalogStick.trackingHandler = { [unowned self] data in
            
            guard let aN = self.appleNode else { return }
            aN.position = CGPointMake(aN.position.x + (data.velocity.x * 0.12), aN.position.y + (data.velocity.y * 0.12))
        }
        
        moveAnalogStick.stopHandler = { [unowned self] in
            
            guard let aN = self.appleNode else { return }
            aN.runAction(SKAction.sequence([SKAction.scaleTo(1.5, duration: 0.5), SKAction.scaleTo(1, duration: 0.5)]))
        }
        
        rotateAnalogStick.trackingHandler = { [unowned self] jData in
            
            self.appleNode?.zRotation = jData.angular
        }
        
        rotateAnalogStick.stopHandler =  { [unowned self] in
            
            guard let aN = self.appleNode else { return }
            aN.runAction(SKAction.rotateByAngle(3.6, duration: 0.5))
        }
        
        //MARK: Handlers end
        
        let selfHeight = CGRectGetHeight(frame)
        let btnsOffset: CGFloat = 10
        
//        toOtherSceneBtn.position = CGPointMake(CGRectGetMaxX(frame) - CGRectGetWidth(toOtherSceneBtn.frame), CGRectGetMidY(joystickSizeLabel.frame))
//        addChild(toOtherSceneBtn)
        
        addApple(CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame)))
        
        view.multipleTouchEnabled = true
    }
    
    func addApple(position: CGPoint) {
        
        guard let appleImage = UIImage(named: "apple") else { return }
        
        let texture = SKTexture(image: appleImage)
        let apple = SKSpriteNode(texture: texture)
        apple.physicsBody = SKPhysicsBody(texture: texture, size: apple.size)
        apple.physicsBody!.affectedByGravity = false

        insertChild(apple, atIndex: 0)
        apple.position = position
        appleNode = apple
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        if let touch = touches.first {
            
            let node = nodeAtPoint(touch.locationInNode(self))
            
            switch node {
//            case toOtherSceneBtn:
//                toOtherScene()
            default:
                addApple(touch.locationInNode(self))
            }
        }
    }
    
    func toOtherScene() {
        let newScene = GameScene()
        newScene.scaleMode = .ResizeFill
        let transition = SKTransition.moveInWithDirection(SKTransitionDirection.Right, duration: 1)
        view?.presentScene(newScene, transition: transition)
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}

extension UIColor {
    
    static func random() -> UIColor {
        
        return UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1)
    }
}
