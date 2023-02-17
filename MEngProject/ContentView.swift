//
//  ContentView.swift
//  MEngProject
//
//  Created by Alice Milburn on 17/02/2023.
//

import SwiftUI
import Controls

struct ContentView: View {
    @State var sliderValue: Float = 0
    @State var volValue: Float = 0
    @State var revValue: Float = 0

    var body: some View {
        VStack {

            VStack(alignment: .center, spacing: 15) {
                VStack(alignment: .center){
                    HStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 50)
                                .fill(Color.gray)
                        
                            
                        }
                        RoundedRectangle(cornerRadius: 50)
                            .fill(Color.gray)
                     
                        RoundedRectangle(cornerRadius: 50)
                            .fill(Color.gray)
                       
            
                    }
                    HStack {
                        ModWheel(value: $sliderValue)
                            .cornerRadius(50)
                            .foregroundColor(Color.black)
                            .indicatorHeight(150)
                            
                        VStack{
                            HStack {
                                ArcKnob("Vol", value: $volValue)
                                    .foregroundColor(Color.black)
                                  
                                ArcKnob("Reverb", value: $revValue)
                                    .foregroundColor(Color.black)
                                    
                                
                            }
                            RoundedRectangle(cornerRadius: 50)
                                .fill(Color.gray)
                                
                        }
                        
                        
                    }

                }
            }
        }

        

        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
