//
//  ContentView.swift
//  MEngProject
//
//  Created by Alice Milburn on 17/02/2023.
//

import SwiftUI
import Controls
import CoreMotion
import AudioKit
import AudioKitUI
import AudioToolbox
import SoundpipeAudioKit
import Tonic
import DunneAudioKit
import AVFoundation

//initialise oscillator
class OscillatorConductor: ObservableObject, HasAudioEngine {
    //Set up audio engine
    let engine = AudioEngine()
    //Set up oscillator
    var instrument = AppleSampler()
//    var instrument = MIDISampler(name: "Instrument 1")
    var osc = Oscillator()
    init() {
        //Set the oscillator as the engine output
        //Set initial values for the oscilators amplitude and frequency
        osc.amplitude = 0.3
//        print("Amplitude: \(osc.amplitude)")
        osc.frequency = 330
//        print("Frequency: \(osc.frequency)")
        
//        engine.output = osc
        engine.output = instrument
//        engine.output = osc
        //Start the engine
        try? engine.start()

        do {
            if let fileURL = Bundle.main.url(forResource: "Samples/Steinway Grand Piano 2", withExtension: "exs"){
                print(fileURL)
                try instrument.loadInstrument(url: fileURL)
            } else {
                    Log("Could not find file")
            }
        } catch {
            Log("Could not load instrument")
            
        }
//        try? engine.start()
    }
}

struct ContentView: View {
    @EnvironmentObject var fader2: PlayBackClass
    
    @State var sliderValue: Float = 0
    @State var volValue: Float = 0
    @State var revValue: Float = 0
    
    @State var midiNote: Float = 0
    @State var myFrequency: Double = 0.0
    
    //Values to allow buttons to scale
    @State var thirdWidth: CGFloat = UIScreen.main.bounds.width/3
    @State var thirdHeight: CGFloat = UIScreen.main.bounds.height/3
    @State var sixthWidth: CGFloat = UIScreen.main.bounds.width/6
    
    //Set up motion manager
    let motionManager = CMMotionManager()
    let motionManagerDM = CMMotionManager()
    
    @StateObject var conductor = OscillatorConductor()
    @State var oscOn: Bool = false
    
    //Set up sheet showing booleans
    @State private var isShowingSelectInstrumentMenu = false
    @State private var isShowingAudioEffectsMenu = false
    @State private var isShowingSettingsMenu = false
    
