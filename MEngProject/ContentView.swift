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
    let engine = AudioEngine()
    var osc = Oscillator()
    init() {
        engine.output = osc
        try? engine.start()
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
    
    @StateObject var conductor = OscillatorConductor()
    @State var oscOn: Bool = false
    
    @State private var isShowingSelectInstrumentMenu = false
    
    
    var body: some View {
        
        
        VStack {
            
            VStack(alignment: .center, spacing: 15) {
                VStack(alignment: .center){
                    HStack {
                        //Instrument Menu button
                        //Currently starts oscillator
                        Button(action: {
                            print("Instrument")
                            isShowingSelectInstrumentMenu.toggle()
//                            if oscOn == false {
//                                conductor.osc.start()
//                                oscOn = true
//                            } else {
//                                conductor.osc.stop()
//                                oscOn = false
//                            }
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
                        .sheet(isPresented: $isShowingSelectInstrumentMenu, onDismiss: instrumentDidDismiss){
                            SelectInstrument()}
                        //Effects menu button
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
                        
                        //Settings menu button
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
                        //Left fader
                        Fader()
                            .frame(width: sixthWidth)
                        
                        VStack{
                            HStack {
                                //1st arc knob
                                ArcKnob("Vol", value: $volValue)
                                    .foregroundColor(Color.black)
                                    .frame(height: thirdHeight - 20)
                                //2nd arc knob
                                ArcKnob("Reverb", value: $revValue)
                                    .foregroundColor(Color.black)
                                    .frame(height: thirdHeight - 20)
                            }
                            //Playback section
                            AudioFilePlayBack()
                                .frame(height: thirdHeight)
                        }
                        //Right fader
                        Fader2()
                            .frame(width: sixthWidth)
                    }
                }
            }
            //Motion manager updates, and oscillator updates
            .onAppear(){
                conductor.osc.start()
                motionManagerDM.startDeviceMotionUpdates(to: OperationQueue.main) {
                    (data, error) in
                    if let deviceData = motionManagerDM.deviceMotion {
//                        print("pitch: \(deviceData.attitude.pitch)  roll: \(deviceData.attitude.roll) yaw: \(deviceData.attitude.yaw)")
                        conductor.osc.amplitude = AUValue(fader1global)
//                        print("Amplitude: \(conductor.osc.amplitude)")
                        conductor.osc.frequency = AUValue((deviceData.attitude.pitch + 1.56) * 500)
//                        print("Frequency: \(conductor.osc.frequency)")
                        
                    }
                }
            }
        }
        .padding(.all, 30.0)
    }//view
    func instrumentDidDismiss(){
        isShowingSelectInstrumentMenu = false
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



