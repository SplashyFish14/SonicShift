//
//  AudioFIleMenu.swift
//  MEngProject
//
//  Created by Alice Milburn on 09/03/2023.
//

import SwiftUI

struct AudioFIleMenu: View {
    @State var eightHeight: CGFloat = UIScreen.main.bounds.height/10
    @State var tenthWidth: CGFloat = UIScreen.main.bounds.width/10
    @State var audioFiles: [String] = ["Audio File 1", "Audio File 2", "Audio File 3"]
    var body: some View {
        VStack{
            HStack{
                HStack{}
                    .frame(width:tenthWidth)
                Text("Select Audio File")
                    .font(.largeTitle)
                    .frame(width: tenthWidth*8-30)
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
            HStack{
//                List{
//
//                    ForEach(audioFiles, id: \.self) { (audioFiles: String) in
//                        Text(audioFiles)
//                    }
//
//                    .font(.title)
//                    .listStyle(InsetGroupedListStyle())
//                    .listRowBackground(Color.gray)
//                    .foregroundColor(Color.white)
//                    .bold()
////                    .listRowSeparator(Visibility)

//                }
                List{
                    
                    ForEach(audioFiles, id: \.self) { (audioFiles: String) in
                        VStack {
                           Button(action: { print("Button at \(audioFiles)") }) {
                               Text(audioFiles)
                           }
                           .buttonStyle(MyButtonStyle2())

                       }
                   }
                }
            }
        }
    }
}
struct MyButtonStyle2: ButtonStyle {
    
    var background: some View {
        RoundedRectangle(cornerRadius: 30)
            .fill(Color.gray)
            .frame(width: (UIScreen.main.bounds.width), height:(80))
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(20)
            .background(background)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
    
}

struct AudioFIleMenu_Previews: PreviewProvider {
    static var previews: some View {
        AudioFIleMenu()
            .previewInterfaceOrientation(.landscapeLeft)

    }
}
