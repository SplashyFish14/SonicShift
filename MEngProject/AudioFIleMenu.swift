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
    var audioFiles: [AudioSamples]
    
    var body: some View {
        VStack{
            //Title text
            HStack{
                Text("Select Audio File")
                    .font(.largeTitle)
                    .frame(alignment: .center)
            }
            .frame(height: eightHeight)
            //List of buttons to select each audio file
            HStack{
                List{
                    ForEach(audioFiles) { file in
                        Button (action: {
                            fileSelected = file.songid
//                            print(audioFiles[fileSelected])
                        }) {
                            Text(file.name)
                                .font(.title)
                                .bold()
                                .foregroundColor(Color.white)
                                .frame(width: 600, height: 60)

                        }
                        .buttonStyle(MyButtonStyle2())
                    }
                }
            }
        }
    }
}
struct MyButtonStyle2: ButtonStyle {
    
    @EnvironmentObject var colours: ColourScheme
    
    var background: some View {
//        Color.gray
        RoundedRectangle(cornerRadius: 20)
            .fill(colours.colour2)
//            .frame(width: (500), height:(80))

    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(20)
            .background(background)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
    
}

//struct AudioFIleMenu_Previews: PreviewProvider {
//    static var previews: some View {
//        AudioFIleMenu()
//            .previewInterfaceOrientation(.landscapeLeft)
//
//    }
//}
