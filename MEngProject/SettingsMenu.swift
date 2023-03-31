//
//  SettingsMenu.swift
//  MEngProject
//
//  Created by Alice Milburn on 31/03/2023.
//

import SwiftUI

struct SettingsMenu: View {
    @State var eightHeight: CGFloat = UIScreen.main.bounds.height/10

    
    var body: some View {
        VStack{
            HStack{
                Text("Settings")
                    .font(.largeTitle)
                    .frame(alignment: .center)
            }
            .frame(height: eightHeight)
        }
    }
}

struct SettingsMenu_Previews: PreviewProvider {
    static var previews: some View {
        SettingsMenu()
    }
}
