//
//  ViewController.swift
//  ARTest
//
//  Created by Jose Dominguez on 6/21/19.
//  Copyright © 2019 JD. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
    
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
        //Sets an omni-directional light source within the sceneview in order to view our reflective node material
        //An omni-directional light source is just a light source that spreads across the whole scene
        sceneView.autoenablesDefaultLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        /*  World Tracking is used to track the position and orientation of your device relative to the real world at all times, this is super important because if the phone doesn't know where it's positioned relative to the world around it, then it wouldn't be able to effectively display 3D content in certain places in space
         */

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
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
    
    @IBAction func add(_ sender: Any) {
        //Initializes node object
        //The node is simply a position in space, it has no shape, no size, and no color
        let node = SCNNode()
        //Sets dimensions for node object
        node.geometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.03)
        //Sets reflective material of surface
        node.geometry?.firstMaterial?.specular.contents = UIColor.white
        //Sets object color
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        //Sets x coordinate to be in between -0.3 to 0.3 units of the world origin
        let x = randomNumbers(firstNum: -0.3, secondNum: 0.3)
        //Sets y coordinate to be in between -0.3 to 0.3 units of the world origin
        let y = randomNumbers(firstNum: -0.3, secondNum: 0.3)
        //Sets z coordinate to be in between -0.3 to 0.3 units of the world origin
        let z = randomNumbers(firstNum: -0.3, secondNum: 0.3)
        //Sets initial position being behind the origin by -1
        //Sets static position of node object
        //The problem with static positioning is that whenever you add another node object they will be placed on top of one another
        //node.position = SCNVector3(0,0,-1)
        node.position = SCNVector3(x,y,z)
        //Displays the node within the sceneView
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    @IBAction func reset(_ sender: Any) {
        //Calls the restarts session function
        restartSession()
    }
    
    func restartSession() {
        //Here we are going to pause the scene view session so it stops keeping track of your position or orientation
        sceneView.session.pause()
        //We then remove the node from the sceneView
        sceneView.scene.rootNode.enumerateChildNodes{node,_ in node.removeFromParentNode()
            }
        //Then we are re-running the sceneView
        sceneView.session.run(ARWorldTrackingConfiguration(), options: [.resetTracking, .removeExistingAnchors])
 
    }
    
    //This function sets a random numbers that is in between firstNum and secondNum
    func randomNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }
    
    
}
