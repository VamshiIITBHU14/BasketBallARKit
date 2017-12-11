//
//  ViewController.swift
//  ARBasketBall
//
//  Created by Vamshi Krishna on 10/12/17.
//  Copyright © 2017 Vamshi Krishna. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var currentNode:SCNNode!
    
    @IBOutlet weak var actionStackView: UIStackView!
    @IBOutlet weak var addHoopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actionStackView.isHidden = true
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        registerTapGestureRecogniser()
    }
    
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
    
    func horizontalAction (node:SCNNode){
        let leftAction = SCNAction.move(by: SCNVector3(x:-1, y:0, z:0), duration: 2)
        let rightAction = SCNAction.move(to: SCNVector3(x:1, y:0, z:0), duration: 2)
        let actionSequence = SCNAction.sequence([leftAction , rightAction])
        node.runAction(SCNAction.repeat(actionSequence, count: 2))
    }
    
    func roundAction(node:SCNNode){
        let upright = SCNAction.move(by: SCNVector3(x:1, y:1, z:0), duration: 2)
        let downright = SCNAction.move(to: SCNVector3(x:1, y:-1, z:0), duration: 2)
        let downLeft = SCNAction.move(by: SCNVector3(x:-1, y:-1, z:0), duration: 2)
        let upLeft = SCNAction.move(to: SCNVector3(x:-1, y:1, z:0), duration: 2)
        let actionSequence = SCNAction.sequence([upright , downright , downLeft , upLeft])
        node.runAction(SCNAction.repeat(actionSequence, count: 2))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    @IBAction func startRoundAction(_ sender: Any) {
        roundAction(node: currentNode)
    }
    @IBAction func stopAllActions(_ sender: Any) {
        currentNode.removeAllActions()
    }
    
    
    @IBAction func startHorizontalAction(_ sender: Any) {
        horizontalAction(node: currentNode)
    }
    
    
    @IBAction func addHoopClicked(_ sender: Any) {
        addBackboard()
        addHoopButton.isHidden = true
        actionStackView.isHidden = false
    }
    
}
