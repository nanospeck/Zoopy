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
        guard let sound = SCNAudioSource(named: fileName) else { return }
        sound.volume = 2
        sound.isPositional = true
        sound.load()
        sounds[name] = sound
    }

    func playSound(node: SCNNode, name: String) {
        guard let sound = sounds[name] else { return }

        let action = SCNAction.playAudio(sound, waitForCompletion: false)

        node.runAction(action)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
