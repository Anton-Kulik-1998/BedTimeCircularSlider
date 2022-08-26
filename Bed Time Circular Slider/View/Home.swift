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
            
            Button {
                //
            } label: {
                Text("Start Sleep")
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .padding(.horizontal, 40)
                    .background(Color("Blue"), in: Capsule())
            }
            .padding(.top, 45)
            
            HStack(spacing: 25) {
                VStack(alignment: .leading, spacing: 8) {
                    Label {
                        Text("Bedtime")
                            .foregroundColor(.black)
                    } icon: {
                        Image(systemName: "moon.fill")
                            .foregroundColor(Color("Blue"))
                    }
                    .font(.callout)
                    
                    Text(getTime(angle: startAngle).formatted(date: .omitted, time: .shortened))
                        .font(.title2.bold())

                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                VStack(alignment: .leading, spacing: 8) {
                    Label {
                        Text("Wakeup")
                            .foregroundColor(.black)
                    } icon: {
                        Image(systemName: "alarm")
                            .foregroundColor(Color("Blue"))
                    }
                    .font(.callout)
                    
                    Text(getTime(angle: toAngle).formatted(date: .omitted, time: .shortened))
                        .font(.title2.bold())

                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                
            }
            .padding()
            .background(.black.opacity(0.06), in: RoundedRectangle(cornerRadius: 15))
            .padding(.top, 35)


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
                
                //MARK: Clock Design
                ZStack {
                    ForEach(1...60, id: \.self) {index in
                        Rectangle()
                            .fill(index % 5 == 0 ? .black : .gray)
                        //Each hour will have big line
                        //60/5 = 12
                            .frame(width: 2, height: index % 5 == 0 ? 10 : 5)
                        //Setting into entire Circle
                            .offset(y: (width - 60) / 2)
                            .rotationEffect(.init(degrees: Double(index) * 6))
                        
                    }
                    
                    //MARK: Clock Text
                    let texts = [6,9,12,3]
                    ForEach(texts.indices, id: \.self) {index in
                        Text("\(texts[index])")
                            .font(.caption.bold())
                            .foregroundColor(.black)
                            .rotationEffect(.init(degrees: Double(index) * -90))
                            .offset(y: (width - 90) / 2)
                            .rotationEffect(.init(degrees: Double(index) * 90))
                        
                    }
                }
                
                Circle()
                    .stroke(.black.opacity(0.06), lineWidth: 40)
                
                //Allowing reverse swiping
                let reverseRotation = (startProgress > toProgress) ? -Double((1 - startProgress) * 360) : 0
                Circle()
                    .trim(from: startProgress > toProgress ? 0 : startProgress, to: toProgress + (-reverseRotation / 360))
                    .stroke(Color("Blue"), style: StrokeStyle(lineWidth: 40, lineCap: .round, lineJoin: .round))
                    .rotationEffect(.init(degrees: -90))
                    .rotationEffect(.init(degrees: reverseRotation))
                
                //Slider Buttons
                Image(systemName: "moon.fill")
                    .font(.callout)
                    .foregroundColor(Color("Blue"))
                    .frame(width: 30, height: 30)
                    .rotationEffect(.init(degrees: 90))
                    .rotationEffect(.init(degrees: -startAngle))
                    .background(.white, in: Circle())
                //Moving to rigth & Rotating
                    .offset(x: width / 2)
                    .rotationEffect(.init(degrees: startAngle))
                    .gesture(
                        DragGesture()
                            .onChanged({value in
                                onDrag(value: value, fromSlider: true)
                            })
                    )
                    .rotationEffect(.init(degrees: -90))
                
                
                Image(systemName: "alarm")
                    .font(.callout)
                    .foregroundColor(Color("Blue"))
                    .frame(width: 30, height: 30)
                //Rotating Image inside the circle
                    .rotationEffect(.init(degrees: 90))
                    .rotationEffect(.init(degrees: -toAngle))
                    .background(.white, in: Circle())
                //Moving to rigth & Rotating
                    .offset(x: width / 2)
                    .rotationEffect(.init(degrees: toAngle))
                    .gesture(
                        DragGesture()
                            .onChanged({value in
                                onDrag(value: value)
                            })
                    )
                    .rotationEffect(.init(degrees: -90))
                
                //MARK: Hour Text
                VStack(spacing: 6) {
                    Text("\(getTimeDifference().0)hr")
                        .font(.largeTitle.bold())
                    Text("\(getTimeDifference().1)min")
                        .foregroundColor(.gray)
                }
                .scaleEffect(1.1)
            }
        }
        .frame(width: screenBounds().width / 1.6, height: screenBounds().width / 1.6)
    }
    
    func onDrag(value: DragGesture.Value, fromSlider: Bool = false) {
        //MARK: Converting Translation into Angle
        let vector = CGVector(dx: value.location.x, dy: value.location.y)
        
        //Removing the button radius
        //Button diameter = 30
        //Radious = 15
        let radians = atan2(vector.dy - 15, vector.dx - 15)
        //Convering into Angle
        var angle = radians * 180 / .pi
        if angle < 0 {angle = 360 + angle}
        
        let progress = angle / 360
        if fromSlider{
            //Update from values
            self.startAngle = angle
            self.startProgress = progress
        }
        else {
            //Update to values
            self.toAngle = angle
            self.toProgress = progress
        }
    }
    
    //MARK: Returning time based on drag
    func getTime(angle: Double) -> Date {
        
        //360 / 12 = 30
        //12 = Hours
        let progress = angle / 30
        
        //It will be 6.05
        //6 is hour
        //0.5 is minutes
        let hour = Int(progress)
        //0.1 = 5 min
        let remainder = (progress.truncatingRemainder(dividingBy: 1) * 12).rounded()
        
        var minute = remainder * 5
        //This is because minutes are returning 60 (12*5)
        //avoiding that to get perfect time
        minute = (minute > 55 ? 55 : minute)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm:ss"
        
        if let date = formatter.date(from: "\(hour):\(Int(remainder)):00") {
            return date
        }
        return .init()
    }
    
    func getTimeDifference() -> (Int, Int) {
        let calendar = Calendar.current
        let result = calendar.dateComponents([.hour, .minute], from: getTime(angle: startAngle), to: getTime(angle: toAngle))
        return (result.hour ?? 0,result.minute ?? 0)
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
