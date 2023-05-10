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
        AudioSamples(id: 3, name: "Drum Loop 3", fileName: "320803__ajubamusic__funky-drum-loops84-bpm(loop10)", songid: 3),
        AudioSamples(id: 4, name: "Hip Hop Loop", fileName: "hop1", songid: 4),
        AudioSamples(id: 5, name: "Simple Beat", fileName: "187471__minecast__simple-loopable-beat", songid: 5),
        AudioSamples(id: 6, name: "Guitar Loop", fileName: "395037__kodack__simple-relaxing-guitar-loop", songid: 6)
    ]

struct AudioSamples: Identifiable {
    var id: Int
    
    var name: String
    var fileName: String
    var songid: Int
}

//class PlayBackClass: ObservableObject {
//    let playBackEngine = AudioEngine()
//    @Published var audio = AudioPlayer()
//    @Published var trackVolumeFader: CGFloat = 0.0
//    init(){
//        playBackEngine.output = audio
//        try? playBackEngine.start()
//        audio.volume = AUValue(trackVolumeFader)
//    }
//
//    func loadFiles(fileName: String){
//        do {
//            if let file = Bundle.main.url(forResource: fileName, withExtension: "mp3")
//            {
//                try audio.load(url: file)
//            } else {
//                Log("Could not find file")
//            }
//        } catch {
//            Log("Could not load track")
//        }
//    }
//}


struct AudioFilePlayBack: View {
    @EnvironmentObject var conductor: PlayBackClass
    
    struct AudioFileMenuView: View {
            var body: some View {
                AudioFIleMenu(audioFiles: audioFiles)
        }
    }
    @State private var isShowingAudioFileMenu = false
    @State var  isPlaying: Bool = false
    //@StateObject var conductor = PlayBackClass()
    @State var playbackImage = Image(systemName: "pause.fill")
    
    @State var maxAudioFiles = 6
    @State var update = true
    
    @State var selectedPrettyName = audioFiles[fileSelected - 1 ].name
    @EnvironmentObject var colours: ColourScheme
    @EnvironmentObject var performanceMode: Performance

    
    var body: some View {
        
        ZStack{
            RoundedRectangle(cornerRadius: 50)
                .fill(colours.colour2)
            VStack{
                HStack{
                    Button(action: {
                        print("backward")
                        if fileSelected > 1 {
                            fileSelected = fileSelected - 1

                        } else {
                            fileSelected = maxAudioFiles
                        }
                        conductor.loadFiles(fileName: audioFiles[fileSelected - 1 ].fileName)
                        if isPlaying == true {
                            conductor.audio.start()
                        }
                        update.toggle()

                    }) {
                        Image(systemName: "chevron.backward.circle")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color.white)
                            .padding(10)
                    }
                    Button(action: {
                        print("Play")
                        print("Volumesssssss: \(conductor.audio.volume)")
                        conductor.loadFiles(fileName: audioFiles[fileSelected - 1].fileName)
                        //conductor.audio.volume = AUValue()
                        print("audio file loaded")
                        if isPlaying == false {
                            conductor.audio.isLooping = true
                            isPlaying.toggle()
                            print("Audio file start")
                            conductor.audio.play()
                            
                            //print("Volume: \(conductor.audio.volume)")

                        } else{
                            isPlaying.toggle()
                            print("Audio file pause")
                            conductor.audio.pause()
                        }
                        update.toggle()

                    }) {
                        if isPlaying == true {
                            Image(systemName: "pause.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(Color.white)
                                .padding(10)
                        } else {
                            Image(systemName: "play.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(Color.white)
                                .padding(10)
                        }
                        
                    }
                    Button(action: {
                        print("forward")
                        if fileSelected < maxAudioFiles {
                            fileSelected = fileSelected + 1

                        } else {
                            fileSelected = 1
                        }
                        conductor.loadFiles(fileName: audioFiles[fileSelected-1].fileName)
                        if isPlaying == true{
                            conductor.audio.start()

                        }
                        update.toggle()


                    }) {
                        Image(systemName: "chevron.forward.circle")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color.white)
                            .padding(10)
                    }
                }
                .padding(.top, 10)

                
                Button(action: {
                    print("Audio File Menu")
                    if performanceMode.mode == false{
                        isShowingAudioFileMenu.toggle()
                    } else{
                        print("performance mode on")
                    }
                    
                }){
                    ZStack{
                        RoundedRectangle(cornerRadius: 50)
                            .padding(30)
                            .foregroundColor(Color.white)
                        if update == true{
                            Text(audioFiles[fileSelected - 1 ].name)
                                .foregroundColor(colours.colour4)
                                .font(.largeTitle).bold()
                        } else {
                            Text(audioFiles[fileSelected - 1 ].name)
                                .foregroundColor(colours.colour4)
                                .font(.largeTitle).bold()
                        }
                        
                        
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
        update.toggle()
    }
}

struct AudioFilePlayBack_Previews: PreviewProvider {
    static var previews: some View {
        AudioFilePlayBack()
            .previewInterfaceOrientation(.landscapeLeft)
            .environmentObject(PlayBackClass())

    }
}
