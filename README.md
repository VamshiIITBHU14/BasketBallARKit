# BasketBallARKit
Hello Everyone, This project talks about basics of ARKit introduced by Apple in iOS11. Please note that ARKit is only capable wih 
devices which use A9, A10, A11 chips and the devices that use these chips are:

a) iPhone 6s and 6s Plus 
b) iPhone 7 and 7 Plus 
c) iPhone SE
d) iPad Pro (9.7, 10.5 or 12.9) – both first-gen and 2nd-gen
e) iPad (2017)
f) iPhone 8 and 8 Plus
g) iPhone X

Now coming to the project, it shows how to build a basic BasketBall app using ARKit. Taking it step by step:

PS: Please note that we have to choose Augmented Reality App as template when you create the project.

1) Camera Permission:

This step involves asking for permission from user for his Camera access. This can be done by adding 'Privacy - Camera Usage Description : This application will use the camera for Augmented Reality' as key-value in pair in info.plist

2) Adding the hoop:

After you launch the app, you just see the world infront of you through phone's camera. Now you can augment a Basketball hoop by just adding the code below:

```
func addBackboard(){
        guard  let backboardScene = SCNScene(named:"art.scnassets/hoop.scn") else{return}
        guard let backboardNode = backboardScene.rootNode.childNode(withName: "backboard", recursively: false) else{return}
        backboardNode.position = SCNVector3(x:0.0, y:0.5, z:-3)
        
        let physicsShape = SCNPhysicsShape(node: backboardNode, options: [SCNPhysicsShape.Option.type : SCNPhysicsShape.ShapeType.concavePolyhedron])
        let physicsBody = SCNPhysicsBody(type: .static, shape: physicsShape)
        backboardNode.physicsBody = physicsBody
        
        sceneView.scene.rootNode.addChildNode(backboardNode)
        currentNode = backboardNode
    }
```

<img width="462" alt="screen shot 2017-12-11 at 1 55 52 pm" src="https://user-images.githubusercontent.com/21070922/33821763-1db1e81e-de7b-11e7-8ac2-16fe006176b0.png">


Then we add a Tap Gesture onto the SceneView to aim the ball at the basket. 

```
func registerTapGestureRecogniser(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(gesture:)))
        sceneView.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(gesture:UIRotationGestureRecognizer){
        //scene view to be accessed
        //access the center point of the sceneview
        guard let sceneView = gesture.view as? ARSCNView else{return}
        guard let centerPoint = sceneView.pointOfView else{return}
        
        let cameraTransform = centerPoint.transform
        let cameraLocation = SCNVector3(x:cameraTransform.m41, y: cameraTransform.m42, z:cameraTransform.m43)
        let cameraOrientation = SCNVector3(x: -cameraTransform.m31, y: -cameraTransform.m32, z: -cameraTransform.m33)
        let cameraPosition = SCNVector3Make(cameraLocation.x + cameraOrientation.x, cameraLocation.y + cameraOrientation.y , cameraLocation.z + cameraOrientation.z)
        
        let ball = SCNSphere()
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named:"basketballSkin.png")
        ball.materials = [material]
        
        let ballNode = SCNNode(geometry:ball)
        ballNode.position = cameraPosition
        
        let physcisShape = SCNPhysicsShape(geometry: ball, options: nil)
        let physicsBody = SCNPhysicsBody(type: .dynamic, shape: physcisShape)
        
        ballNode.physicsBody = physicsBody
        let forceVector:Float = 6
        ballNode.physicsBody?.applyForce(SCNVector3(x:cameraOrientation.x * forceVector, y:cameraOrientation.y * forceVector, z: cameraOrientation.z * forceVector), asImpulse:true)
        
        sceneView.scene.rootNode.addChildNode(ballNode)
        
    }
```

>diffuse property of SCNMaterial deals with how light is rendered on the material and contents property deals with the actual parents of the material
    

<img width="454" alt="screen shot 2017-12-11 at 3 23 44 pm" src="https://user-images.githubusercontent.com/21070922/33825353-5c0ed228-de87-11e7-85ff-6890906c38c8.png">

Optional:

Moving objects in AR Space is really straight forward. Here I am posting two methods to move the hoop in XY plane in a horizontal and circuit manner:

```
func horizontalAction (node:SCNNode){
        let leftAction = SCNAction.move(by: SCNVector3(x:-1, y:0, z:0), duration: 2)
        let rightAction = SCNAction.move(to: SCNVector3(x:1, y:0, z:0), duration: 2)
        let actionSequence = SCNAction.sequence([leftAction , rightAction])
        node.runAction(SCNAction.repeat(actionSequence, count: 2))
    }
 ```

