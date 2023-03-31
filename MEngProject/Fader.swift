//
//  Fader.swift
//  MEngProject
//
//  Created by Alice Milburn on 18/02/2023.
//

import SwiftUI

struct Fader: View {
    var body: some View {
        Home()
    }
}

struct Fader_Previews: PreviewProvider {
    static var previews: some View {
        Fader()
    }
}

struct Home: View {
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
                    .fill(Color.green).opacity((0.30))
                    
                Rectangle()
                    .fill(Color.orange)
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
//                print("slider 1 progress \(sliderProgress)")
                fader1global = sliderProgress
//                print("fader 1 global \(fader1global)")
                
            }).onEnded({(value) in
                //storing last drag value for restoration
                
                sliderHeight = sliderHeight > maxHeight ? maxHeight : sliderHeight
                
                //Negative height
                sliderHeight = sliderHeight >= 0 ? sliderHeight : 0
                
                lastDragValue = sliderHeight
                //fader1global = lastDragValue
            }))

            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)

        
    }
}
