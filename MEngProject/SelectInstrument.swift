//
//  SelectInstrument.swift
//  MEngProject
//
//  Created by Alice Milburn on 22/02/2023.
//

import SwiftUI

struct SelectInstrument: View {
    @State var eighthHeight: CGFloat = UIScreen.main.bounds.height/10
    @State var tenthWidth: CGFloat = UIScreen.main.bounds.width/10
    @State var thirdWidth: CGFloat = UIScreen.main.bounds.width/3
    
    @EnvironmentObject var conductor: OscillatorConductor
    @EnvironmentObject var volumes: Volumes
    
    var body: some View {
        VStack{
            ZStack{
                Text("Select Instrument")
                    .font(.largeTitle)
                    .frame(alignment: .center)
            }
            .frame(height: eighthHeight)
            .padding(20)

            HStack{
                Spacer()
                Button(action: {
                    print("Oscillator Selected")
//                    oscOn = true
//                    conductor.oscMixer.volume = 0.0
//                    conductor.instMixer.volume = 0.0
                    volumes.OscOn = true
                    print("Inst Volume = \(conductor.instMixer.volume)")
                    print("Osc Mixer = \(conductor.oscMixer.volume)")
                }){
                    VStack{
                        Image(systemName: "waveform")
                            .font(.largeTitle)
                            .foregroundColor(Color.white)
                        Text("Theremin")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                    }
                }
                .buttonStyle(MyButtonStyleInstrument())
                Spacer()
                Button(action: {
                    print("Instrument Selected")
//                    instrumentSelected = "Samples/Vintage Strat"
//                    oscOn = false
//                    conductor.oscMixer.volume = 0.0
//                    conductor.instMixer.volume = 0.0
                    volumes.OscOn = false
                    print("Inst Volume = \(conductor.instMixer.volume)")
                    print("Osc Mixer = \(conductor.oscMixer.volume)")
                }){
                    VStack{
                        Image(systemName: "pianokeys.inverse")
                            .font(.largeTitle)
                            .foregroundColor(Color.white)
                        Text("Keyboard")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                    }
                }
                .buttonStyle(MyButtonStyleInstrument())
                Spacer()
            }
            .padding(.top, 25)
            Spacer()
            HStack{
                Spacer()
                Button(action: {
                    print("Instrument 4")
                }){
                    Text("Coming Soon!")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .rotationEffect(.degrees(-10))
                }
                .buttonStyle(MyButtonStyleInstrument())
                Spacer()
                Button(action: {
                    print("Instrument 5")
                }){
                    Text("Coming Soon!")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .rotationEffect(.degrees(-10))
                }
                .buttonStyle(MyButtonStyleInstrument())
                Spacer()
            }
            Spacer()

        }
    }
}


struct SelectInstrument_Previews: PreviewProvider {
    static var previews: some View {
        SelectInstrument()
            .previewInterfaceOrientation(.landscapeLeft)

    }
}

struct MyButtonStyleInstrument: ButtonStyle {
    @State var thirdHeight: CGFloat = UIScreen.main.bounds.height/3
    @State var fifthWidth: CGFloat = UIScreen.main.bounds.width/4.5
    
    @EnvironmentObject var colours: ColourScheme

    var background: some View {
        RoundedRectangle(cornerRadius: 20)
            .foregroundColor(colours.colour2)
            .frame(width: fifthWidth, height: 190)
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(20)
            .background(background)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}
