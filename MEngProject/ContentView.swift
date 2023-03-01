//
//  ContentView.swift
//  MEngProject
//
//  Created by Alice Milburn on 17/02/2023.
//

import SwiftUI
import Controls
import CoreMotion

struct ContentView: View {
    @State var sliderValue: Float = 0
    @State var volValue: Float = 0
    @State var revValue: Float = 0
    
    @State var thirdWidth: CGFloat = UIScreen.main.bounds.width/3
    @State var thirdHeight: CGFloat = UIScreen.main.bounds.height/3
    @State var sixthWidth: CGFloat = UIScreen.main.bounds.width/6
    
    let motionManager = CMMotionManager()
    let motionManagerDM = CMMotionManager()

    
    var body: some View {

        
        VStack {

            VStack(alignment: .center, spacing: 15) {
                VStack(alignment: .center){
                
                    HStack {
                            
                        Button(action: {
                            print("Instrument")
                        }){
                            VStack{
                                Image(systemName: "pianokeys.inverse")
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
                                    .font(.largeTitle)
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
                        VStack{
                            HStack {
                                ArcKnob("Vol", value: $volValue)
                                    .foregroundColor(Color.black)
                                    .frame(height: thirdHeight - 20)
                                  
                                ArcKnob("Reverb", value: $revValue)
                                    .foregroundColor(Color.black)
                                    .frame(height: thirdHeight - 20)
                                
                            }
                            RoundedRectangle(cornerRadius: 50)
                                .fill(Color.gray)
                                .frame(height: thirdHeight)
                                
                        }
                        Fader()
                            .frame(width: sixthWidth)
                        
                        
                    }

                }
            }
            .onAppear(){
//                motionManager.startGyroUpdates(to: OperationQueue.main) {
//                    (data, error) in
//                        if let gyroData = motionManager.gyroData {
//                            print("gyroscope: \(gyroData.rotationRate.x)")
//
//                        }
//
//
//                    // Handle motion data
//                }
                motionManagerDM.startDeviceMotionUpdates(to: OperationQueue.main) {
                    (data, error) in
                        if let deviceData = motionManagerDM.deviceMotion {
                            print("pitch: \(deviceData.attitude.pitch)  roll: \(deviceData.attitude.roll) yaw: \(deviceData.attitude.yaw)")
                            
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


