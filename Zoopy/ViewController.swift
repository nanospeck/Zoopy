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
        var angle:Float = 0.0
        let radius:Float = 4.0
        let angleIncrement:Float = Float.pi * 2.0 / Float(11)

        for item in 0...10 {

            let number = SCNText(string: "\(String(item))", extrusionDepth: 0.2)
            number.firstMaterial?.diffuse.contents = UIColor.generateRandomPastelColor(withMixedColor: nil)
            number.alignmentMode = kCAAlignmentCenter
            number.font = UIFont(name: "ComicNeue-Bold", size: 1.5)
            number.name = "number\(String(item))"

            // Position Node
            let numberNode = SCNNode(geometry: number)

            let x = radius * cos(angle)
            let z = radius * sin(angle)
            numberNode.position = SCNVector3Make(x, -1, z)
            numberNode.constraints = [SCNBillboardConstraint()]
            angle += angleIncrement

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

        guard tappedNode.name == "3" else {
            AudioController.shared.addSound(fileName: "Fail.wav", name: "Fail")
            AudioController.shared.playSound(node: tappedNode, name: "Fail")

            let moveUp = SCNAction.moveBy(x: 0.0, y: 0.1, z: 0.0, duration: 0.1)
            let moveDown = SCNAction.moveBy(x: 0.0, y: -0.1, z: 0.0, duration: 0.1)
            let sequence = SCNAction.sequence([moveUp,moveDown,moveUp,moveDown])

            guard let sequenceToAnimate = sequence else { return }

            tappedNode.runAction(sequenceToAnimate)
            return
        }

        AudioController.shared.addSound(fileName: "Success.wav", name: "Success")
        AudioController.shared.playSound(node: tappedNode, name: "Success")

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
