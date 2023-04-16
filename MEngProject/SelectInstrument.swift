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
    
//    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
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
                    print("Instrument 1")
                }){
                    VStack{
                        Image(systemName: "pianokeys.inverse")
                            .font(.largeTitle)
                            .foregroundColor(Color.white)

                        Text("Instrument 1")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                    }
                }
                .buttonStyle(MyButtonStyleInstrument())
                Spacer()
                Button(action: {
                    print("Instrument 2")
                }){
                    VStack{
                        Image(systemName: "pianokeys.inverse")
                            .font(.largeTitle)
                            .foregroundColor(Color.white)

                        Text("Instrument 2")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)

                    }
                }
                .buttonStyle(MyButtonStyleInstrument())
                Spacer()
                Button(action: {
                    print("Instrument 3")
                }){
                    VStack{
                        Image(systemName: "pianokeys.inverse")
                            .font(.largeTitle)
                            .foregroundColor(Color.white)

                        Text("Instrument 3")
                            .font(.title2)
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
                    VStack{
                        Image(systemName: "pianokeys.inverse")
                            .font(.largeTitle)
                            .foregroundColor(Color.white)

                        Text("Instrument 4")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
}
                }
                .buttonStyle(MyButtonStyleInstrument())
                Spacer()
                Button(action: {
                    print("Instrument 5")
                }){
                    VStack{
                        Image(systemName: "pianokeys.inverse")
                            .font(.largeTitle)
                            .foregroundColor(Color.white)

                        Text("Instrument 5")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
}
                }
                .buttonStyle(MyButtonStyleInstrument())
                Spacer()
                Button(action: {
                    print("Instrument 6")
                }){
                    VStack{
                        Image(systemName: "pianokeys.inverse")
                            .font(.largeTitle)
                            .foregroundColor(Color.white)

                        Text("Instrument 6")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
}
                }
                .buttonStyle(MyButtonStyleInstrument())
                Spacer()
            }
            Spacer()
            HStack{
                Spacer()
                Button(action: {
                    print("Instrument 7")
                }){
                    VStack{
                        Image(systemName: "pianokeys.inverse")
                            .font(.largeTitle)
                            .foregroundColor(Color.white)

                        Text("Instrument 7")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
}
                }
                .buttonStyle(MyButtonStyleInstrument())
                Spacer()
                Button(action: {
                    print("Instrument 8")
                }){
                    VStack{
                        Image(systemName: "pianokeys.inverse")
                            .font(.largeTitle)
                            .foregroundColor(Color.white)

                        Text("Instrument 8")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
}
                }
                .buttonStyle(MyButtonStyleInstrument())
                Spacer()
                Button(action: {
                    print("Instrument 9")
                }){
                    VStack{
                        Image(systemName: "pianokeys.inverse")
                            .font(.largeTitle)
                            .foregroundColor(Color.white)

                        Text("Instrument 9")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
}
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
    @State var fifthWidth: CGFloat = UIScreen.main.bounds.width/5.5
    
    var background: some View {
        RoundedRectangle(cornerRadius: 20)
            .foregroundColor(CustomGreen)
            .frame(width: fifthWidth, height: 160)
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(20)
            .background(background)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}
