//
//  AudioEffectsMenu.swift
//  MEngProject
//
//  Created by Alice Milburn on 31/03/2023.
//

import SwiftUI

struct AudioEffectsMenu: View {
    @State var eightHeight: CGFloat = UIScreen.main.bounds.height/10
    @EnvironmentObject var colours: ColourScheme

    var body: some View {
        ZStack{
            VStack{
                ZStack{
                    Text("Select Audio Effects")
                        .font(.largeTitle)
                        .frame(alignment: .center)
                }
                .frame(height: eightHeight)
                HStack{
                    VStack{
                        Text("Select Effect 1")
                            .font(.title)
                        
                        List{
                            Text("Reverb")
                            Text("Echo")
                            Text("Delay")
                        }
                    }
                    VStack{
                        Text("Select Effect 2")
                            .font(.title)
                        List{
                            Text("Reverb")
                            Text("Echo")
                            Text("Delay")
                        }
                    }
                }
            }
            ZStack{
                colours.colour1
                    .ignoresSafeArea()
                    .opacity(0.5)
                Text("Coming Soon!")
                    .font(.largeTitle)
                    .rotationEffect(.degrees(-10))
                    .bold()
            }
        }
    }
}

struct AudioEffectsMenu_Previews: PreviewProvider {
    static var previews: some View {
        AudioEffectsMenu()
    }
}
