//
//  ContentView.swift
//  CirclePong
//
//  Created by Pål-Erik Martinsen on 04/01/2023.
//

import SwiftUI
import SpriteKit


struct ContentView: View {
    @State private var gameStarted = false
    @State private var gameEnded = false
    @State private var score = 0

    var body: some View {
        if gameStarted && !gameEnded{
            GameView(gameStarted: $gameStarted, gameEnded: $gameEnded, score: $score)
        }
        else if gameEnded{
            GameEndedView(gameStarted: $gameStarted, gameEnded: $gameEnded, score: $score)
        }
        else {
            StartGameView(gameStarted: $gameStarted)
        }
    }
}

struct GameView: View {
    @Binding var gameStarted: Bool
    @Binding var gameEnded: Bool
    @Binding var score: Int
    @StateObject private var gameScene = GameScene()
    var scene: SKScene {
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        let scene = gameScene
        scene.size = CGSize(width: width, height: height)
        scene.scaleMode = .fill
        scene.backgroundColor = .black
        return scene
    }

    var body: some View {
        ZStack{
            SpriteView(scene: scene)
            //.frame(width: 300, height: 400)
                .ignoresSafeArea()
                .onReceive(gameScene.$isGameOver) { isGameOver in
                                    if isGameOver {
                                        score = gameScene.score
                                        gameScene.resetGame()
                                        gameStarted = false
                                        gameEnded = true// Return to the start screen
                                    }
                                }
            // Score Panel
            VStack {
                Text("Score: \(gameScene.score)")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(10)
                    .padding(.top, 20)

                Spacer()
            }
        }
        
    }
}

struct StartGameView: View {
    @Binding var gameStarted: Bool

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                Text("Circle Pong")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()

                Button(action: {
                    gameStarted = true
                }) {
                    Text("Start Game")
                        .font(.title)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
    }
}

struct GameEndedView: View {
    @Binding var gameStarted: Bool
    @Binding var gameEnded: Bool
    @Binding var score: Int
   

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                Text("score: \(score)")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()

                Text("Game Over")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()

                Button(action: {
                    gameStarted = true
                    gameEnded = false
                }) {
                    Text("New Game")
                        .font(.title)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
