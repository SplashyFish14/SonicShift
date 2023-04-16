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
    let playBackEngine = AudioEngine()
    @Published var audio = AudioPlayer()
    
    init(){
        playBackEngine.output = audio
        try? playBackEngine.start()
    }

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
