//
//  SettingsMenu.swift
//  MEngProject
//
//  Created by Alice Milburn on 31/03/2023.
//

import SwiftUI

struct SettingsMenu: View {
    @State var eightHeight: CGFloat = UIScreen.main.bounds.height/10
//    @State var performanceMode: Bool = false
    
    @EnvironmentObject var colours: ColourScheme
    @EnvironmentObject var performanceMode: Performance
    
    @State var toggly: Bool = false
    
    var body: some View {
        VStack{
            ZStack{
                Text("Settings")
                    .font(.largeTitle)
                    .frame(alignment: .center)
            }
            .frame(height: eightHeight)
            Spacer()
            VStack{
                Text("Colour Scheme")
                    .font(.title)
                HStack{
                    Button(action: {
                        print("Colour Scheme 1")
                        colours.colour1 = CustomBlue
                        colours.colour2 = CustomGreen
                        colours.colour3 = CustomPink
                        colours.colour4 = CustomPurple
                        colours.colour5 = CustomYellow
                        colours.colour6 = CustomPaleBlue
                        colours.colour7 = CustomPaleGreen
                        colours.colour8 = CustomPalePink
                        colours.colour9 = CustomPalePurple
                        colours.colour10 = CustomPaleYellow
                    }){
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(CustomPurple)
                                .frame(height: 100)
                            Text("Colour Scheme 1")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                        }
                        
                    }
                    Button(action: {
                        print("Colour Scheme 2")
                        colours.colour1 = CustomBlue2
                        colours.colour2 = CustomGreen2
                        colours.colour3 = CustomRed
                        colours.colour4 = CustomPurple2
                        colours.colour5 = CustomYellow2
                        colours.colour6 = CustomPaleBlue2
                        colours.colour7 = CustomPaleGreen2
                        colours.colour8 = CustomPaleRed
                        colours.colour9 = CustomPalePurple2
                        colours.colour10 = CustomPaleYellow2
                        
                    }){
                        ZStack{
                            RoundedRectangle(cornerRadius: 15)
                                .fill(CustomGreen2)
                                .frame(height: 100)
                            
                            Text("Colour Scheme 2")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                        }
                    }
                }
                HStack{
                    Button(action: {
                        print("Colour Scheme 3")
                        colours.colour1 = Purp3
                        colours.colour2 = Purp5
                        colours.colour3 = Purp2
                        colours.colour4 = Purp4
                        colours.colour5 = Purp2
                        colours.colour6 = Purp2
                        colours.colour7 = Purp2
                        colours.colour8 = Purp1
                        colours.colour9 = Purp1
                        colours.colour10 = Purp1

                    }){
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Purp4)
                                .frame(height: 100)
                            Text("Colour Scheme 3")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                        }
                        
                    }
                    Button(action: {
                        print("Colour Scheme 4")
                        colours.colour1 = Color.blue
                        colours.colour2 = Color.mint
                        colours.colour3 = Color.red
                        colours.colour4 = Color.cyan
                        colours.colour5 = Color.teal
                        colours.colour6 = Color.gray.opacity(0.50)
                        colours.colour7 = Color.gray.opacity(0.50)
                        colours.colour8 = Color.gray.opacity(0.50)
                        colours.colour9 = Color.gray.opacity(0.50)
                        colours.colour10 = Color.gray.opacity(0.50)

                    }){
                        ZStack{
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.blue)
                                .frame(height: 100)
                            
                            Text("Colour Scheme 4")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                        }
                    }
                }
                Spacer()
                ZStack{
                    Button(action: {
                        toggly.toggle()
                        performanceMode.mode = toggly
                    }){
                        ZStack{
                            RoundedRectangle(cornerRadius: 15)
                                .fill(colours.colour6)
                                .frame(height: 100)
                            HStack{
                                Image(systemName: "music.note")
                                    .font(.title)
                                    .foregroundColor(Color.black)
                                if performanceMode.mode == true{
                                    Text("Performance Mode On")
                                        .font(.title)
                                        .fontWeight(.bold)
                                    .foregroundColor(Color.black)
                                    
                                } else {
                                    Text("Performance Mode Off")
                                        .font(.title)
                                        .fontWeight(.bold)
                                    .foregroundColor(Color.black)
                                }
                            }
                            
                        }
                    }
                }
            }
            .padding()
        }
    }
}


struct SettingsMenu_Previews: PreviewProvider {
    static var previews: some View {
        SettingsMenu()
    }
}
