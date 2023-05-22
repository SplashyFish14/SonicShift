//
//  PlayBackClass.swift
//  MEngProject
//
//  Created by Alice Milburn on 11/04/2023.
//

import Foundation
import AudioKit
import AVFoundation
import SwiftUI

final class PlayBackClass: ObservableObject {
    //Set up audio engine and audio player
    let playBackEngine = AudioEngine()
    let audio = AudioPlayer()
    //Initiallise the output of the engine and start it
    init(){
        playBackEngine.output = audio
        try? playBackEngine.start()
        audio.volume = 2
    }
    //Set up function to load files into the audio played
    func loadFiles(fileName: String){
        do {
            if let file = Bundle.main.url(forResource: fileName, withExtension: "mp3")
            {
                try audio.load(url: file)
            } else {
                Log("Could not find file")
            }
        } catch {
            Log("Could not load track")
        }
    }
}
