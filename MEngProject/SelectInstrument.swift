//
//  SelectInstrument.swift
//  MEngProject
//
//  Created by Alice Milburn on 22/02/2023.
//

import SwiftUI

struct SelectInstrument: View {
    @State var eightHeight: CGFloat = UIScreen.main.bounds.height/10
    @State var tenthWidth: CGFloat = UIScreen.main.bounds.width/10
    @State var thirdWidth: CGFloat = UIScreen.main.bounds.width/3
    
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    var body: some View {
        VStack{
            ZStack{
                
                Text("Select Instrument")
                    .font(.largeTitle)
                    .frame(alignment: .center)
            
            }
            .frame(height: eightHeight)
            .padding(20)
            
            ScrollView{
                Grid{
                    GridRow{
                        Button(action: {
                            print("Instrument 1")
                        }){
                            VStack{
                                Image(systemName: "pianokeys.inverse")
                                    .font(.largeTitle)
                                    .foregroundColor(Color.black)
                                
                                Text("Instrument 1")
                                    .font(.title)
                                    .fontWeight(.bold)
                            }
                        }
                        .buttonStyle(MyButtonStyleInstrument())
                        Button(action: {
                            print("Instrument 2")
                        }){
                            VStack{
                                Image(systemName: "pianokeys.inverse")
                                    .font(.largeTitle)
                                    .foregroundColor(Color.black)
                                
                                Text("Instrument 2")
                                    .font(.title)
                                    .fontWeight(.bold)
                            }
                        }
                        .buttonStyle(MyButtonStyleInstrument())
                        Button(action: {
                            print("Instrument 3")
                        }){
                            VStack{
                                Image(systemName: "pianokeys.inverse")
                                    .font(.largeTitle)
                                    .foregroundColor(Color.black)
                                
                                Text("Instrument 3")
                                    .font(.title)
                                    .fontWeight(.bold)
                            }
                        }
                        .buttonStyle(MyButtonStyleInstrument())
                        
                    }
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                }
                .padding(.top, 25)
                
            }
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
    @State var sixthWidth: CGFloat = UIScreen.main.bounds.width/6
    
    var background: some View {
        RoundedRectangle(cornerRadius: 50)
            .foregroundColor(Color.gray)
            .frame(width: sixthWidth, height: 150)
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(20)
            .background(background)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}
