//
//  AudioFilePlayBack.swift
//  MEngProject
//
//  Created by Alice Milburn on 03/03/2023.
//

import SwiftUI

struct AudioFilePlayBack: View {
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 50)
                .fill(Color.gray)
            VStack{
                HStack{
                    Button(action: {
                        print("backward")
                    }) {
                        Image(systemName: "chevron.backward.circle")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color.black)
                            .padding(10)
                    }
                    Button(action: {
                        print("Play")
                    }) {
                        Image(systemName: "play.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color.black)
                            .padding(10)
                    }
                    Button(action: {
                        print("foreward")
                    }) {
                        Image(systemName: "chevron.forward.circle")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color.black)
                            .padding(10)
                    }
                }
                .padding(.top, 10)
                Button(action: {print("Audio File Menu")
                    
                }){
                    ZStack{
                        RoundedRectangle(cornerRadius: 50)
                            .padding(30)
                            .foregroundColor(.black)
                        Text("Audio file 1")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                    }
                }
                
                
            }
        }
    }
}

struct AudioFilePlayBack_Previews: PreviewProvider {
    static var previews: some View {
        AudioFilePlayBack()
    }
}
