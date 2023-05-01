//
//  MEngProjectApp.swift
//  MEngProject
//
//  Created by Alice Milburn on 17/02/2023.
//

import SwiftUI

let CustomYellow = Color("CustomYellow")
let CustomPink = Color("CustomPink")
let CustomPurple = Color("CustomPurple")
let CustomGreen = Color("CustomGreen")
let CustomBlue = Color("CustomBlue")
let CustomPaleYellow = Color("CustomPaleYellow")
let CustomPalePink = Color("CustomPalePink")
let CustomPalePurple = Color("CustomPalePurple")
let CustomPaleGreen = Color("CustomPaleGreen")
let CustomPaleBlue = Color("CustomPaleBlue")

var fader1global: CGFloat = 0.0
//var fader2global: CGFloat = 0.0
var fileSelected: Int = 1
//var audioFilePrettyNames: [String] = ["Audio File 1", "Audio File 2", "Audio File 3"]
//var audioFileNames: [String] = ["66319__oneloginacc__loop_98bpm_2bars", "244291__orangefreesounds__80s-disco-drum-loop-114-bpm", "320803__ajubamusic__funky-drum-loops84-bpm(loop10)"]

var instrumentSelected: String = "Samples/Steingway Grand Piano 2"

var oscOn: Bool = true

@main
struct MEngProjectApp: App {
//    @StateObject var audioFileData = AudioFilePlayBack()
//    @Published var fader2global: CGFloat = 0.0
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(PlayBackClass())
        }
    }
}
