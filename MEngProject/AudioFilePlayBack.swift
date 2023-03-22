//
//  AudioFilePlayBack.swift
//  MEngProject
//
//  Created by Alice Milburn on 03/03/2023.
//

import SwiftUI
import AudioKit
import AudioKitUI
import AVFoundation
import Combine

let audioFiles: [AudioSamples] =
    [
        AudioSamples(id: 1, name: "Drum Loop 1", fileName: "66319__oneloginacc__loop_98bpm_2bars", songid: 1),
        AudioSamples(id: 2, name: "Drum Loop 2", fileName: "244291__orangefreesounds__80s-disco-drum-loop-114-bpm", songid: 2),
        AudioSamples(id: 3, name: "Drum Loop 3", fileName: "320803__ajubamusic__funky-drum-loops84-bpm(loop10)", songid: 3)
    ]

struct AudioSamples: Identifiable {
    var id: Int
    
    var name: String
    var fileName: String
    var songid: Int
}

class PlayBackClass: ObservableObject {
    let playBackEngine = AudioEngine()
    var audio = AudioPlayer()

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


struct AudioFilePlayBack: View {
    struct AudioFileMenuView: View {
            var body: some View {
                AudioFIleMenu(audioFiles: audioFiles)
        }
    }
    @State private var isShowingAudioFileMenu = false
    @State var  isPlaying: Bool = false
    @StateObject var conductor = PlayBackClass()
    @State var playbackImage = Image(systemName: "pause.fill")
    
    var body: some View {
        
        ZStack{
            RoundedRectangle(cornerRadius: 50)
                .fill(Color.gray)
            VStack{
                HStack{
                    Button(action: {
                        print("backward")
                    }) {
                        Image(systemName: "chevron.backward.circle")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color.black)
                            .padding(10)
                    }
                    Button(action: {
                        print("Play")
                        conductor.audio.volume = AUValue(fader2global)

                        conductor.loadFiles(fileName: audioFiles[fileSelected - 1].fileName)
                        if isPlaying == false {
                            conductor.audio.start()
                            conductor.audio.isLooping = true
                            isPlaying.toggle()
                            print("Audio file start")
                        } else{
                            conductor.audio.pause()
                            isPlaying.toggle()
                            print("Audio file pause")

                        }
                    }) {
                        if isPlaying == true {
                            Image(systemName: "pause.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(Color.black)
                                .padding(10)
                        } else {
                            Image(systemName: "play.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(Color.black)
                                .padding(10)
                        }
                        
                    }
                    Button(action: {
                        print("foreward")
                    }) {
                        Image(systemName: "chevron.forward.circle")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color.black)
                            .padding(10)
                    }
                }
                .padding(.top, 10)

                
                Button(action: {
                    print("Audio File Menu")
                    isShowingAudioFileMenu.toggle()
                }){
                    ZStack{
                        RoundedRectangle(cornerRadius: 50)
                            .padding(30)
                            .foregroundColor(.black)
                        Text("Audio file 1")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                    }
                    
                }
                .sheet(isPresented: $isShowingAudioFileMenu, onDismiss: didDismiss){
                    AudioFileMenuView()
                }
            }
        }
    }
    func didDismiss(){
        isShowingAudioFileMenu = false
    }
}

struct AudioFilePlayBack_Previews: PreviewProvider {
    static var previews: some View {
        AudioFilePlayBack()
            .previewInterfaceOrientation(.landscapeLeft)

    }
}
