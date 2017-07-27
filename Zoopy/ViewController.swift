//
//  ViewController.swift
//  Zoopy
//
//  Created by Jefferson Bonnaire on 25/07/2017.
//  Copyright © 2017 com.zoopy.app. All rights reserved.
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
        //        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        //        let scene = SCNScene(named: "art.scnassets/rabbit.scn")!
        let scene = SCNScene()
        var numberPosition = -10

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.sceneTapped))
        let gestureRecognizers = NSMutableArray()
        gestureRecognizers.add(tapGesture)
        if let arr = sceneView.gestureRecognizers {
            gestureRecognizers.addObjects(from:arr)
        }
        sceneView.gestureRecognizers = gestureRecognizers as? [UIGestureRecognizer]

        for item in 1...10 {

            let text = SCNText(string: String(item), extrusionDepth: 0.2)
            text.font = UIFont.systemFont(ofSize: 1.0)
            text.firstMaterial?.diffuse.contents = UIColor.cyan
            text.name = "number\(String(item))"

            // Position Node
            let textNode = SCNNode(geometry: text)
//            let ramdomNumber = arc4random_uniform(10)

            let ramdomNumber = numberPosition
            numberPosition += 1
            textNode.position = SCNVector3(x: Float(ramdomNumber), y: 0, z: -5)
            textNode.name = String(item)

            scene.rootNode.addChildNode(textNode)
        }

        // Set the scene to the view
        sceneView.scene = scene
    }

    @objc func sceneTapped(recognizer: UITapGestureRecognizer) {
        let location = recognizer.location(in: sceneView)
        let hits = sceneView.hitTest(location, options: nil)

        guard let tappedNode = hits.first?.node else { return }

        tappedNode.geometry?.firstMaterial?.diffuse.contents = UIColor.black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingSessionConfiguration()
        
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
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else { return }
//        let results = sceneView.hitTest(touch.location(in: sceneView), types: [ARHitTestResult.ResultType.featurePoint])
//
//        print(results.debugDescription)
//
//        guard let hitFeature = results.last else { return }
//
//        guard let anchor = hitFeature.anchor else { return }
//
//        let touchedNode = sceneView.node(for: anchor)
//        // Un-share the geometry by copying
//        touchedNode?.geometry = touchedNode!.geometry?.copy() as? SCNGeometry
//
//        // Un-share the material, too
//        touchedNode?.geometry?.firstMaterial = touchedNode?.geometry?.firstMaterial!.copy() as? SCNMaterial
//        // Now, we can change node's material without changing parent and other childs:
//        touchedNode?.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
////        let hitTransform = SCNMatrix4(hitFeature.worldTransform)
////        let hitVector = SCNVector3Make(hitTransform.m41, hitTransform.m42, hitTransform.m43)
////        TextNode.firstMaterial?.diffuse.contents = UIColor.cyan
//    }

    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
