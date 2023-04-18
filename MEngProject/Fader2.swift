//
//  Fader2.swift
//  MEngProject
//
//  Created by Alice Milburn on 02/03/2023.
//

import SwiftUI
import AudioKit

struct Fader2: View {
    var body: some View {
        Home2()
            .environmentObject(PlayBackClass())
    }
}

struct Fader2_Previews: PreviewProvider {
    static var previews: some View {
        Fader2()
            .environmentObject(PlayBackClass())
    }
}
struct Home2: View {
    @EnvironmentObject var playbackClass: PlayBackClass
    
    @State var maxHeight: CGFloat = ((UIScreen.main.bounds.height * 2)/3) - 20
    
    //slider properties
    @State var sliderProgress: CGFloat = 0
    @State var sliderHeight: CGFloat = 0
    @State var lastDragValue: CGFloat = 0
    
    var body: some View{
        
        VStack{
            //Slider
            ZStack(alignment: .bottom, content: {
                
                Rectangle()
                    .fill(CustomPaleBlue)
                
                Rectangle()
                    .fill(CustomPurple)
                    .frame(height: sliderHeight)
                    .cornerRadius(49)
            })
            .frame(height: maxHeight, alignment: .center)
            .cornerRadius(50)
            .overlay(
                Text("\(Int(sliderProgress * 100))%")
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .padding(.vertical,10)
                    .padding(.horizontal,18)
                    .background(Color.white)
                    .cornerRadius(20)
                    .padding(.vertical, 30)
                    .offset(y: sliderHeight < maxHeight - 105 ? -sliderHeight : -maxHeight + 105)
                ,alignment: .bottom
            )
            
            .gesture(DragGesture(minimumDistance: 0).onChanged({ (value) in
                //getting drag value
                let translation = value.translation
                sliderHeight = -translation.height + lastDragValue
                
                //limiting slider heigh value
                sliderHeight = sliderHeight > maxHeight ? maxHeight : sliderHeight
                
                sliderHeight = sliderHeight >= 0 ? sliderHeight : 0
                
                //updating progress
                let progress = sliderHeight / maxHeight
                
                sliderProgress = progress <= 1.0 ? progress : 1
                //                print("slider 2 progress \(sliderProgress)")
                
                //                fader2global = sliderProgress
                
                
                DispatchQueue.main.async {
                    playbackClass.audio.volume = AUValue(sliderProgress)
                }
//                self.playbackClass.audio.volume = AUValue(sliderProgress)
//                DispatchQueue.main.async {
//                    let newAudioPlayer = AudioPlayer()
//                    newAudioPlayer.volume = AUValue(sliderProgress)
//                    PlayBackClass.audio = newAudioPlayer
//                    PlayBackClass.objectWillChange.send()
//                }
//                fader2value.audio.volume = AUValue(sliderProgress)
                print("volume again: \(playbackClass.audio.volume)")
                //                print("fader 2 global \(fader2global)")
                
                
            }).onEnded({(value) in
                //storing last drag value for restoration
                
                sliderHeight = sliderHeight > maxHeight ? maxHeight : sliderHeight
                
                //Negative height
                sliderHeight = sliderHeight >= 0 ? sliderHeight : 0
                
                lastDragValue = sliderHeight
                
            }))
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
        
    }
}
