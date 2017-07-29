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
    lazy var scene: SCNScene = {
        let scene = SCNScene()
        return scene
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
        addGestureRecognizer()
        askQuestions()
    }

    func setupScene() {
        // Set the view's delegate
        sceneView.delegate = self

        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.automaticallyUpdatesLighting = true

        // Setup Numbers
        var initialxPosition: Float = -2.0
        let initialzPosition: Float = -3.0
        for item in 0...10 {

            let number = SCNText(string: "\(String(item))", extrusionDepth: 0.2)
            number.firstMaterial?.diffuse.contents = UIColor.generateRandomPastelColor(withMixedColor: nil)
            number.alignmentMode = kCAAlignmentCenter
            number.font = UIFont(name: "ComicNeue-Bold", size: 1)
            number.name = "number\(String(item))"

            // Position Node
            let numberNode = SCNNode(geometry: number)

            let xPosition = initialxPosition
            initialxPosition += 0.8
            let yPosition = -2
            let zPosition = initialzPosition

            numberNode.position = SCNVector3(x: Float(xPosition), y: Float(yPosition), z: Float(zPosition))
            numberNode.name = "\(String(item))"

            scene.rootNode.addChildNode(numberNode)
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

    func askQuestions() {
        AudioController.shared.addSound(fileName: "NumberThree.m4a", name: "NumberThree")
        AudioController.shared.playSound(node: scene.rootNode, name: "NumberThree")
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

        if tappedNode.name == "3" {
            AudioController.shared.addSound(fileName: "Success.wav", name: "Success")
            AudioController.shared.playSound(node: tappedNode, name: "Success")
        }

        print(tappedNode.scale)

        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0

        SCNTransaction.completionBlock = {

            SCNTransaction.begin()
            SCNTransaction.animationDuration = 1
            if nodeColor.isEqual(UIColor.cyan) {
                tappedNode.geometry?.firstMaterial?.diffuse.contents = UIColor.black
            } else {
                tappedNode.geometry?.firstMaterial?.diffuse.contents = UIColor.cyan
            }
            let scaleForCorrectAnswer: Float = 1
            tappedNode.scale = SCNVector3(
                x:scaleForCorrectAnswer,
                y:scaleForCorrectAnswer,
                z:scaleForCorrectAnswer)
            SCNTransaction.commit()
        }
        let scaleBackToOriginalValue: Float = 1.5
        tappedNode.scale = SCNVector3(x:scaleBackToOriginalValue,
                                      y:scaleBackToOriginalValue,
                                      z:scaleBackToOriginalValue)
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
