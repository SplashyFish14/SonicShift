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
    
    var body: some View {
        VStack{
            HStack{
                HStack{}
                    .frame(width:tenthWidth)
                ZStack{
                    RoundedRectangle(cornerRadius: 30)
                        .foregroundColor(.gray)
                    Text("Select Instrument")
                        .font(.largeTitle)
                        .bold()
                }
                
                .frame(width: tenthWidth*8-30, height: eightHeight)
               
                Button ( action: {
                    print("Audio Menu Close")
                }){
                    Image(systemName: "xmark.square.fill")
                        .resizable()
                        .scaledToFit()
                        .font(.largeTitle)
                        .foregroundColor(Color.black)
                }
                .frame(width: tenthWidth)
                
            }
            .frame(width: UIScreen.main.bounds.width, height: eightHeight)
            VStack{
                HStack{
                    Button(action: {
                        print("Settings")
                    }){
                        VStack{
                            Image(systemName: "guitars.fill")
                                .resizable()
                                .scaledToFit()
                                .font(.largeTitle)
                                .foregroundColor(Color.black)
                            Text("Guitar")
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
                            Image(systemName: "guitars.fill")
                                .resizable()
                                .scaledToFit()
                                .font(.largeTitle)
                                .foregroundColor(Color.black)
                            Text("Guitar")
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
                            Image(systemName: "guitars.fill")
                                .resizable()
                                .scaledToFit()
                                .font(.largeTitle)
                                .foregroundColor(Color.black)
                            Text("Guitar")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                        }
                    }
                    .buttonStyle(MyButtonStyle())
                    .frame(width: thirdWidth - 20)
                }
                HStack{
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
                    
                    Button(action: {
                        print("Settings")
                    }){
                        VStack{
                            Image(systemName: "gearshape.fill")
//                                .resizable()
//                                .scaledToFit()
                                .font(.largeTitle)
                                .foregroundColor(Color.black)
                            Text("Settings")
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
                            Text("Settings")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                        }
                    }
                    .buttonStyle(MyButtonStyle())
                    .frame(width: thirdWidth - 20)
                }
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