    @State var performMode = false
    @EnvironmentObject var colours: ColourScheme

    
    var body: some View {
        VStack {
            VStack(alignment: .center, spacing: 15) {
                VStack(alignment: .center){
                    HStack {
                        //Show instrument Menu button
                        Button(action: {
                            print("Instrument Menu")
                            isShowingSelectInstrumentMenu.toggle()

                        }){
                            VStack{
                                Image(systemName: "pianokeys.inverse")
                                    .resizable()
                                    .scaledToFit()
                                    .font(.largeTitle)
                                    .foregroundColor(Color.white)
                                
                                Text("Instrument")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.white)
                            }
                        }
                        .buttonStyle(MyButtonStyle())
                        .frame(width: thirdWidth - 20)
                        .sheet(isPresented: $isShowingSelectInstrumentMenu, onDismiss: instrumentDidDismiss){
                            SelectInstrument()}
                        //Show effects menu button
                        Button(action: {
                            print("Effects Menu")
                            isShowingAudioEffectsMenu.toggle()
                        }){
                            VStack{
                                Image(systemName: "slider.vertical.3")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(Color.white)
                                Text("Effects")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.white)
                            }
                        }
                        .buttonStyle(MyButtonStyle())
                        .frame(width: thirdWidth - 20)
                        .sheet(isPresented: $isShowingAudioEffectsMenu, onDismiss: effectsDidDismiss){
                            AudioEffectsMenu()}
                        //Show settings menu button
                        Button(action: {
                            print("Settings")
                            isShowingSettingsMenu.toggle()
                        }){
                            VStack{
                                Image(systemName: "gearshape.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .font(.largeTitle)
                                    .foregroundColor(Color.white)
                                Text("Settings")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.white)
                            }
                        }
                        .buttonStyle(MyButtonStyle())
                        .frame(width: thirdWidth - 20)
                        .sheet(isPresented: $isShowingSettingsMenu, onDismiss: settingsDidDismiss){
                            SettingsMenu()}
                    }
                    .padding(.top, 10.0)
                    .frame(height: thirdHeight - 30)
                
                    HStack {
                        //Ossicaltor fader
                        Fader()
                            .frame(width: sixthWidth)
                            .accessibilityLabel("Instrument Fader")
                            .accessibilityRespondsToUserInteraction(true)

                        
                        VStack{
                            HStack {
                                //1st arc knob
                                ArcKnob("Effect", value: $volValue)
                                    .foregroundColor(colours.colour5)
                                    .frame(height: thirdHeight - 20)
//                                    .backgroundColor(CustomGreen)
//                                    .backgroundStyle(CustomGreen)
//                                ArcKnob.backgroundColor = CustomGreen
//backgroundStyle()
                                //2nd arc knob
                                ArcKnob("Effect", value: $revValue)
                                    .foregroundColor(colours.colour5)
                                    .frame(height: thirdHeight - 20)
                            }
                            //Playback section
                            AudioFilePlayBack()
                                .frame(height: thirdHeight)
                                .environmentObject(PlayBackClass())
                        }
                        //Right fader
                        Fader2()
                            .frame(width: sixthWidth)
                            .environmentObject(PlayBackClass())
                            .accessibilityLabel("Audio Playback Fader")
                            .accessibilityRespondsToUserInteraction(true)

                    }
                }
            }
            //Motion manager updates, and oscillator updates
            //On appear of app home screen
            .onAppear(){
                //Start the oscillator
                conductor.osc.start()
//                conductor.instrument.start()

                //Start motion manager updates
                motionManagerDM.startDeviceMotionUpdates(to: OperationQueue.main) {
                    (data, error) in
                    if let deviceData = motionManagerDM.deviceMotion {
//                        print("pitch: \(deviceData.attitude.pitch)" +                              "roll: \(deviceData.attitude.roll) yaw: \(deviceData.attitude.yaw)")
//                        print("pitch: \(deviceData.attitude.pitch)")
                        //Sets oscillator amplitude based on left fader value
                        conductor.osc.amplitude = AUValue(fader1global)
                        //Sets oscillator frequency based on device pitch
                        conductor.osc.frequency = AUValue((deviceData.attitude.pitch + 1.56) * 500)
                        myFrequency = (deviceData.attitude.pitch + 1.56) * 500
                        //print(conductor.osc.frequency)
                        //print(fader1global)
                        switch(deviceData.attitude.pitch) {
                        case -1.5 ..< -1.4:
                            if midiNote == 70 {
                                
                            } else {
                                conductor.instrument.stop(noteNumber: 71, channel: 0)
                                conductor.instrument.stop(noteNumber: 72, channel: 0)
                                conductor.instrument.stop(noteNumber: 73, channel: 0)
                                conductor.instrument.stop(noteNumber: 74, channel: 0)
                                conductor.instrument.stop(noteNumber: 75, channel: 0)
                                conductor.instrument.stop(noteNumber: 76, channel: 0)
                                conductor.instrument.stop(noteNumber: 77, channel: 0)
                                conductor.instrument.stop(noteNumber: 78, channel: 0)
                                conductor.instrument.stop(noteNumber: 79, channel: 0)
                                conductor.instrument.stop(noteNumber: 80, channel: 0)
                                conductor.instrument.stop(noteNumber: 81, channel: 0)
                                conductor.instrument.stop(noteNumber: 82, channel: 0)
                                conductor.instrument.stop(noteNumber: 83, channel: 0)
                                conductor.instrument.stop(noteNumber: 84, channel: 0)
                                conductor.instrument.stop(noteNumber: 85, channel: 0)
                                conductor.instrument.stop(noteNumber: 86, channel: 0)
                                conductor.instrument.stop(noteNumber: 87, channel: 0)
                                conductor.instrument.stop(noteNumber: 88, channel: 0)
                                conductor.instrument.stop(noteNumber: 89, channel: 0)
                                conductor.instrument.stop(noteNumber: 90, channel: 0)
                                conductor.instrument.stop(noteNumber: 91, channel: 0)
                                conductor.instrument.stop(noteNumber: 92, channel: 0)
                                conductor.instrument.stop(noteNumber: 93, channel: 0)
                                conductor.instrument.stop(noteNumber: 94, channel: 0)
                                conductor.instrument.stop(noteNumber: 95, channel: 0)
                                conductor.instrument.stop(noteNumber: 96, channel: 0)
                                conductor.instrument.stop(noteNumber: 97, channel: 0)
                                conductor.instrument.stop(noteNumber: 98, channel: 0)
                                conductor.instrument.stop(noteNumber: 99, channel: 0)
                                conductor.instrument.stop(noteNumber: 100, channel: 0)
                                conductor.instrument.stop(noteNumber: 101, channel: 0)
                                midiNote = 70
                                conductor.instrument.play(noteNumber: MIDINoteNumber(midiNote), velocity: UInt8(fader1global*100), channel: 0)
                            }
                        case -1.4 ..< -1.3:
                            if midiNote == 71 {
                            
                            } else {
                                conductor.instrument.stop(noteNumber: 70, channel: 0)
                                conductor.instrument.stop(noteNumber: 72, channel: 0)
                                conductor.instrument.stop(noteNumber: 73, channel: 0)
                                conductor.instrument.stop(noteNumber: 74, channel: 0)
                                conductor.instrument.stop(noteNumber: 75, channel: 0)
                                conductor.instrument.stop(noteNumber: 76, channel: 0)
                                conductor.instrument.stop(noteNumber: 77, channel: 0)
                                conductor.instrument.stop(noteNumber: 78, channel: 0)
                                conductor.instrument.stop(noteNumber: 79, channel: 0)
                                conductor.instrument.stop(noteNumber: 80, channel: 0)
                                conductor.instrument.stop(noteNumber: 81, channel: 0)
                                conductor.instrument.stop(noteNumber: 82, channel: 0)
                                conductor.instrument.stop(noteNumber: 83, channel: 0)
                                conductor.instrument.stop(noteNumber: 84, channel: 0)
                                conductor.instrument.stop(noteNumber: 85, channel: 0)
                                conductor.instrument.stop(noteNumber: 86, channel: 0)
                                conductor.instrument.stop(noteNumber: 87, channel: 0)
                                conductor.instrument.stop(noteNumber: 88, channel: 0)
                                conductor.instrument.stop(noteNumber: 89, channel: 0)
                                conductor.instrument.stop(noteNumber: 90, channel: 0)
                                conductor.instrument.stop(noteNumber: 91, channel: 0)
                                conductor.instrument.stop(noteNumber: 92, channel: 0)
                                conductor.instrument.stop(noteNumber: 93, channel: 0)
                                conductor.instrument.stop(noteNumber: 94, channel: 0)
                                conductor.instrument.stop(noteNumber: 95, channel: 0)
                                conductor.instrument.stop(noteNumber: 96, channel: 0)
                                conductor.instrument.stop(noteNumber: 97, channel: 0)
                                conductor.instrument.stop(noteNumber: 98, channel: 0)
                                conductor.instrument.stop(noteNumber: 99, channel: 0)
                                conductor.instrument.stop(noteNumber: 100, channel: 0)
                                conductor.instrument.stop(noteNumber: 101, channel: 0)
                                midiNote = 71
                                conductor.instrument.play(noteNumber: MIDINoteNumber(midiNote), velocity: UInt8(fader1global*100), channel: 0)
                            }
                        case -1.3 ..< -1.2:
                            if midiNote == 72 {
                                
                            } else {
                                conductor.instrument.stop(noteNumber: 70, channel: 0)
                                conductor.instrument.stop(noteNumber: 71, channel: 0)
                                conductor.instrument.stop(noteNumber: 73, channel: 0)
                                conductor.instrument.stop(noteNumber: 74, channel: 0)
                                conductor.instrument.stop(noteNumber: 75, channel: 0)
                                conductor.instrument.stop(noteNumber: 76, channel: 0)
                                conductor.instrument.stop(noteNumber: 77, channel: 0)
                                conductor.instrument.stop(noteNumber: 78, channel: 0)
                                conductor.instrument.stop(noteNumber: 79, channel: 0)
                                conductor.instrument.stop(noteNumber: 80, channel: 0)
                                conductor.instrument.stop(noteNumber: 81, channel: 0)
                                conductor.instrument.stop(noteNumber: 82, channel: 0)
                                conductor.instrument.stop(noteNumber: 83, channel: 0)
                                conductor.instrument.stop(noteNumber: 84, channel: 0)
                                conductor.instrument.stop(noteNumber: 85, channel: 0)
                                conductor.instrument.stop(noteNumber: 86, channel: 0)
                                conductor.instrument.stop(noteNumber: 87, channel: 0)
                                conductor.instrument.stop(noteNumber: 88, channel: 0)
                                conductor.instrument.stop(noteNumber: 89, channel: 0)
                                conductor.instrument.stop(noteNumber: 90, channel: 0)
                                conductor.instrument.stop(noteNumber: 91, channel: 0)
                                conductor.instrument.stop(noteNumber: 92, channel: 0)
                                conductor.instrument.stop(noteNumber: 93, channel: 0)
                                conductor.instrument.stop(noteNumber: 94, channel: 0)
                                conductor.instrument.stop(noteNumber: 95, channel: 0)
                                conductor.instrument.stop(noteNumber: 96, channel: 0)
                                conductor.instrument.stop(noteNumber: 97, channel: 0)
                                conductor.instrument.stop(noteNumber: 98, channel: 0)
                                conductor.instrument.stop(noteNumber: 99, channel: 0)
                                conductor.instrument.stop(noteNumber: 100, channel: 0)
                                conductor.instrument.stop(noteNumber: 101, channel: 0)
                                midiNote = 72
                                conductor.instrument.play(noteNumber: MIDINoteNumber(midiNote), velocity: UInt8(fader1global*100), channel: 0)
                            }
                        case -1.2 ..< -1.1:
                            if midiNote == 73 {
                                
                            } else {
                                conductor.instrument.stop(noteNumber: 70, channel: 0)
                                conductor.instrument.stop(noteNumber: 71, channel: 0)
                                conductor.instrument.stop(noteNumber: 72, channel: 0)
                                conductor.instrument.stop(noteNumber: 74, channel: 0)
                                conductor.instrument.stop(noteNumber: 75, channel: 0)
                                conductor.instrument.stop(noteNumber: 76, channel: 0)
                                conductor.instrument.stop(noteNumber: 77, channel: 0)
                                conductor.instrument.stop(noteNumber: 78, channel: 0)
                                conductor.instrument.stop(noteNumber: 79, channel: 0)
                                conductor.instrument.stop(noteNumber: 80, channel: 0)
                                conductor.instrument.stop(noteNumber: 81, channel: 0)
                                conductor.instrument.stop(noteNumber: 82, channel: 0)
                                conductor.instrument.stop(noteNumber: 83, channel: 0)
                                conductor.instrument.stop(noteNumber: 84, channel: 0)
                                conductor.instrument.stop(noteNumber: 85, channel: 0)
                                conductor.instrument.stop(noteNumber: 86, channel: 0)
                                conductor.instrument.stop(noteNumber: 87, channel: 0)
                                conductor.instrument.stop(noteNumber: 88, channel: 0)
                                conductor.instrument.stop(noteNumber: 89, channel: 0)
                                conductor.instrument.stop(noteNumber: 90, channel: 0)
                                conductor.instrument.stop(noteNumber: 91, channel: 0)
                                conductor.instrument.stop(noteNumber: 92, channel: 0)
                                conductor.instrument.stop(noteNumber: 93, channel: 0)
                                conductor.instrument.stop(noteNumber: 94, channel: 0)
                                conductor.instrument.stop(noteNumber: 95, channel: 0)
                                conductor.instrument.stop(noteNumber: 96, channel: 0)
                                conductor.instrument.stop(noteNumber: 97, channel: 0)
                                conductor.instrument.stop(noteNumber: 98, channel: 0)
                                conductor.instrument.stop(noteNumber: 99, channel: 0)
                                conductor.instrument.stop(noteNumber: 100, channel: 0)
                                conductor.instrument.stop(noteNumber: 101, channel: 0)
                                midiNote = 73
                                conductor.instrument.play(noteNumber: MIDINoteNumber(midiNote), velocity: UInt8(fader1global*100), channel: 0)
                            }
                        case -1.1 ..< -1.0:
                            if midiNote == 74 {
                                
                            } else {
                                conductor.instrument.stop(noteNumber: 70, channel: 0)
                                conductor.instrument.stop(noteNumber: 71, channel: 0)
                                conductor.instrument.stop(noteNumber: 72, channel: 0)
                                conductor.instrument.stop(noteNumber: 73, channel: 0)
                                conductor.instrument.stop(noteNumber: 75, channel: 0)
                                conductor.instrument.stop(noteNumber: 76, channel: 0)
                                conductor.instrument.stop(noteNumber: 77, channel: 0)
                                conductor.instrument.stop(noteNumber: 78, channel: 0)
                                conductor.instrument.stop(noteNumber: 79, channel: 0)
                                conductor.instrument.stop(noteNumber: 80, channel: 0)
                                conductor.instrument.stop(noteNumber: 81, channel: 0)
                                conductor.instrument.stop(noteNumber: 82, channel: 0)
                                conductor.instrument.stop(noteNumber: 83, channel: 0)
                                conductor.instrument.stop(noteNumber: 84, channel: 0)
                                conductor.instrument.stop(noteNumber: 85, channel: 0)
                                conductor.instrument.stop(noteNumber: 86, channel: 0)
                                conductor.instrument.stop(noteNumber: 87, channel: 0)
                                conductor.instrument.stop(noteNumber: 88, channel: 0)
                                conductor.instrument.stop(noteNumber: 89, channel: 0)
                                conductor.instrument.stop(noteNumber: 90, channel: 0)
                                conductor.instrument.stop(noteNumber: 91, channel: 0)
                                conductor.instrument.stop(noteNumber: 92, channel: 0)
                                conductor.instrument.stop(noteNumber: 93, channel: 0)
                                conductor.instrument.stop(noteNumber: 94, channel: 0)
                                conductor.instrument.stop(noteNumber: 95, channel: 0)
                                conductor.instrument.stop(noteNumber: 96, channel: 0)
                                conductor.instrument.stop(noteNumber: 97, channel: 0)
                                conductor.instrument.stop(noteNumber: 98, channel: 0)
                                conductor.instrument.stop(noteNumber: 99, channel: 0)
                                conductor.instrument.stop(noteNumber: 100, channel: 0)
                                conductor.instrument.stop(noteNumber: 101, channel: 0)
                                midiNote = 74
                                conductor.instrument.play(noteNumber: MIDINoteNumber(midiNote), velocity: UInt8(fader1global*100), channel: 0)
                            }
                        case -1.0 ..< -0.9:
                            if midiNote == 75 {
                                
                            } else {
                                conductor.instrument.stop(noteNumber: 70, channel: 0)
                                conductor.instrument.stop(noteNumber: 71, channel: 0)
                                conductor.instrument.stop(noteNumber: 72, channel: 0)
                                conductor.instrument.stop(noteNumber: 73, channel: 0)
                                conductor.instrument.stop(noteNumber: 74, channel: 0)
                                conductor.instrument.stop(noteNumber: 76, channel: 0)
                                conductor.instrument.stop(noteNumber: 77, channel: 0)
                                conductor.instrument.stop(noteNumber: 78, channel: 0)
                                conductor.instrument.stop(noteNumber: 79, channel: 0)
                                conductor.instrument.stop(noteNumber: 80, channel: 0)
                                conductor.instrument.stop(noteNumber: 81, channel: 0)
                                conductor.instrument.stop(noteNumber: 82, channel: 0)
                                conductor.instrument.stop(noteNumber: 83, channel: 0)
                                conductor.instrument.stop(noteNumber: 84, channel: 0)
                                conductor.instrument.stop(noteNumber: 85, channel: 0)
                                conductor.instrument.stop(noteNumber: 86, channel: 0)
                                conductor.instrument.stop(noteNumber: 87, channel: 0)
                                conductor.instrument.stop(noteNumber: 88, channel: 0)
                                conductor.instrument.stop(noteNumber: 89, channel: 0)
                                conductor.instrument.stop(noteNumber: 90, channel: 0)
                                conductor.instrument.stop(noteNumber: 91, channel: 0)
                                conductor.instrument.stop(noteNumber: 92, channel: 0)
                                conductor.instrument.stop(noteNumber: 93, channel: 0)
                                conductor.instrument.stop(noteNumber: 94, channel: 0)
                                conductor.instrument.stop(noteNumber: 95, channel: 0)
                                conductor.instrument.stop(noteNumber: 96, channel: 0)
                                conductor.instrument.stop(noteNumber: 97, channel: 0)
                                conductor.instrument.stop(noteNumber: 98, channel: 0)
                                conductor.instrument.stop(noteNumber: 99, channel: 0)
                                conductor.instrument.stop(noteNumber: 100, channel: 0)
                                conductor.instrument.stop(noteNumber: 101, channel: 0)
                                midiNote = 75
                                conductor.instrument.play(noteNumber: MIDINoteNumber(midiNote), velocity: UInt8(fader1global*100), channel: 0)
                            }
                        case -0.9 ..< -0.8:
                            if midiNote == 76 {
                                
                            } else {
                                conductor.instrument.stop(noteNumber: 70, channel: 0)
                                conductor.instrument.stop(noteNumber: 71, channel: 0)
                                conductor.instrument.stop(noteNumber: 72, channel: 0)
                                conductor.instrument.stop(noteNumber: 73, channel: 0)
                                conductor.instrument.stop(noteNumber: 74, channel: 0)
                                conductor.instrument.stop(noteNumber: 75, channel: 0)
                                conductor.instrument.stop(noteNumber: 77, channel: 0)
                                conductor.instrument.stop(noteNumber: 78, channel: 0)
                                conductor.instrument.stop(noteNumber: 79, channel: 0)
                                conductor.instrument.stop(noteNumber: 80, channel: 0)
                                conductor.instrument.stop(noteNumber: 81, channel: 0)
                                conductor.instrument.stop(noteNumber: 82, channel: 0)
                                conductor.instrument.stop(noteNumber: 83, channel: 0)
                                conductor.instrument.stop(noteNumber: 84, channel: 0)
                                conductor.instrument.stop(noteNumber: 85, channel: 0)
                                conductor.instrument.stop(noteNumber: 86, channel: 0)
                                conductor.instrument.stop(noteNumber: 87, channel: 0)
                                conductor.instrument.stop(noteNumber: 88, channel: 0)
                                conductor.instrument.stop(noteNumber: 89, channel: 0)
                                conductor.instrument.stop(noteNumber: 90, channel: 0)
                                conductor.instrument.stop(noteNumber: 91, channel: 0)
                                conductor.instrument.stop(noteNumber: 92, channel: 0)
                                conductor.instrument.stop(noteNumber: 93, channel: 0)
                                conductor.instrument.stop(noteNumber: 94, channel: 0)
                                conductor.instrument.stop(noteNumber: 95, channel: 0)
                                conductor.instrument.stop(noteNumber: 96, channel: 0)
                                conductor.instrument.stop(noteNumber: 97, channel: 0)
                                conductor.instrument.stop(noteNumber: 98, channel: 0)
                                conductor.instrument.stop(noteNumber: 99, channel: 0)
                                conductor.instrument.stop(noteNumber: 100, channel: 0)
                                conductor.instrument.stop(noteNumber: 101, channel: 0)
                                midiNote = 76
                                conductor.instrument.play(noteNumber: MIDINoteNumber(midiNote), velocity: UInt8(fader1global*100), channel: 0)
                            }
                        case -0.8 ..< -0.7:
                            if midiNote == 77 {
                                
                            } else {
                                conductor.instrument.stop(noteNumber: 70, channel: 0)
                                conductor.instrument.stop(noteNumber: 71, channel: 0)
                                conductor.instrument.stop(noteNumber: 72, channel: 0)
                                conductor.instrument.stop(noteNumber: 73, channel: 0)
                                conductor.instrument.stop(noteNumber: 74, channel: 0)
                                conductor.instrument.stop(noteNumber: 75, channel: 0)
                                conductor.instrument.stop(noteNumber: 76, channel: 0)
                                conductor.instrument.stop(noteNumber: 78, channel: 0)
                                conductor.instrument.stop(noteNumber: 79, channel: 0)
                                conductor.instrument.stop(noteNumber: 80, channel: 0)
                                conductor.instrument.stop(noteNumber: 81, channel: 0)
                                conductor.instrument.stop(noteNumber: 82, channel: 0)
                                conductor.instrument.stop(noteNumber: 83, channel: 0)
                                conductor.instrument.stop(noteNumber: 84, channel: 0)
                                conductor.instrument.stop(noteNumber: 85, channel: 0)
                                conductor.instrument.stop(noteNumber: 86, channel: 0)
                                conductor.instrument.stop(noteNumber: 87, channel: 0)
                                conductor.instrument.stop(noteNumber: 88, channel: 0)
                                conductor.instrument.stop(noteNumber: 89, channel: 0)
                                conductor.instrument.stop(noteNumber: 90, channel: 0)
                                conductor.instrument.stop(noteNumber: 91, channel: 0)
                                conductor.instrument.stop(noteNumber: 92, channel: 0)
                                conductor.instrument.stop(noteNumber: 93, channel: 0)
                                conductor.instrument.stop(noteNumber: 94, channel: 0)
                                conductor.instrument.stop(noteNumber: 95, channel: 0)
                                conductor.instrument.stop(noteNumber: 96, channel: 0)
                                conductor.instrument.stop(noteNumber: 97, channel: 0)
                                conductor.instrument.stop(noteNumber: 98, channel: 0)
                                conductor.instrument.stop(noteNumber: 99, channel: 0)
                                conductor.instrument.stop(noteNumber: 100, channel: 0)
                                conductor.instrument.stop(noteNumber: 101, channel: 0)
                                midiNote = 77
                                conductor.instrument.play(noteNumber: MIDINoteNumber(midiNote), velocity: UInt8(fader1global*100), channel: 0)
                            }
                        case -0.7 ..< -0.6:
                            if midiNote == 78 {
                                
                            } else {
                                conductor.instrument.stop(noteNumber: 70, channel: 0)
                                conductor.instrument.stop(noteNumber: 71, channel: 0)
                                conductor.instrument.stop(noteNumber: 72, channel: 0)
                                conductor.instrument.stop(noteNumber: 73, channel: 0)
                                conductor.instrument.stop(noteNumber: 74, channel: 0)
                                conductor.instrument.stop(noteNumber: 75, channel: 0)
                                conductor.instrument.stop(noteNumber: 76, channel: 0)
                                conductor.instrument.stop(noteNumber: 77, channel: 0)
                                conductor.instrument.stop(noteNumber: 79, channel: 0)
                                conductor.instrument.stop(noteNumber: 80, channel: 0)
                                conductor.instrument.stop(noteNumber: 81, channel: 0)
                                conductor.instrument.stop(noteNumber: 82, channel: 0)
                                conductor.instrument.stop(noteNumber: 83, channel: 0)
                                conductor.instrument.stop(noteNumber: 84, channel: 0)
                                conductor.instrument.stop(noteNumber: 85, channel: 0)
                                conductor.instrument.stop(noteNumber: 86, channel: 0)
                                conductor.instrument.stop(noteNumber: 87, channel: 0)
                                conductor.instrument.stop(noteNumber: 88, channel: 0)
                                conductor.instrument.stop(noteNumber: 89, channel: 0)
                                conductor.instrument.stop(noteNumber: 90, channel: 0)
                                conductor.instrument.stop(noteNumber: 91, channel: 0)
                                conductor.instrument.stop(noteNumber: 92, channel: 0)
                                conductor.instrument.stop(noteNumber: 93, channel: 0)
                                conductor.instrument.stop(noteNumber: 94, channel: 0)
                                conductor.instrument.stop(noteNumber: 95, channel: 0)
                                conductor.instrument.stop(noteNumber: 96, channel: 0)
                                conductor.instrument.stop(noteNumber: 97, channel: 0)
                                conductor.instrument.stop(noteNumber: 98, channel: 0)
                                conductor.instrument.stop(noteNumber: 99, channel: 0)
                                conductor.instrument.stop(noteNumber: 100, channel: 0)
                                conductor.instrument.stop(noteNumber: 101, channel: 0)
                                midiNote = 78
                                conductor.instrument.play(noteNumber: MIDINoteNumber(midiNote), velocity: UInt8(fader1global*100), channel: 0)
                            }
                        case -0.6 ..< -0.5:
                            if midiNote == 79 {
                                
                            } else {
                                conductor.instrument.stop(noteNumber: 70, channel: 0)
                                conductor.instrument.stop(noteNumber: 71, channel: 0)
                                conductor.instrument.stop(noteNumber: 72, channel: 0)
                                conductor.instrument.stop(noteNumber: 73, channel: 0)
                                conductor.instrument.stop(noteNumber: 74, channel: 0)
                                conductor.instrument.stop(noteNumber: 75, channel: 0)
                                conductor.instrument.stop(noteNumber: 76, channel: 0)
                                conductor.instrument.stop(noteNumber: 77, channel: 0)
                                conductor.instrument.stop(noteNumber: 78, channel: 0)
                                conductor.instrument.stop(noteNumber: 80, channel: 0)
                                conductor.instrument.stop(noteNumber: 81, channel: 0)
                                conductor.instrument.stop(noteNumber: 82, channel: 0)
                                conductor.instrument.stop(noteNumber: 83, channel: 0)
                                conductor.instrument.stop(noteNumber: 84, channel: 0)
                                conductor.instrument.stop(noteNumber: 85, channel: 0)
                                conductor.instrument.stop(noteNumber: 86, channel: 0)
                                conductor.instrument.stop(noteNumber: 87, channel: 0)
                                conductor.instrument.stop(noteNumber: 88, channel: 0)
                                conductor.instrument.stop(noteNumber: 89, channel: 0)
                                conductor.instrument.stop(noteNumber: 90, channel: 0)
                                conductor.instrument.stop(noteNumber: 91, channel: 0)
                                conductor.instrument.stop(noteNumber: 92, channel: 0)
                                conductor.instrument.stop(noteNumber: 93, channel: 0)
                                conductor.instrument.stop(noteNumber: 94, channel: 0)
                                conductor.instrument.stop(noteNumber: 95, channel: 0)
                                conductor.instrument.stop(noteNumber: 96, channel: 0)
                                conductor.instrument.stop(noteNumber: 97, channel: 0)
                                conductor.instrument.stop(noteNumber: 98, channel: 0)
                                conductor.instrument.stop(noteNumber: 99, channel: 0)
                                conductor.instrument.stop(noteNumber: 100, channel: 0)
                                conductor.instrument.stop(noteNumber: 101, channel: 0)
                                midiNote = 79
                                conductor.instrument.play(noteNumber: MIDINoteNumber(midiNote), velocity: UInt8(fader1global*100), channel: 0)
                            }
                        case -0.5 ..< -0.4:
                            if midiNote == 80 {
                                
                            } else {
                                conductor.instrument.stop(noteNumber: 70, channel: 0)
                                conductor.instrument.stop(noteNumber: 71, channel: 0)
                                conductor.instrument.stop(noteNumber: 72, channel: 0)
                                conductor.instrument.stop(noteNumber: 73, channel: 0)
                                conductor.instrument.stop(noteNumber: 74, channel: 0)
                                conductor.instrument.stop(noteNumber: 75, channel: 0)
                                conductor.instrument.stop(noteNumber: 76, channel: 0)
                                conductor.instrument.stop(noteNumber: 77, channel: 0)
                                conductor.instrument.stop(noteNumber: 78, channel: 0)
                                conductor.instrument.stop(noteNumber: 79, channel: 0)
                                conductor.instrument.stop(noteNumber: 81, channel: 0)
                                conductor.instrument.stop(noteNumber: 82, channel: 0)
                                conductor.instrument.stop(noteNumber: 83, channel: 0)
                                conductor.instrument.stop(noteNumber: 84, channel: 0)
                                conductor.instrument.stop(noteNumber: 85, channel: 0)
                                conductor.instrument.stop(noteNumber: 86, channel: 0)
                                conductor.instrument.stop(noteNumber: 87, channel: 0)
                                conductor.instrument.stop(noteNumber: 88, channel: 0)
                                conductor.instrument.stop(noteNumber: 89, channel: 0)
                                conductor.instrument.stop(noteNumber: 90, channel: 0)
                                conductor.instrument.stop(noteNumber: 91, channel: 0)
                                conductor.instrument.stop(noteNumber: 92, channel: 0)
                                conductor.instrument.stop(noteNumber: 93, channel: 0)
                                conductor.instrument.stop(noteNumber: 94, channel: 0)
                                conductor.instrument.stop(noteNumber: 95, channel: 0)
                                conductor.instrument.stop(noteNumber: 96, channel: 0)
                                conductor.instrument.stop(noteNumber: 97, channel: 0)
                                conductor.instrument.stop(noteNumber: 98, channel: 0)
                                conductor.instrument.stop(noteNumber: 99, channel: 0)
                                conductor.instrument.stop(noteNumber: 100, channel: 0)
                                conductor.instrument.stop(noteNumber: 101, channel: 0)
                                midiNote = 80
                                conductor.instrument.play(noteNumber: MIDINoteNumber(midiNote), velocity: UInt8(fader1global*100), channel: 0)
                            }
                        case -0.4 ..< -0.3:
                            if midiNote == 81 {
                                
                            } else {
                                conductor.instrument.stop(noteNumber: 70, channel: 0)
                                conductor.instrument.stop(noteNumber: 71, channel: 0)
                                conductor.instrument.stop(noteNumber: 72, channel: 0)
                                conductor.instrument.stop(noteNumber: 73, channel: 0)
                                conductor.instrument.stop(noteNumber: 74, channel: 0)
                                conductor.instrument.stop(noteNumber: 75, channel: 0)
                                conductor.instrument.stop(noteNumber: 76, channel: 0)
                                conductor.instrument.stop(noteNumber: 77, channel: 0)
                                conductor.instrument.stop(noteNumber: 78, channel: 0)
                                conductor.instrument.stop(noteNumber: 79, channel: 0)
                                conductor.instrument.stop(noteNumber: 80, channel: 0)
                                conductor.instrument.stop(noteNumber: 82, channel: 0)
                                conductor.instrument.stop(noteNumber: 83, channel: 0)
                                conductor.instrument.stop(noteNumber: 84, channel: 0)
                                conductor.instrument.stop(noteNumber: 85, channel: 0)
                                conductor.instrument.stop(noteNumber: 86, channel: 0)
                                conductor.instrument.stop(noteNumber: 87, channel: 0)
                                conductor.instrument.stop(noteNumber: 88, channel: 0)
                                conductor.instrument.stop(noteNumber: 89, channel: 0)
                                conductor.instrument.stop(noteNumber: 90, channel: 0)
                                conductor.instrument.stop(noteNumber: 91, channel: 0)
                                conductor.instrument.stop(noteNumber: 92, channel: 0)
                                conductor.instrument.stop(noteNumber: 93, channel: 0)
                                conductor.instrument.stop(noteNumber: 94, channel: 0)
                                conductor.instrument.stop(noteNumber: 95, channel: 0)
                                conductor.instrument.stop(noteNumber: 96, channel: 0)
                                conductor.instrument.stop(noteNumber: 97, channel: 0)
                                conductor.instrument.stop(noteNumber: 98, channel: 0)
                                conductor.instrument.stop(noteNumber: 99, channel: 0)
                                conductor.instrument.stop(noteNumber: 100, channel: 0)
                                conductor.instrument.stop(noteNumber: 101, channel: 0)
                                midiNote = 81
                                conductor.instrument.play(noteNumber: MIDINoteNumber(midiNote), velocity: UInt8(fader1global*100), channel: 0)
                            }
                        case -0.3 ..< -0.2:
                            if midiNote == 82 {
                                
                            } else {
                                conductor.instrument.stop(noteNumber: 70, channel: 0)
                                conductor.instrument.stop(noteNumber: 71, channel: 0)
                                conductor.instrument.stop(noteNumber: 72, channel: 0)
                                conductor.instrument.stop(noteNumber: 73, channel: 0)
                                conductor.instrument.stop(noteNumber: 74, channel: 0)
                                conductor.instrument.stop(noteNumber: 75, channel: 0)
                                conductor.instrument.stop(noteNumber: 76, channel: 0)
                                conductor.instrument.stop(noteNumber: 77, channel: 0)
                                conductor.instrument.stop(noteNumber: 78, channel: 0)
                                conductor.instrument.stop(noteNumber: 79, channel: 0)
                                conductor.instrument.stop(noteNumber: 80, channel: 0)
                                conductor.instrument.stop(noteNumber: 81, channel: 0)
                                conductor.instrument.stop(noteNumber: 83, channel: 0)
                                conductor.instrument.stop(noteNumber: 84, channel: 0)
                                conductor.instrument.stop(noteNumber: 85, channel: 0)
                                conductor.instrument.stop(noteNumber: 86, channel: 0)
                                conductor.instrument.stop(noteNumber: 87, channel: 0)
                                conductor.instrument.stop(noteNumber: 88, channel: 0)
                                conductor.instrument.stop(noteNumber: 89, channel: 0)
                                conductor.instrument.stop(noteNumber: 90, channel: 0)
                                conductor.instrument.stop(noteNumber: 91, channel: 0)
                                conductor.instrument.stop(noteNumber: 92, channel: 0)
                                conductor.instrument.stop(noteNumber: 93, channel: 0)
                                conductor.instrument.stop(noteNumber: 94, channel: 0)
                                conductor.instrument.stop(noteNumber: 95, channel: 0)
                                conductor.instrument.stop(noteNumber: 96, channel: 0)
                                conductor.instrument.stop(noteNumber: 97, channel: 0)
                                conductor.instrument.stop(noteNumber: 98, channel: 0)
                                conductor.instrument.stop(noteNumber: 99, channel: 0)
                                conductor.instrument.stop(noteNumber: 100, channel: 0)
                                conductor.instrument.stop(noteNumber: 101, channel: 0)
                                midiNote = 82
                                conductor.instrument.play(noteNumber: MIDINoteNumber(midiNote), velocity: UInt8(fader1global*100), channel: 0)
                            }
                        case -0.2 ..< -0.1:
                            if midiNote == 83 {
                                
                            } else {
                                conductor.instrument.stop(noteNumber: 70, channel: 0)
                                conductor.instrument.stop(noteNumber: 71, channel: 0)
                                conductor.instrument.stop(noteNumber: 72, channel: 0)
                                conductor.instrument.stop(noteNumber: 73, channel: 0)
                                conductor.instrument.stop(noteNumber: 74, channel: 0)
                                conductor.instrument.stop(noteNumber: 75, channel: 0)
                                conductor.instrument.stop(noteNumber: 76, channel: 0)
                                conductor.instrument.stop(noteNumber: 77, channel: 0)
                                conductor.instrument.stop(noteNumber: 78, channel: 0)
                                conductor.instrument.stop(noteNumber: 79, channel: 0)
                                conductor.instrument.stop(noteNumber: 80, channel: 0)
                                conductor.instrument.stop(noteNumber: 81, channel: 0)
                                conductor.instrument.stop(noteNumber: 82, channel: 0)
                                conductor.instrument.stop(noteNumber: 84, channel: 0)
                                conductor.instrument.stop(noteNumber: 85, channel: 0)
                                conductor.instrument.stop(noteNumber: 86, channel: 0)
                                conductor.instrument.stop(noteNumber: 87, channel: 0)
                                conductor.instrument.stop(noteNumber: 88, channel: 0)
                                conductor.instrument.stop(noteNumber: 89, channel: 0)
                                conductor.instrument.stop(noteNumber: 90, channel: 0)
                                conductor.instrument.stop(noteNumber: 91, channel: 0)
                                conductor.instrument.stop(noteNumber: 92, channel: 0)
                                conductor.instrument.stop(noteNumber: 93, channel: 0)
                                conductor.instrument.stop(noteNumber: 94, channel: 0)
                                conductor.instrument.stop(noteNumber: 95, channel: 0)
                                conductor.instrument.stop(noteNumber: 96, channel: 0)
                                conductor.instrument.stop(noteNumber: 97, channel: 0)
                                conductor.instrument.stop(noteNumber: 98, channel: 0)
                                conductor.instrument.stop(noteNumber: 99, channel: 0)
                                conductor.instrument.stop(noteNumber: 100, channel: 0)
                                conductor.instrument.stop(noteNumber: 101, channel: 0)
                                midiNote = 83
                                conductor.instrument.play(noteNumber: MIDINoteNumber(midiNote), velocity: UInt8(fader1global*100), channel: 0)
                            }
                        case -0.1 ..< 0.0:
                            if midiNote == 84 {
                                
                            } else {
                                conductor.instrument.stop(noteNumber: 70, channel: 0)
                                conductor.instrument.stop(noteNumber: 71, channel: 0)
                                conductor.instrument.stop(noteNumber: 72, channel: 0)
                                conductor.instrument.stop(noteNumber: 73, channel: 0)
                                conductor.instrument.stop(noteNumber: 74, channel: 0)
                                conductor.instrument.stop(noteNumber: 75, channel: 0)
                                conductor.instrument.stop(noteNumber: 76, channel: 0)
                                conductor.instrument.stop(noteNumber: 77, channel: 0)
                                conductor.instrument.stop(noteNumber: 78, channel: 0)
                                conductor.instrument.stop(noteNumber: 79, channel: 0)
                                conductor.instrument.stop(noteNumber: 80, channel: 0)
                                conductor.instrument.stop(noteNumber: 81, channel: 0)
                                conductor.instrument.stop(noteNumber: 82, channel: 0)
                                conductor.instrument.stop(noteNumber: 83, channel: 0)
                                conductor.instrument.stop(noteNumber: 85, channel: 0)
                                conductor.instrument.stop(noteNumber: 86, channel: 0)
                                conductor.instrument.stop(noteNumber: 87, channel: 0)
                                conductor.instrument.stop(noteNumber: 88, channel: 0)
                                conductor.instrument.stop(noteNumber: 89, channel: 0)
                                conductor.instrument.stop(noteNumber: 90, channel: 0)
                                conductor.instrument.stop(noteNumber: 91, channel: 0)
                                conductor.instrument.stop(noteNumber: 92, channel: 0)
                                conductor.instrument.stop(noteNumber: 93, channel: 0)
                                conductor.instrument.stop(noteNumber: 94, channel: 0)
                                conductor.instrument.stop(noteNumber: 95, channel: 0)
                                conductor.instrument.stop(noteNumber: 96, channel: 0)
                                conductor.instrument.stop(noteNumber: 97, channel: 0)
                                conductor.instrument.stop(noteNumber: 98, channel: 0)
                                conductor.instrument.stop(noteNumber: 99, channel: 0)
                                conductor.instrument.stop(noteNumber: 100, channel: 0)
                                conductor.instrument.stop(noteNumber: 101, channel: 0)
                                midiNote = 84
                                conductor.instrument.play(noteNumber: MIDINoteNumber(midiNote), velocity: UInt8(fader1global*100), channel: 0)
                            }
                        case 0.0 ..< 0.1:
                            if midiNote == 85 {
                                
                            } else {
                                conductor.instrument.stop(noteNumber: 70, channel: 0)
                                conductor.instrument.stop(noteNumber: 71, channel: 0)
                                conductor.instrument.stop(noteNumber: 72, channel: 0)
                                conductor.instrument.stop(noteNumber: 73, channel: 0)
                                conductor.instrument.stop(noteNumber: 74, channel: 0)
                                conductor.instrument.stop(noteNumber: 75, channel: 0)
                                conductor.instrument.stop(noteNumber: 76, channel: 0)
                                conductor.instrument.stop(noteNumber: 77, channel: 0)
                                conductor.instrument.stop(noteNumber: 78, channel: 0)
                                conductor.instrument.stop(noteNumber: 79, channel: 0)
                                conductor.instrument.stop(noteNumber: 80, channel: 0)
                                conductor.instrument.stop(noteNumber: 81, channel: 0)
                                conductor.instrument.stop(noteNumber: 82, channel: 0)
                                conductor.instrument.stop(noteNumber: 83, channel: 0)
                                conductor.instrument.stop(noteNumber: 84, channel: 0)
                                conductor.instrument.stop(noteNumber: 86, channel: 0)
                                conductor.instrument.stop(noteNumber: 87, channel: 0)
                                conductor.instrument.stop(noteNumber: 88, channel: 0)
                                conductor.instrument.stop(noteNumber: 89, channel: 0)
                                conductor.instrument.stop(noteNumber: 90, channel: 0)
                                conductor.instrument.stop(noteNumber: 91, channel: 0)
                                conductor.instrument.stop(noteNumber: 92, channel: 0)
                                conductor.instrument.stop(noteNumber: 93, channel: 0)
                                conductor.instrument.stop(noteNumber: 94, channel: 0)
                                conductor.instrument.stop(noteNumber: 95, channel: 0)
                                conductor.instrument.stop(noteNumber: 96, channel: 0)
                                conductor.instrument.stop(noteNumber: 97, channel: 0)
                                conductor.instrument.stop(noteNumber: 98, channel: 0)
                                conductor.instrument.stop(noteNumber: 99, channel: 0)
                                conductor.instrument.stop(noteNumber: 100, channel: 0)
                                conductor.instrument.stop(noteNumber: 101, channel: 0)
                                midiNote = 85
                                conductor.instrument.play(noteNumber: MIDINoteNumber(midiNote), velocity: UInt8(fader1global*100), channel: 0)
                            }
                        case 0.1 ..< 0.2:
                            if midiNote == 86 {
                                
                            } else {
                                conductor.instrument.stop(noteNumber: 70, channel: 0)
                                conductor.instrument.stop(noteNumber: 71, channel: 0)
                                conductor.instrument.stop(noteNumber: 72, channel: 0)
                                conductor.instrument.stop(noteNumber: 73, channel: 0)
                                conductor.instrument.stop(noteNumber: 74, channel: 0)
                                conductor.instrument.stop(noteNumber: 75, channel: 0)
                                conductor.instrument.stop(noteNumber: 76, channel: 0)
                                conductor.instrument.stop(noteNumber: 77, channel: 0)
                                conductor.instrument.stop(noteNumber: 78, channel: 0)
                                conductor.instrument.stop(noteNumber: 79, channel: 0)
                                conductor.instrument.stop(noteNumber: 80, channel: 0)
                                conductor.instrument.stop(noteNumber: 81, channel: 0)
                                conductor.instrument.stop(noteNumber: 82, channel: 0)
                                conductor.instrument.stop(noteNumber: 83, channel: 0)
                                conductor.instrument.stop(noteNumber: 84, channel: 0)
                                conductor.instrument.stop(noteNumber: 85, channel: 0)
                                conductor.instrument.stop(noteNumber: 87, channel: 0)
                                conductor.instrument.stop(noteNumber: 88, channel: 0)
                                conductor.instrument.stop(noteNumber: 89, channel: 0)
                                conductor.instrument.stop(noteNumber: 90, channel: 0)
                                conductor.instrument.stop(noteNumber: 91, channel: 0)
                                conductor.instrument.stop(noteNumber: 92, channel: 0)
                                conductor.instrument.stop(noteNumber: 93, channel: 0)
                                conductor.instrument.stop(noteNumber: 94, channel: 0)
                                conductor.instrument.stop(noteNumber: 95, channel: 0)
                                conductor.instrument.stop(noteNumber: 96, channel: 0)
                                conductor.instrument.stop(noteNumber: 97, channel: 0)
                                conductor.instrument.stop(noteNumber: 98, channel: 0)
                                conductor.instrument.stop(noteNumber: 99, channel: 0)
                                conductor.instrument.stop(noteNumber: 100, channel: 0)
                                conductor.instrument.stop(noteNumber: 101, channel: 0)
                                midiNote = 86
                                conductor.instrument.play(noteNumber: MIDINoteNumber(midiNote), velocity: UInt8(fader1global*100), channel: 0)
                            }
                        case 0.2 ..< 0.3:
                            if midiNote == 87 {
                                
                            } else {
                                conductor.instrument.stop(noteNumber: 70, channel: 0)
                                conductor.instrument.stop(noteNumber: 71, channel: 0)
                                conductor.instrument.stop(noteNumber: 72, channel: 0)
                                conductor.instrument.stop(noteNumber: 73, channel: 0)
                                conductor.instrument.stop(noteNumber: 74, channel: 0)
                                conductor.instrument.stop(noteNumber: 75, channel: 0)
                                conductor.instrument.stop(noteNumber: 76, channel: 0)
                                conductor.instrument.stop(noteNumber: 77, channel: 0)
                                conductor.instrument.stop(noteNumber: 78, channel: 0)
                                conductor.instrument.stop(noteNumber: 79, channel: 0)
                                conductor.instrument.stop(noteNumber: 80, channel: 0)
                                conductor.instrument.stop(noteNumber: 81, channel: 0)
                                conductor.instrument.stop(noteNumber: 82, channel: 0)
                                conductor.instrument.stop(noteNumber: 83, channel: 0)
                                conductor.instrument.stop(noteNumber: 84, channel: 0)
                                conductor.instrument.stop(noteNumber: 85, channel: 0)
                                conductor.instrument.stop(noteNumber: 86, channel: 0)
                                conductor.instrument.stop(noteNumber: 88, channel: 0)
                                conductor.instrument.stop(noteNumber: 89, channel: 0)
                                conductor.instrument.stop(noteNumber: 90, channel: 0)
                                conductor.instrument.stop(noteNumber: 91, channel: 0)
                                conductor.instrument.stop(noteNumber: 92, channel: 0)
                                conductor.instrument.stop(noteNumber: 93, channel: 0)
                                conductor.instrument.stop(noteNumber: 94, channel: 0)
                                conductor.instrument.stop(noteNumber: 95, channel: 0)
                                conductor.instrument.stop(noteNumber: 96, channel: 0)
                                conductor.instrument.stop(noteNumber: 97, channel: 0)
                                conductor.instrument.stop(noteNumber: 98, channel: 0)
                                conductor.instrument.stop(noteNumber: 99, channel: 0)
                                conductor.instrument.stop(noteNumber: 100, channel: 0)
                                conductor.instrument.stop(noteNumber: 101, channel: 0)
                                midiNote = 87
                                conductor.instrument.play(noteNumber: MIDINoteNumber(midiNote), velocity: UInt8(fader1global*100), channel: 0)
                            }
                        case 0.3 ..< 0.4:
                            if midiNote == 88 {
                                
                            } else {
                                conductor.instrument.stop(noteNumber: 70, channel: 0)
                                conductor.instrument.stop(noteNumber: 71, channel: 0)
                                conductor.instrument.stop(noteNumber: 72, channel: 0)
                                conductor.instrument.stop(noteNumber: 73, channel: 0)
                                conductor.instrument.stop(noteNumber: 74, channel: 0)
                                conductor.instrument.stop(noteNumber: 75, channel: 0)
                                conductor.instrument.stop(noteNumber: 76, channel: 0)
                                conductor.instrument.stop(noteNumber: 77, channel: 0)
                                conductor.instrument.stop(noteNumber: 78, channel: 0)
                                conductor.instrument.stop(noteNumber: 79, channel: 0)
                                conductor.instrument.stop(noteNumber: 80, channel: 0)
                                conductor.instrument.stop(noteNumber: 81, channel: 0)
                                conductor.instrument.stop(noteNumber: 82, channel: 0)
                                conductor.instrument.stop(noteNumber: 83, channel: 0)
                                conductor.instrument.stop(noteNumber: 84, channel: 0)
                                conductor.instrument.stop(noteNumber: 85, channel: 0)
                                conductor.instrument.stop(noteNumber: 86, channel: 0)
                                conductor.instrument.stop(noteNumber: 87, channel: 0)
                                conductor.instrument.stop(noteNumber: 89, channel: 0)
                                conductor.instrument.stop(noteNumber: 90, channel: 0)
                                conductor.instrument.stop(noteNumber: 91, channel: 0)
                                conductor.instrument.stop(noteNumber: 92, channel: 0)
                                conductor.instrument.stop(noteNumber: 93, channel: 0)
                                conductor.instrument.stop(noteNumber: 94, channel: 0)
                                conductor.instrument.stop(noteNumber: 95, channel: 0)
                                conductor.instrument.stop(noteNumber: 96, channel: 0)
                                conductor.instrument.stop(noteNumber: 97, channel: 0)
                                conductor.instrument.stop(noteNumber: 98, channel: 0)
                                conductor.instrument.stop(noteNumber: 99, channel: 0)
                                conductor.instrument.stop(noteNumber: 100, channel: 0)
                                conductor.instrument.stop(noteNumber: 101, channel: 0)
                                midiNote = 88
                                conductor.instrument.play(noteNumber: MIDINoteNumber(midiNote), velocity: UInt8(fader1global*100), channel: 0)
                            }
                        case 0.4 ..< 0.5:
                            if midiNote == 89 {
                                
                            } else {
                                conductor.instrument.stop(noteNumber: 70, channel: 0)
                                conductor.instrument.stop(noteNumber: 71, channel: 0)
                                conductor.instrument.stop(noteNumber: 72, channel: 0)
                                conductor.instrument.stop(noteNumber: 73, channel: 0)
                                conductor.instrument.stop(noteNumber: 74, channel: 0)
                                conductor.instrument.stop(noteNumber: 75, channel: 0)
                                conductor.instrument.stop(noteNumber: 76, channel: 0)
                                conductor.instrument.stop(noteNumber: 77, channel: 0)
                                conductor.instrument.stop(noteNumber: 78, channel: 0)
                                conductor.instrument.stop(noteNumber: 79, channel: 0)
                                conductor.instrument.stop(noteNumber: 80, channel: 0)
                                conductor.instrument.stop(noteNumber: 81, channel: 0)
                                conductor.instrument.stop(noteNumber: 82, channel: 0)
                                conductor.instrument.stop(noteNumber: 83, channel: 0)
                                conductor.instrument.stop(noteNumber: 84, channel: 0)
                                conductor.instrument.stop(noteNumber: 85, channel: 0)
                                conductor.instrument.stop(noteNumber: 86, channel: 0)
                                conductor.instrument.stop(noteNumber: 87, channel: 0)
                                conductor.instrument.stop(noteNumber: 88, channel: 0)
                                conductor.instrument.stop(noteNumber: 90, channel: 0)
                                conductor.instrument.stop(noteNumber: 91, channel: 0)
                                conductor.instrument.stop(noteNumber: 92, channel: 0)
                                conductor.instrument.stop(noteNumber: 93, channel: 0)
                                conductor.instrument.stop(noteNumber: 94, channel: 0)
                                conductor.instrument.stop(noteNumber: 95, channel: 0)
                                conductor.instrument.stop(noteNumber: 96, channel: 0)
                                conductor.instrument.stop(noteNumber: 97, channel: 0)
                                conductor.instrument.stop(noteNumber: 98, channel: 0)
                                conductor.instrument.stop(noteNumber: 99, channel: 0)
                                conductor.instrument.stop(noteNumber: 100, channel: 0)
                                conductor.instrument.stop(noteNumber: 101, channel: 0)
                                midiNote = 89
                                conductor.instrument.play(noteNumber: MIDINoteNumber(midiNote), velocity: UInt8(fader1global*100), channel: 0)
                            }
                        case 0.5 ..< 0.6:
                            if midiNote == 90 {
                                
                            } else {
                                conductor.instrument.stop(noteNumber: 70, channel: 0)
                                conductor.instrument.stop(noteNumber: 71, channel: 0)
                                conductor.instrument.stop(noteNumber: 72, channel: 0)
                                conductor.instrument.stop(noteNumber: 73, channel: 0)
                                conductor.instrument.stop(noteNumber: 74, channel: 0)
                                conductor.instrument.stop(noteNumber: 75, channel: 0)
                                conductor.instrument.stop(noteNumber: 76, channel: 0)
                                conductor.instrument.stop(noteNumber: 77, channel: 0)
                                conductor.instrument.stop(noteNumber: 78, channel: 0)
                                conductor.instrument.stop(noteNumber: 79, channel: 0)
                                conductor.instrument.stop(noteNumber: 80, channel: 0)
                                conductor.instrument.stop(noteNumber: 81, channel: 0)
                                conductor.instrument.stop(noteNumber: 82, channel: 0)
                                conductor.instrument.stop(noteNumber: 83, channel: 0)
                                conductor.instrument.stop(noteNumber: 84, channel: 0)
                                conductor.instrument.stop(noteNumber: 85, channel: 0)
                                conductor.instrument.stop(noteNumber: 86, channel: 0)
                                conductor.instrument.stop(noteNumber: 87, channel: 0)
                                conductor.instrument.stop(noteNumber: 88, channel: 0)
                                conductor.instrument.stop(noteNumber: 89, channel: 0)
                                conductor.instrument.stop(noteNumber: 91, channel: 0)
                                conductor.instrument.stop(noteNumber: 92, channel: 0)
                                conductor.instrument.stop(noteNumber: 93, channel: 0)
                                conductor.instrument.stop(noteNumber: 94, channel: 0)
                                conductor.instrument.stop(noteNumber: 95, channel: 0)
                                conductor.instrument.stop(noteNumber: 96, channel: 0)
                                conductor.instrument.stop(noteNumber: 97, channel: 0)
                                conductor.instrument.stop(noteNumber: 98, channel: 0)
                                conductor.instrument.stop(noteNumber: 99, channel: 0)
                                conductor.instrument.stop(noteNumber: 100, channel: 0)
                                conductor.instrument.stop(noteNumber: 101, channel: 0)
                                midiNote = 90
                                conductor.instrument.play(noteNumber: MIDINoteNumber(midiNote), velocity: UInt8(fader1global*100), channel: 0)
                            }
                        case 0.6 ..< 0.7:
                            if midiNote == 91 {
                                
                            } else {
                                conductor.instrument.stop(noteNumber: 70, channel: 0)
                                conductor.instrument.stop(noteNumber: 71, channel: 0)
                                conductor.instrument.stop(noteNumber: 72, channel: 0)
                                conductor.instrument.stop(noteNumber: 73, channel: 0)
                                conductor.instrument.stop(noteNumber: 74, channel: 0)
                                conductor.instrument.stop(noteNumber: 75, channel: 0)
                                conductor.instrument.stop(noteNumber: 76, channel: 0)
                                conductor.instrument.stop(noteNumber: 77, channel: 0)
                                conductor.instrument.stop(noteNumber: 78, channel: 0)
                                conductor.instrument.stop(noteNumber: 79, channel: 0)
                                conductor.instrument.stop(noteNumber: 80, channel: 0)
                                conductor.instrument.stop(noteNumber: 81, channel: 0)
                                conductor.instrument.stop(noteNumber: 82, channel: 0)
                                conductor.instrument.stop(noteNumber: 83, channel: 0)
                                conductor.instrument.stop(noteNumber: 84, channel: 0)
                                conductor.instrument.stop(noteNumber: 85, channel: 0)
                                conductor.instrument.stop(noteNumber: 86, channel: 0)
                                conductor.instrument.stop(noteNumber: 87, channel: 0)
                                conductor.instrument.stop(noteNumber: 88, channel: 0)
                                conductor.instrument.stop(noteNumber: 89, channel: 0)
                                conductor.instrument.stop(noteNumber: 90, channel: 0)
                                conductor.instrument.stop(noteNumber: 92, channel: 0)
                                conductor.instrument.stop(noteNumber: 93, channel: 0)
                                conductor.instrument.stop(noteNumber: 94, channel: 0)
                                conductor.instrument.stop(noteNumber: 95, channel: 0)
                                conductor.instrument.stop(noteNumber: 96, channel: 0)
                                conductor.instrument.stop(noteNumber: 97, channel: 0)
                                conductor.instrument.stop(noteNumber: 98, channel: 0)
                                conductor.instrument.stop(noteNumber: 99, channel: 0)
                                conductor.instrument.stop(noteNumber: 100, channel: 0)
                                conductor.instrument.stop(noteNumber: 101, channel: 0)
                                midiNote = 91
                                conductor.instrument.play(noteNumber: MIDINoteNumber(midiNote), velocity: UInt8(fader1global*100), channel: 0)
                            }
                        case 0.7 ..< 0.8:
                            if midiNote == 92 {
                                
                            } else {
                                conductor.instrument.stop(noteNumber: 70, channel: 0)
                                conductor.instrument.stop(noteNumber: 71, channel: 0)
                                conductor.instrument.stop(noteNumber: 72, channel: 0)
                                conductor.instrument.stop(noteNumber: 73, channel: 0)
                                conductor.instrument.stop(noteNumber: 74, channel: 0)
                                conductor.instrument.stop(noteNumber: 75, channel: 0)
                                conductor.instrument.stop(noteNumber: 76, channel: 0)
                                conductor.instrument.stop(noteNumber: 77, channel: 0)
                                conductor.instrument.stop(noteNumber: 78, channel: 0)
                                conductor.instrument.stop(noteNumber: 79, channel: 0)
                                conductor.instrument.stop(noteNumber: 80, channel: 0)
                                conductor.instrument.stop(noteNumber: 81, channel: 0)
                                conductor.instrument.stop(noteNumber: 82, channel: 0)
                                conductor.instrument.stop(noteNumber: 83, channel: 0)
                                conductor.instrument.stop(noteNumber: 84, channel: 0)
                                conductor.instrument.stop(noteNumber: 85, channel: 0)
                                conductor.instrument.stop(noteNumber: 86, channel: 0)
                                conductor.instrument.stop(noteNumber: 87, channel: 0)
                                conductor.instrument.stop(noteNumber: 88, channel: 0)
                                conductor.instrument.stop(noteNumber: 89, channel: 0)
                                conductor.instrument.stop(noteNumber: 90, channel: 0)
                                conductor.instrument.stop(noteNumber: 91, channel: 0)
                                conductor.instrument.stop(noteNumber: 93, channel: 0)
                                conductor.instrument.stop(noteNumber: 94, channel: 0)
                                conductor.instrument.stop(noteNumber: 95, channel: 0)
                                conductor.instrument.stop(noteNumber: 96, channel: 0)
                                conductor.instrument.stop(noteNumber: 97, channel: 0)
                                conductor.instrument.stop(noteNumber: 98, channel: 0)
                                conductor.instrument.stop(noteNumber: 99, channel: 0)
                                conductor.instrument.stop(noteNumber: 100, channel: 0)
                                conductor.instrument.stop(noteNumber: 101, channel: 0)
                                midiNote = 92
                                conductor.instrument.play(noteNumber: MIDINoteNumber(midiNote), velocity: UInt8(fader1global*100), channel: 0)
                            }
                        case 0.8 ..< 0.9:
                            if midiNote == 93 {
                                
                            } else {
                                conductor.instrument.stop(noteNumber: 70, channel: 0)
                                conductor.instrument.stop(noteNumber: 71, channel: 0)
                                conductor.instrument.stop(noteNumber: 72, channel: 0)
                                conductor.instrument.stop(noteNumber: 73, channel: 0)
                                conductor.instrument.stop(noteNumber: 74, channel: 0)
                                conductor.instrument.stop(noteNumber: 75, channel: 0)
                                conductor.instrument.stop(noteNumber: 76, channel: 0)
                                conductor.instrument.stop(noteNumber: 77, channel: 0)
                                conductor.instrument.stop(noteNumber: 78, channel: 0)
                                conductor.instrument.stop(noteNumber: 79, channel: 0)
                                conductor.instrument.stop(noteNumber: 80, channel: 0)
                                conductor.instrument.stop(noteNumber: 81, channel: 0)
                                conductor.instrument.stop(noteNumber: 82, channel: 0)
                                conductor.instrument.stop(noteNumber: 83, channel: 0)
                                conductor.instrument.stop(noteNumber: 84, channel: 0)
                                conductor.instrument.stop(noteNumber: 85, channel: 0)
                                conductor.instrument.stop(noteNumber: 86, channel: 0)
                                conductor.instrument.stop(noteNumber: 87, channel: 0)
                                conductor.instrument.stop(noteNumber: 88, channel: 0)
                                conductor.instrument.stop(noteNumber: 89, channel: 0)
                                conductor.instrument.stop(noteNumber: 90, channel: 0)
                                conductor.instrument.stop(noteNumber: 91, channel: 0)
                                conductor.instrument.stop(noteNumber: 92, channel: 0)
                                conductor.instrument.stop(noteNumber: 94, channel: 0)
                                conductor.instrument.stop(noteNumber: 95, channel: 0)
                                conductor.instrument.stop(noteNumber: 96, channel: 0)
                                conductor.instrument.stop(noteNumber: 97, channel: 0)
                                conductor.instrument.stop(noteNumber: 98, channel: 0)
                                conductor.instrument.stop(noteNumber: 99, channel: 0)
                                conductor.instrument.stop(noteNumber: 100, channel: 0)
                                conductor.instrument.stop(noteNumber: 101, channel: 0)
                                midiNote = 93
                                conductor.instrument.play(noteNumber: MIDINoteNumber(midiNote), velocity: UInt8(fader1global*100), channel: 0)
                            }
                            
                        case 0.8 ..< 0.9:
                            if midiNote == 94 {
                                
                            } else {
                                conductor.instrument.stop(noteNumber: 70, channel: 0)
                                conductor.instrument.stop(noteNumber: 71, channel: 0)
                                conductor.instrument.stop(noteNumber: 72, channel: 0)
                                conductor.instrument.stop(noteNumber: 73, channel: 0)
                                conductor.instrument.stop(noteNumber: 74, channel: 0)
                                conductor.instrument.stop(noteNumber: 75, channel: 0)
                                conductor.instrument.stop(noteNumber: 76, channel: 0)
                                conductor.instrument.stop(noteNumber: 77, channel: 0)
                                conductor.instrument.stop(noteNumber: 78, channel: 0)
                                conductor.instrument.stop(noteNumber: 79, channel: 0)
                                conductor.instrument.stop(noteNumber: 80, channel: 0)
                                conductor.instrument.stop(noteNumber: 81, channel: 0)
                                conductor.instrument.stop(noteNumber: 82, channel: 0)
                                conductor.instrument.stop(noteNumber: 83, channel: 0)
                                conductor.instrument.stop(noteNumber: 84, channel: 0)
                                conductor.instrument.stop(noteNumber: 85, channel: 0)
                                conductor.instrument.stop(noteNumber: 86, channel: 0)
                                conductor.instrument.stop(noteNumber: 87, channel: 0)
                                conductor.instrument.stop(noteNumber: 88, channel: 0)
                                conductor.instrument.stop(noteNumber: 89, channel: 0)
                                conductor.instrument.stop(noteNumber: 90, channel: 0)
                                conductor.instrument.stop(noteNumber: 91, channel: 0)
                                conductor.instrument.stop(noteNumber: 92, channel: 0)
                                conductor.instrument.stop(noteNumber: 93, channel: 0)
                                conductor.instrument.stop(noteNumber: 95, channel: 0)
                                conductor.instrument.stop(noteNumber: 96, channel: 0)
                                conductor.instrument.stop(noteNumber: 97, channel: 0)
                                conductor.instrument.stop(noteNumber: 98, channel: 0)
                                conductor.instrument.stop(noteNumber: 99, channel: 0)
                                conductor.instrument.stop(noteNumber: 100, channel: 0)
                                conductor.instrument.stop(noteNumber: 101, channel: 0)
                                midiNote = 94
                                conductor.instrument.play(noteNumber: MIDINoteNumber(midiNote), velocity: UInt8(fader1global*100), channel: 0)
                            }
                        case 0.9 ..< 1.0:
                            if midiNote == 95 {
                                
                            } else {
                                conductor.instrument.stop(noteNumber: 70, channel: 0)
                                conductor.instrument.stop(noteNumber: 71, channel: 0)
                                conductor.instrument.stop(noteNumber: 72, channel: 0)
                                conductor.instrument.stop(noteNumber: 73, channel: 0)
                                conductor.instrument.stop(noteNumber: 74, channel: 0)
                                conductor.instrument.stop(noteNumber: 75, channel: 0)
                                conductor.instrument.stop(noteNumber: 76, channel: 0)
                                conductor.instrument.stop(noteNumber: 77, channel: 0)
                                conductor.instrument.stop(noteNumber: 78, channel: 0)
                                conductor.instrument.stop(noteNumber: 79, channel: 0)
                                conductor.instrument.stop(noteNumber: 80, channel: 0)
                                conductor.instrument.stop(noteNumber: 81, channel: 0)
                                conductor.instrument.stop(noteNumber: 82, channel: 0)
                                conductor.instrument.stop(noteNumber: 83, channel: 0)
                                conductor.instrument.stop(noteNumber: 84, channel: 0)
                                conductor.instrument.stop(noteNumber: 85, channel: 0)
                                conductor.instrument.stop(noteNumber: 86, channel: 0)
                                conductor.instrument.stop(noteNumber: 87, channel: 0)
                                conductor.instrument.stop(noteNumber: 88, channel: 0)
                                conductor.instrument.stop(noteNumber: 89, channel: 0)
                                conductor.instrument.stop(noteNumber: 90, channel: 0)
                                conductor.instrument.stop(noteNumber: 91, channel: 0)
                                conductor.instrument.stop(noteNumber: 92, channel: 0)
                                conductor.instrument.stop(noteNumber: 93, channel: 0)
                                conductor.instrument.stop(noteNumber: 94, channel: 0)
                                conductor.instrument.stop(noteNumber: 96, channel: 0)
                                conductor.instrument.stop(noteNumber: 97, channel: 0)
                                conductor.instrument.stop(noteNumber: 98, channel: 0)
                                conductor.instrument.stop(noteNumber: 99, channel: 0)
                                conductor.instrument.stop(noteNumber: 100, channel: 0)
                                conductor.instrument.stop(noteNumber: 101, channel: 0)
                                midiNote = 95
                                conductor.instrument.play(noteNumber: MIDINoteNumber(midiNote), velocity: UInt8(fader1global*100), channel: 0)
                            }
                        case 1.0 ..< 1.1:
                            if midiNote == 96 {
                                
                            } else {
                                conductor.instrument.stop(noteNumber: 70, channel: 0)
                                conductor.instrument.stop(noteNumber: 71, channel: 0)
                                conductor.instrument.stop(noteNumber: 72, channel: 0)
                                conductor.instrument.stop(noteNumber: 73, channel: 0)
                                conductor.instrument.stop(noteNumber: 74, channel: 0)
                                conductor.instrument.stop(noteNumber: 75, channel: 0)
                                conductor.instrument.stop(noteNumber: 76, channel: 0)
                                conductor.instrument.stop(noteNumber: 77, channel: 0)
                                conductor.instrument.stop(noteNumber: 78, channel: 0)
                                conductor.instrument.stop(noteNumber: 79, channel: 0)
                                conductor.instrument.stop(noteNumber: 80, channel: 0)
                                conductor.instrument.stop(noteNumber: 81, channel: 0)
                                conductor.instrument.stop(noteNumber: 82, channel: 0)
                                conductor.instrument.stop(noteNumber: 83, channel: 0)
                                conductor.instrument.stop(noteNumber: 84, channel: 0)
                                conductor.instrument.stop(noteNumber: 85, channel: 0)
                                conductor.instrument.stop(noteNumber: 86, channel: 0)
                                conductor.instrument.stop(noteNumber: 87, channel: 0)
                                conductor.instrument.stop(noteNumber: 88, channel: 0)
                                conductor.instrument.stop(noteNumber: 89, channel: 0)
                                conductor.instrument.stop(noteNumber: 90, channel: 0)
                                conductor.instrument.stop(noteNumber: 91, channel: 0)
                                conductor.instrument.stop(noteNumber: 92, channel: 0)
                                conductor.instrument.stop(noteNumber: 93, channel: 0)
                                conductor.instrument.stop(noteNumber: 94, channel: 0)
                                conductor.instrument.stop(noteNumber: 95, channel: 0)
                                conductor.instrument.stop(noteNumber: 97, channel: 0)
                                conductor.instrument.stop(noteNumber: 98, channel: 0)
                                conductor.instrument.stop(noteNumber: 99, channel: 0)
                                conductor.instrument.stop(noteNumber: 100, channel: 0)
                                conductor.instrument.stop(noteNumber: 101, channel: 0)
                                midiNote = 96
                                conductor.instrument.play(noteNumber: MIDINoteNumber(midiNote), velocity: UInt8(fader1global*100), channel: 0)
                            }
                        case 1.1 ..< 1.2:
                            if midiNote == 97 {
                                
                            } else {
                                conductor.instrument.stop(noteNumber: 70, channel: 0)
                                conductor.instrument.stop(noteNumber: 71, channel: 0)
                                conductor.instrument.stop(noteNumber: 72, channel: 0)
                                conductor.instrument.stop(noteNumber: 73, channel: 0)
                                conductor.instrument.stop(noteNumber: 74, channel: 0)
                                conductor.instrument.stop(noteNumber: 75, channel: 0)
                                conductor.instrument.stop(noteNumber: 76, channel: 0)
                                conductor.instrument.stop(noteNumber: 77, channel: 0)
                                conductor.instrument.stop(noteNumber: 78, channel: 0)
                                conductor.instrument.stop(noteNumber: 79, channel: 0)
                                conductor.instrument.stop(noteNumber: 80, channel: 0)
                                conductor.instrument.stop(noteNumber: 81, channel: 0)
                                conductor.instrument.stop(noteNumber: 82, channel: 0)
                                conductor.instrument.stop(noteNumber: 83, channel: 0)
                                conductor.instrument.stop(noteNumber: 84, channel: 0)
                                conductor.instrument.stop(noteNumber: 85, channel: 0)
                                conductor.instrument.stop(noteNumber: 86, channel: 0)
                                conductor.instrument.stop(noteNumber: 87, channel: 0)
                                conductor.instrument.stop(noteNumber: 88, channel: 0)
                                conductor.instrument.stop(noteNumber: 89, channel: 0)
                                conductor.instrument.stop(noteNumber: 90, channel: 0)
                                conductor.instrument.stop(noteNumber: 91, channel: 0)
                                conductor.instrument.stop(noteNumber: 92, channel: 0)
                                conductor.instrument.stop(noteNumber: 93, channel: 0)
                                conductor.instrument.stop(noteNumber: 94, channel: 0)
                                conductor.instrument.stop(noteNumber: 95, channel: 0)
                                conductor.instrument.stop(noteNumber: 96, channel: 0)
                                conductor.instrument.stop(noteNumber: 98, channel: 0)
                                conductor.instrument.stop(noteNumber: 99, channel: 0)
                                conductor.instrument.stop(noteNumber: 100, channel: 0)
                                conductor.instrument.stop(noteNumber: 101, channel: 0)
                                midiNote = 97
                                conductor.instrument.play(noteNumber: MIDINoteNumber(midiNote), velocity: UInt8(fader1global*100), channel: 0)
                            }
                        case 1.2 ..< 1.3:
                            if midiNote == 98 {
                                
                            } else {
                                conductor.instrument.stop(noteNumber: 70, channel: 0)
                                conductor.instrument.stop(noteNumber: 71, channel: 0)
                                conductor.instrument.stop(noteNumber: 72, channel: 0)
                                conductor.instrument.stop(noteNumber: 73, channel: 0)
                                conductor.instrument.stop(noteNumber: 74, channel: 0)
                                conductor.instrument.stop(noteNumber: 75, channel: 0)
                                conductor.instrument.stop(noteNumber: 76, channel: 0)
                                conductor.instrument.stop(noteNumber: 77, channel: 0)
                                conductor.instrument.stop(noteNumber: 78, channel: 0)
                                conductor.instrument.stop(noteNumber: 79, channel: 0)
                                conductor.instrument.stop(noteNumber: 80, channel: 0)
                                conductor.instrument.stop(noteNumber: 81, channel: 0)
                                conductor.instrument.stop(noteNumber: 82, channel: 0)
                                conductor.instrument.stop(noteNumber: 83, channel: 0)
                                conductor.instrument.stop(noteNumber: 84, channel: 0)
                                conductor.instrument.stop(noteNumber: 85, channel: 0)
                                conductor.instrument.stop(noteNumber: 86, channel: 0)
                                conductor.instrument.stop(noteNumber: 87, channel: 0)
                                conductor.instrument.stop(noteNumber: 88, channel: 0)
                                conductor.instrument.stop(noteNumber: 89, channel: 0)
                                conductor.instrument.stop(noteNumber: 90, channel: 0)
                                conductor.instrument.stop(noteNumber: 91, channel: 0)
                                conductor.instrument.stop(noteNumber: 92, channel: 0)
                                conductor.instrument.stop(noteNumber: 93, channel: 0)
                                conductor.instrument.stop(noteNumber: 94, channel: 0)
                                conductor.instrument.stop(noteNumber: 95, channel: 0)
                                conductor.instrument.stop(noteNumber: 96, channel: 0)
                                conductor.instrument.stop(noteNumber: 97, channel: 0)
                                conductor.instrument.stop(noteNumber: 99, channel: 0)
                                conductor.instrument.stop(noteNumber: 100, channel: 0)
                                conductor.instrument.stop(noteNumber: 101, channel: 0)

                                midiNote = 98
                                conductor.instrument.play(noteNumber: MIDINoteNumber(midiNote), velocity: UInt8(fader1global*100), channel: 0)
                            }
                        case 1.3 ..< 1.4:
                            if midiNote == 99 {
                                
                            } else {
                                conductor.instrument.stop(noteNumber: 70, channel: 0)
                                conductor.instrument.stop(noteNumber: 71, channel: 0)
                                conductor.instrument.stop(noteNumber: 72, channel: 0)
                                conductor.instrument.stop(noteNumber: 73, channel: 0)
                                conductor.instrument.stop(noteNumber: 74, channel: 0)
                                conductor.instrument.stop(noteNumber: 75, channel: 0)
                                conductor.instrument.stop(noteNumber: 76, channel: 0)
                                conductor.instrument.stop(noteNumber: 77, channel: 0)
                                conductor.instrument.stop(noteNumber: 78, channel: 0)
                                conductor.instrument.stop(noteNumber: 79, channel: 0)
                                conductor.instrument.stop(noteNumber: 80, channel: 0)
                                conductor.instrument.stop(noteNumber: 81, channel: 0)
                                conductor.instrument.stop(noteNumber: 82, channel: 0)
                                conductor.instrument.stop(noteNumber: 83, channel: 0)
                                conductor.instrument.stop(noteNumber: 84, channel: 0)
                                conductor.instrument.stop(noteNumber: 85, channel: 0)
                                conductor.instrument.stop(noteNumber: 86, channel: 0)
                                conductor.instrument.stop(noteNumber: 87, channel: 0)
                                conductor.instrument.stop(noteNumber: 88, channel: 0)
                                conductor.instrument.stop(noteNumber: 89, channel: 0)
                                conductor.instrument.stop(noteNumber: 90, channel: 0)
                                conductor.instrument.stop(noteNumber: 91, channel: 0)
                                conductor.instrument.stop(noteNumber: 92, channel: 0)
                                conductor.instrument.stop(noteNumber: 93, channel: 0)
                                conductor.instrument.stop(noteNumber: 94, channel: 0)
                                conductor.instrument.stop(noteNumber: 95, channel: 0)
                                conductor.instrument.stop(noteNumber: 96, channel: 0)
                                conductor.instrument.stop(noteNumber: 97, channel: 0)
                                conductor.instrument.stop(noteNumber: 98, channel: 0)
                                conductor.instrument.stop(noteNumber: 100, channel: 0)
                                conductor.instrument.stop(noteNumber: 101, channel: 0)
                                midiNote = 99
                                conductor.instrument.play(noteNumber: MIDINoteNumber(midiNote), velocity: UInt8(fader1global*100), channel: 0)
                            }
                        case 1.4 ..< 1.5:
                            if midiNote == 100 {

                            } else {
                                conductor.instrument.stop(noteNumber: 70, channel: 0)
                                conductor.instrument.stop(noteNumber: 71, channel: 0)
                                conductor.instrument.stop(noteNumber: 72, channel: 0)
                                conductor.instrument.stop(noteNumber: 73, channel: 0)
                                conductor.instrument.stop(noteNumber: 74, channel: 0)
                                conductor.instrument.stop(noteNumber: 75, channel: 0)
                                conductor.instrument.stop(noteNumber: 76, channel: 0)
                                conductor.instrument.stop(noteNumber: 77, channel: 0)
                                conductor.instrument.stop(noteNumber: 78, channel: 0)
                                conductor.instrument.stop(noteNumber: 79, channel: 0)
                                conductor.instrument.stop(noteNumber: 80, channel: 0)
                                conductor.instrument.stop(noteNumber: 81, channel: 0)
                                conductor.instrument.stop(noteNumber: 82, channel: 0)
                                conductor.instrument.stop(noteNumber: 83, channel: 0)
                                conductor.instrument.stop(noteNumber: 84, channel: 0)
                                conductor.instrument.stop(noteNumber: 85, channel: 0)
                                conductor.instrument.stop(noteNumber: 86, channel: 0)
                                conductor.instrument.stop(noteNumber: 87, channel: 0)
                                conductor.instrument.stop(noteNumber: 88, channel: 0)
                                conductor.instrument.stop(noteNumber: 89, channel: 0)
                                conductor.instrument.stop(noteNumber: 90, channel: 0)
                                conductor.instrument.stop(noteNumber: 91, channel: 0)
                                conductor.instrument.stop(noteNumber: 92, channel: 0)
                                conductor.instrument.stop(noteNumber: 93, channel: 0)
                                conductor.instrument.stop(noteNumber: 94, channel: 0)
                                conductor.instrument.stop(noteNumber: 95, channel: 0)
                                conductor.instrument.stop(noteNumber: 96, channel: 0)
                                conductor.instrument.stop(noteNumber: 97, channel: 0)
                                conductor.instrument.stop(noteNumber: 98, channel: 0)
                                conductor.instrument.stop(noteNumber: 99, channel: 0)
                                conductor.instrument.stop(noteNumber: 101, channel: 0)
                                midiNote = 100
                                conductor.instrument.play(noteNumber: MIDINoteNumber(midiNote), velocity: UInt8(fader1global*100), channel: 0)
                            }
                        default:
                            conductor.instrument.stop(noteNumber: 70, channel: 0)
                            conductor.instrument.stop(noteNumber: 71, channel: 0)
                            conductor.instrument.stop(noteNumber: 72, channel: 0)
                            conductor.instrument.stop(noteNumber: 73, channel: 0)
                            conductor.instrument.stop(noteNumber: 74, channel: 0)
                            conductor.instrument.stop(noteNumber: 75, channel: 0)
                            conductor.instrument.stop(noteNumber: 76, channel: 0)
                            conductor.instrument.stop(noteNumber: 77, channel: 0)
                            conductor.instrument.stop(noteNumber: 78, channel: 0)
                            conductor.instrument.stop(noteNumber: 79, channel: 0)
                            conductor.instrument.stop(noteNumber: 80, channel: 0)
                            conductor.instrument.stop(noteNumber: 81, channel: 0)
                            conductor.instrument.stop(noteNumber: 82, channel: 0)
                            conductor.instrument.stop(noteNumber: 83, channel: 0)
                            conductor.instrument.stop(noteNumber: 84, channel: 0)
                            conductor.instrument.stop(noteNumber: 85, channel: 0)
                            conductor.instrument.stop(noteNumber: 86, channel: 0)
                            conductor.instrument.stop(noteNumber: 87, channel: 0)
                            conductor.instrument.stop(noteNumber: 88, channel: 0)
                            conductor.instrument.stop(noteNumber: 89, channel: 0)
                            conductor.instrument.stop(noteNumber: 90, channel: 0)
                            conductor.instrument.stop(noteNumber: 91, channel: 0)
                            conductor.instrument.stop(noteNumber: 92, channel: 0)
                            conductor.instrument.stop(noteNumber: 93, channel: 0)
                            conductor.instrument.stop(noteNumber: 94, channel: 0)
                            conductor.instrument.stop(noteNumber: 95, channel: 0)
                            conductor.instrument.stop(noteNumber: 96, channel: 0)
                            conductor.instrument.stop(noteNumber: 97, channel: 0)
                            conductor.instrument.stop(noteNumber: 98, channel: 0)
                            conductor.instrument.stop(noteNumber: 99, channel: 0)
                            conductor.instrument.stop(noteNumber: 100, channel: 0)
                            conductor.instrument.stop(noteNumber: 101, channel: 0)
                            //midiNote = 70
                            //conductor.instrument.play(noteNumber: MIDINoteNumber(midiNote), velocity: UInt8(fader1global*100), channel: 0)
                        }
//                        if oscOn == true{
//                            conductor.engine.output = conductor.osc
//                        }else{
//                            conductor.engine.output = conductor.instrument
//                        }
                        //print(MIDINoteNumber(midiNote))
//                        midiNote = Float(round(69 + 12 * log2(myFrequency/440)))
//                        conductor.instrument.play(noteNumber: MIDINoteNumber(midiNote), velocity: UInt8(fader1global*100), channel: 0)
//                        conductor.instrument.stop()
                        
                    }
                }
            }
        }
        .padding(.all, 30.0)
    }//view
    
    func instrumentDidDismiss(){
        isShowingSelectInstrumentMenu = false
//        print("Instrument:" + instrumentSelected)
//        if let fileURL = Bundle.main.url(forResource: instrumentSelected, withExtension: "exs"){
//            try? conductor.instrument.loadInstrument(url: fileURL)
//        }else {
//                Log("Could not find file")
//        }
    }
    func effectsDidDismiss(){
        isShowingAudioEffectsMenu = false
    }
    func settingsDidDismiss(){
        isShowingSettingsMenu = false
    }
}//struct

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeLeft)
            .environmentObject(ColourScheme())
    }
}

//Button styling
struct MyButtonStyle: ButtonStyle {
    @State var thirdHeight: CGFloat = UIScreen.main.bounds.height/3
    @State var thirdWidth: CGFloat = UIScreen.main.bounds.width/3
    
    @EnvironmentObject var colours: ColourScheme
    
    var background: some View {
        RoundedRectangle(cornerRadius: 50)
            .fill(colours.colour4)
            .frame(width: (thirdWidth - 30), height: (thirdHeight - 40))
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(20)
            .background(background)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}



