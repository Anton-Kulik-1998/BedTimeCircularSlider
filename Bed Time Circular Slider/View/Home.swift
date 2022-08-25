//
//  Home.swift
//  Bed Time Circular Slider
//
//  Created by Антон Кулик on 25.08.2022.
//

import SwiftUI

struct Home: View {
    
    //MARK Properties
    @State var startAngle: Double = 0
    //Since our to progress is 0.5
    // 0.5 * 360 = 180
    @State var toAngle: Double = 180
    
    @State var startProgress: CGFloat = 0
    @State var toProgress: CGFloat = 0.5
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Today")
                        .font(.title.bold())
                    Text("Good Morning! Anton")
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Button {
                    //
                } label: {
                    Image("Pic")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 45, height: 45)
                        .clipShape(Circle())
                }

            }
            SleepTimeSlider()
                .padding(.top, 50)
        }
        .padding()
        //Moving To Top Without Spacer
        .frame(maxHeight: .infinity,alignment: .top)
    }
    
    //MARK: Sleep Timer Circular Slider
    @ViewBuilder
    func SleepTimeSlider() -> some View {
        
        GeometryReader {proxy in
            
            let width = proxy.size.width
            
            ZStack {
                
                
                
                
                
                Circle()
                    .stroke(.black.opacity(0.06), lineWidth: 40)
                
                Circle()
                    .trim(from: startProgress, to: toProgress)
                    .stroke(Color("Blue"), style: StrokeStyle(lineWidth: 40, lineCap: .round, lineJoin: .round))
                    .rotationEffect(.init(degrees: -90))
                
                //Slider Buttons
                Image(systemName: "moon.fill")
                    .font(.callout)
                    .foregroundColor(Color("Blue"))
                    .frame(width: 30, height: 30)
                    .rotationEffect(.init(degrees: 90))
                    .rotationEffect(.init(degrees: startAngle))
                    .background(.white, in: Circle())
                //Moving to rigth & Rotating
                    .offset(x: width / 2)
                    .rotationEffect(.init(degrees: -90))
                    .rotationEffect(.init(degrees: startAngle))
                
                
                Image(systemName: "alarm")
                    .font(.callout)
                    .foregroundColor(Color("Blue"))
                    .frame(width: 30, height: 30)
                //Rotating Image inside the circle
                    .rotationEffect(.init(degrees: 90))
                    .rotationEffect(.init(degrees: toAngle))
                    .background(.white, in: Circle())
                //Moving to rigth & Rotating
                    .offset(x: width / 2)
                    .rotationEffect(.init(degrees: -90))
                    .rotationEffect(.init(degrees: toAngle))
            }
        }
        .frame(width: screenBounds().width / 1.6, height: screenBounds().height / 1.6)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

//MARK: Extensions
extension View {
    //MARK: Screen Bounds Extension
    func screenBounds() -> CGRect{
        return UIScreen.main.bounds
    }
}
