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

class OscillatorConductor: ObservableObject, HasAudioEngine {
    let engine = AudioEngine()
    
    //    func noteOn(pitch: Pitch, point _: CGPoint) {
    //        isPlaying = true
    //        //osc.frequency = AUValue(pitch.midiNoteNumber).midiNoteToFrequency()
    //
    //    }
    
    //    @Published var isPlaying: Bool = false {
    //        didSet { isPlaying ? osc.start() : osc.stop() }
    //    }
    
    var osc = Oscillator()
//    @State var synth1 = Synth(masterVolume: AUValue(fader1global))
    init() {
        engine.output = osc
        try? engine.start()
//        osc.start()
        
        osc.amplitude = 0.3//AUValue(fader1global * 100 )
        print("Amplitude: \(osc.amplitude)")
        osc.frequency = 330//Float(fader2global * 10000)
        print("Frequency: \(osc.frequency)")
        
    }
    
}

struct ContentView: View {
    @State var sliderValue: Float = 0
    @State var volValue: Float = 0
    @State var revValue: Float = 0
    
    @State var thirdWidth: CGFloat = UIScreen.main.bounds.width/3
    @State var thirdHeight: CGFloat = UIScreen.main.bounds.height/3
    @State var sixthWidth: CGFloat = UIScreen.main.bounds.width/6
    
    let motionManager = CMMotionManager()
    let motionManagerDM = CMMotionManager()
    
    //    @State var fader1Value: CGFloat = fader1global
    @State var fader2Value: CGFloat = fader2global
    
    @StateObject var conductor = OscillatorConductor()
    
    
    var body: some View {
        
        
        VStack {
            
            VStack(alignment: .center, spacing: 15) {
                VStack(alignment: .center){
                    HStack {
                        
                        Button(action: {
                            print("Instrument")
                            conductor.osc.start()
                            
                        }){
                            VStack{
                                Image(systemName: "pianokeys.inverse")
                                    .resizable()
                                    .scaledToFit()
                                    .font(.largeTitle)
                                    .foregroundColor(Color.black)
                                
                                Text("Instrument")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                            }
                        }
                        .buttonStyle(MyButtonStyle())
                        .frame(width: thirdWidth - 20)
                        
                        
                        Button(action: {
                            print("Effects")
                        }){
                            VStack{
                                Image(systemName: "slider.vertical.3")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(Color.black)
                                Text("Effects")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                            }
                        }
                        .buttonStyle(MyButtonStyle())
                        .frame(width: thirdWidth - 20)
                        
                        Button(action: {
                            print("Settings")
                        }){
                            VStack{
                                Image(systemName: "gearshape.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .font(.largeTitle)
                                    .foregroundColor(Color.black)
                                Text("Settings")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                            }
                        }
                        .buttonStyle(MyButtonStyle())
                        .frame(width: thirdWidth - 20)
                        
                    }
                    .padding(.top, 10.0)
                    .frame(height: thirdHeight - 30)
                
                    HStack {
                        
                        Fader()
                            .frame(width: sixthWidth)
                        //conductor.osc.amplitude = Float(fader1Value)
                        
                        VStack{
                            HStack {
                                ArcKnob("Vol", value: $volValue)
                                    .foregroundColor(Color.black)
                                    .frame(height: thirdHeight - 20)
                                
                                ArcKnob("Reverb", value: $revValue)
                                    .foregroundColor(Color.black)
                                    .frame(height: thirdHeight - 20)
                                
                            }
                            AudioFilePlayBack()
                                .frame(height: thirdHeight)
                            
                        }
                        Fader2()
                            .frame(width: sixthWidth)
                        
                        //conductor.osc.frequency = Float(fader1global)
                        
                    }
                    
                }
            }
            .onAppear(){
               
                
//                if (fader1global > 0) {
//                    conductor.start()
//                    conductor.osc.start()
//                }
//                else {
//                    conductor.stop()
//                }
                motionManagerDM.startDeviceMotionUpdates(to: OperationQueue.main) {
                    (data, error) in
                    if let deviceData = motionManagerDM.deviceMotion {
//                        print("pitch: \(deviceData.attitude.pitch)  roll: \(deviceData.attitude.roll) yaw: \(deviceData.attitude.yaw)")
                        conductor.osc.amplitude = AUValue(fader1global * 10)
                        print("Amplitude: \(conductor.osc.amplitude)")
                        conductor.osc.frequency = AUValue((deviceData.attitude.pitch) * 1000)
                        print("Frequency: \(conductor.osc.frequency)")
                        
                    }
                }
            }
        }
        .padding(.all, 30.0)
    }//view
    
}//struct

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}

struct MyButtonStyle: ButtonStyle {
    @State var thirdHeight: CGFloat = UIScreen.main.bounds.height/3
    @State var thirdWidth: CGFloat = UIScreen.main.bounds.width/3
    
    var background: some View {
        RoundedRectangle(cornerRadius: 50)
            .fill(Color.gray)
            .frame(width: (thirdWidth - 30), height: (thirdHeight - 40))
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(20)
            .background(background)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}



