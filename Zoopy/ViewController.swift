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
        setupScene()
        addGestureRecognizer()
    }

    func setupScene() {
        // Set the view's delegate
        sceneView.delegate = self

        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.automaticallyUpdatesLighting = true

        // Create a new scene
        //        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        let scene = SCNScene()

        var initialxPosition: Float = -2.0
        var initialzPosition: Float = -3.0
        for item in 0...10 {

            let text = SCNText(string: "\(String(item))", extrusionDepth: 0)
            text.firstMaterial?.diffuse.contents = UIColor.generateRandomPastelColor(withMixedColor: nil)
            text.alignmentMode = kCAAlignmentCenter
            text.font = UIFont(name: "ComicNeue-Bold", size: 1)
            text.name = "number\(String(item))"

            // Position Node
            let textNode = SCNNode(geometry: text)

            //            let ramdomNumber = arc4random_uniform(10)
            let xPosition = initialxPosition
            initialxPosition += 0.8
            let yPosition = -2
            let zPosition = initialzPosition

            textNode.position = SCNVector3(x: Float(xPosition), y: Float(yPosition), z: Float(zPosition))
            textNode.name = "\(String(item))"

            scene.rootNode.addChildNode(textNode)
        }

        // Set the scene to the view
        sceneView.scene = scene
    }
    
    func addGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(ViewController.sceneTapped(recognizer:))
        )
        let gestureRecognizers = NSMutableArray()
        gestureRecognizers.add(tapGesture)

        if let gestureRecognizerObject = sceneView.gestureRecognizers {
            gestureRecognizers.addObjects(from:gestureRecognizerObject)
        }
        sceneView.gestureRecognizers = gestureRecognizers as? [UIGestureRecognizer]
    }

    @objc
    func sceneTapped(recognizer: UITapGestureRecognizer) {
        let location = recognizer.location(in: sceneView)
        let hits = sceneView.hitTest(location, options: nil)

        guard let tappedNode = hits.first?.node else { return }

        guard let nodeColor = tappedNode.geometry?.firstMaterial?.diffuse.contents as? UIColor else {
            print("No nodeColor")
            return
        }

        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.5

        SCNTransaction.completionBlock = {

            if nodeColor.isEqual(UIColor.cyan) {
                tappedNode.geometry?.firstMaterial?.diffuse.contents = UIColor.black
            } else {
                tappedNode.geometry?.firstMaterial?.diffuse.contents = UIColor.cyan
            }
            SCNTransaction.commit()
        }

        tappedNode.geometry?.firstMaterial?.diffuse.contents = UIColor.black
        SCNTransaction.commit()
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
}
