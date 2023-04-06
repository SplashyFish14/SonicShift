//
//  AudioEffectsMenu.swift
//  MEngProject
//
//  Created by Alice Milburn on 31/03/2023.
//

import SwiftUI

struct AudioEffectsMenu: View {
    @State var eightHeight: CGFloat = UIScreen.main.bounds.height/10
    
    var body: some View {
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
                        Text("Effect 1")
                    }
                }
                VStack{
                    Text("Select Effect 1")
                        .font(.title)
                    List{
                        Text("Effect 1")
                    }
                }
            }
        }
        
    }
}

struct AudioEffectsMenu_Previews: PreviewProvider {
    static var previews: some View {
        AudioEffectsMenu()
    }
}
