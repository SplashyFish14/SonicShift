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
//    @State var audioFilePrettyNames: [String] = ["Audio File 1", "Audio File 2", "Audio File 3"]
//    @State var audioFileNames: [String] = ["66319__oneloginacc__loop_98bpm_2bars.wav", "Audio File 2", "Audio File 3"]

    var body: some View {
        VStack{
            HStack{
                Text("Select Audio File")
                    .font(.largeTitle)
                    .frame(alignment: .center)
            }
            .frame(height: eightHeight)
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
                    
//                    ForEach(audioFiles) { items in
//                        Button(action: {
//                            fileSelected = items.songid
//                            print(audioFileNames[fileSelected])
//                        }){
//                            Text(audioFilePrettyNames[items.songid])
//                                .font(.title)
//                                .fontWeight(.bold)
//                        }
//                        .buttonStyle(MyButtonStyle2())
//                    }
                    ForEach(audioFiles) { file in
                        Button (action: {
                            fileSelected = file.songid
                            //print(audioFiles[fileSelected])
                        }) {
                            Text(file.fileName)
                        }
                    }
                    
//                    Button(action: {
//                        fileSelected = 0
//                        print(audioFileNames[fileSelected])
//                    }){
//                        Text(audioFilePrettyNames[0])
//                            .font(.title)
//                            .fontWeight(.bold)
//                    }
//                    .buttonStyle(MyButtonStyle2())
//
//                    Button(action: {
//                        fileSelected = 1
//                        print(audioFileNames[fileSelected])
//                    }){
//                        Text(audioFilePrettyNames[1])
//                            .font(.title)
//                            .fontWeight(.bold)
//                    }
//                    .buttonStyle(MyButtonStyle2())
//
//                    Button(action: {
//                        fileSelected = 2
//                        print(audioFileNames[fileSelected])
//                    }){
//                        Text(audioFilePrettyNames[2])
//                            .font(.title)
//                            .fontWeight(.bold)
//                    }
//                    .buttonStyle(MyButtonStyle2())

                    
                        
                        
//                        for i 1...3{
//                            Button(label: audioFilePrettyNames[i], action:{
//                                loadFiles(fileName: audioFileNames[i])
//                            })
    //                    ForEach(audioFilePrettyNames[i[], id: \.self) { (audioFiles: String) in
    //                        VStack {
    //                           Button(action: { print("Button at \(audioFiles)") }) {
    //                               Text(audioFiles)
    //                           }
    //                           .buttonStyle(MyButtonStyle2())

                       
                   
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

//struct AudioFIleMenu_Previews: PreviewProvider {
//    static var previews: some View {
//        AudioFIleMenu()
//            .previewInterfaceOrientation(.landscapeLeft)
//
//    }
//}
