//
//  ContentView.swift
//  CirclePong
//
//  Created by Pål-Erik Martinsen on 04/01/2023.
//

import SwiftUI
import SpriteKit



struct ContentView: View {
    var scene: SKScene {
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        let scene = GameScene()
        scene.size = CGSize(width: width, height: height)
        scene.scaleMode = .fill
        scene.backgroundColor = .black
        return scene
    }

    var body: some View {
        SpriteView(scene: scene)
            //.frame(width: 300, height: 400)
            .ignoresSafeArea()
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
