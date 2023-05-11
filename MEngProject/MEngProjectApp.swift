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
let CustomYellow2 = Color("CustomYellow2")
let CustomRed = Color("CustomRed")
let CustomGreen2 = Color("CustomGreen2")
let CustomBlue2 = Color("CustomBlue2")
let CustomPurple2 = Color("CustomPurple2")
let CustomPaleYellow2 = Color("CustomPaleYellow2")
let CustomPaleRed = Color("CustomPaleRed")
let CustomPaleGreen2 = Color("CustomPaleGreen2")
let CustomPaleBlue2 = Color("CustomPaleBlue2")
let CustomPalePurple2 = Color("CustomPalePurple2")
let Purp1 = Color("Purp1")
let Purp2 = Color("Purp2")
let Purp3 = Color("Purp3")
let Purp4 = Color("Purp4")
let Purp5 = Color("Purp5")



var fader1global: CGFloat = 0.0
//var fader2global: CGFloat = 0.0
var fileSelected: Int = 1
//var audioFilePrettyNames: [String] = ["Audio File 1", "Audio File 2", "Audio File 3"]
//var audioFileNames: [String] = ["66319__oneloginacc__loop_98bpm_2bars", "244291__orangefreesounds__80s-disco-drum-loop-114-bpm", "320803__ajubamusic__funky-drum-loops84-bpm(loop10)"]

var instrumentSelected: String = "Samples/Steingway Grand Piano 2"

var oscOn: Bool = true

@main
struct MEngProjectApp: App {
//    @EnvironmentObject var colours = ColourScheme()
    
//    @StateObject var audioFileData = AudioFilePlayBack()
//    @Published var fader2global: CGFloat = 0.0
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(PlayBackClass())
                .environmentObject(ColourScheme())
                .environmentObject(Performance())
                .environmentObject(Volumes())
        }
    }
}
