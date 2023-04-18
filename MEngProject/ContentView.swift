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

//oscillator code
class OscillatorConductor: ObservableObject, HasAudioEngine {
    //Set up audio engine
    let engine = AudioEngine()
    //Set up oscillator
    var osc = Oscillator()
    init() {
        //Set the oscillator as the engine output
        engine.output = osc
        //Start the engine
        try? engine.start()
        //Set initial values for the oscilators amplitude and frequency
        osc.amplitude = 0.3
        print("Amplitude: \(osc.amplitude)")
        osc.frequency = 330
        print("Frequency: \(osc.frequency)")
    }
}

struct ContentView: View {
    @EnvironmentObject var fader2: PlayBackClass
    
    @State var sliderValue: Float = 0
    @State var volValue: Float = 0
    @State var revValue: Float = 0
    
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
                        
                        VStack{
                            HStack {
                                //1st arc knob
                                ArcKnob("Effect", value: $volValue)
                                    .foregroundColor(CustomYellow)
                                    .frame(height: thirdHeight - 20)
//                                    .backgroundColor(CustomGreen)
//                                    .backgroundStyle(CustomGreen)
//                                ArcKnob.backgroundColor = CustomGreen
//backgroundStyle()
                                //2nd arc knob
                                ArcKnob("Effect", value: $revValue)
                                    .foregroundColor(CustomYellow)
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
                    }
                }
            }
            //Motion manager updates, and oscillator updates
            .onAppear(){
                conductor.osc.start()
                motionManagerDM.startDeviceMotionUpdates(to: OperationQueue.main) {
                    (data, error) in
                    if let deviceData = motionManagerDM.deviceMotion {
//                        print("pitch: \(deviceData.attitude.pitch)" +
//                              "roll: \(deviceData.attitude.roll) yaw: \(deviceData.attitude.yaw)")
                        conductor.osc.amplitude = AUValue(fader1global)
                        conductor.osc.frequency = AUValue((deviceData.attitude.pitch + 1.56) * 500)
                        
                    }
                }
            }
        }
        .padding(.all, 30.0)
    }//view
    func instrumentDidDismiss(){
        isShowingSelectInstrumentMenu = false
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
    }
}

//Button styling
struct MyButtonStyle: ButtonStyle {
    @State var thirdHeight: CGFloat = UIScreen.main.bounds.height/3
    @State var thirdWidth: CGFloat = UIScreen.main.bounds.width/3
    
    var background: some View {
        RoundedRectangle(cornerRadius: 50)
            .fill(CustomPurple)
            .frame(width: (thirdWidth - 30), height: (thirdHeight - 40))
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(20)
            .background(background)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}



