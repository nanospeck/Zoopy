//
//  AudioController.swift
//  Zoopy
//
//  Created by Jefferson Bonnaire on 29/07/2017.
//  Copyright © 2017 com.zoopy.app. All rights reserved.
//

import Foundation
import SceneKit
import SpriteKit

class AudioController: SCNNode {

    static let shared = AudioController()
    var sounds: [String:SCNAudioSource] = [:]

    override init() {
        super.init()
    }

    func addSound(fileName: String, name: String) {
        guard let sound = SCNAudioSource(named: fileName) else {
            print("No Sound found")
            return
        }

        sound.volume = 2
        sound.isPositional = true
        sound.load()
        sounds[name] = sound
        print(sounds)
    }

    func playSound(node: SCNNode, name: String) {
        print("playSound")
        print(sounds)
        guard let sound = sounds[name] else {
            print("No sound")
            return
        }
        print(sound)

        let action = SCNAction.playAudio(sound, waitForCompletion: false)
        print("Jes suis là")

        node.runAction(action)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
