//
//  ContentView.swift
//  OneTouch
//
//  Created by Cedric Bahirwe on 10/6/20.
//  Copyright © 2020 Cedric Bahirwe. All rights reserved.
//
import SwiftUI

enum Colors: Int {
    case blue = 1
    case yellow
    case green
    case red
}

struct ContentView: View {
    static let offWhite = Color(red: 225 / 255, green: 225 / 255, blue: 235 / 255)
    
    
    @State private var score = 0
    @State private var bestScore = 0
    @State private var offSet = CGSize.zero
    @State private var timer = Timer.publish(every: 0.085, on: .main, in: .common).autoconnect()
    @State private var rotationAngle = 0.0
    @State private var showAlert = false
    @State private var ballColor = Color.yellow
    @State private var speed = 10
    @State private var colors: [Color] = [.blue, .red, .green, .yellow]
    @State private var topIndex = 0
    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack {
                    Circle()
                        .fill(self.ballColor)
                        .frame(width: 60, height: 60)
                        .shadow(color: Self.offWhite, radius: 5)
                        .offset(y: -85)
                        .offset(self.offSet)
                        .opacity(self.offSet == .zero ? 0 : 1)
                        .zIndex(10)
                    
                    Spacer()
                    
                    ZStack {
                        ZStack(alignment: .bottom) {
                            Spacer()
                            
                        }
                        .overlay(
                            VStack {
                                Triangle()
                                    .fill(Color.red)
                                    .frame(width: geo.size.height/3, height: geo.size.height/3/2)
                                
                            }
                            .frame(width: geo.size.height/3, height: geo.size.height/3, alignment: .bottom)
                            .rotationEffect(.degrees(90))
                        )
                            
                            .overlay(
                                VStack {
                                    Triangle()
                                        .fill(Color.green)
                                        .frame(width: geo.size.height/3, height: geo.size.height/3/2)
                                    
                                }
                                .frame(width: geo.size.height/3, height: geo.size.height/3, alignment: .bottom)
                                .rotationEffect(.degrees(0))
                        )
                            
                            .overlay(
                                VStack {
                                    Triangle()
                                        .fill(Color.blue)
                                        .frame(width: geo.size.height/3, height: geo.size.height/3/2)
                                    
                                }
                                .frame(width: geo.size.height/3, height: geo.size.height/3, alignment: .bottom)
                                .rotationEffect(.degrees(180))
                        )
                            
                            .overlay(
                                VStack {
                                    Triangle()
                                        .fill(Color.yellow)
                                        .frame(width: geo.size.height/3, height: geo.size.height/3/2)
                                    
                                }
                                .frame(width: geo.size.height/3, height: geo.size.height/3, alignment: .bottom)
                                .rotationEffect(.degrees(-90))
                        )
                        
                    }
                    .frame(width: geo.size.height/3, height: geo.size.height/3)
                    .rotationEffect(.degrees(self.rotationAngle))
                    .onTapGesture {
                        if self.topIndex < self.colors.count-1 {
                            self.topIndex += 1
                        } else {
                            self.topIndex = 0
                        }
                        withAnimation {
                            self.rotationAngle += 90.0
                        }
                    }
                    
                    
                }
                .frame(width: geo.size.width, height: geo.size.height)
                    
                .background(Color.black.edgesIgnoringSafeArea([.top, .bottom]))
                .alert(isPresented: self.$showAlert) {
                    Alert(title: Text("You Failed"), message: Text("Try again to go over your best score"), dismissButton: .cancel(Text("Try again"), action: {
                        self.timer =  Timer.publish (every: 0.05, on: .current, in:
                            .common).autoconnect()
                    }))
                }
                .onReceive(self.timer) { value in
                    
                    if (0...100).contains(self.score) {
                         self.speed = 30
                    } else if (101...250).contains(self.score) {
                        self.speed = 50
                    } else if (251...350).contains(self.score) {
                         self.speed = 35
                    } else if (351...).contains(self.score)  {
                        self.speed = 70
                    }
                    
                    withAnimation(.spring(response: 0.5,dampingFraction: 0.7,blendDuration: 0.5)) {
                        if self.offSet.height >= ((2 * geo.size.height/3) - 40 + 80) {
                            self.timer.upstream.connect().cancel()
                            
                            
                            if self.colors[self.topIndex] == self.ballColor {
                                self.score += 10
                                self.offSet = .zero
                                self.ballColor = self.colors.randomElement()!
                                self.timer = Timer.publish (every: 0.1, on: .current, in:
                                    .common).autoconnect()
                                
                            } else {
                                self.score = 0
                                self.offSet = .zero
                                self.ballColor = self.colors.randomElement()!
                                self.showAlert = true
                            }
                            self.bestScore = self.score > self.bestScore ? self.score : self.bestScore
                        } else {
                            self.offSet.height += CGFloat(self.speed)
                        }
                    }
                }
                
                VStack {
                    HStack {
                        Text("Score: ")
                            .font(.system(size: 14, weight: .regular, design: .monospaced))
                            + Text(self.score.description)
                        Spacer()
                        Text("Best: ").font(.system(size: 14, weight: .regular, design: .monospaced))
                            + Text(self.bestScore.description)
                    }
                    .foregroundColor(Color.white)
                    .padding(.horizontal)
                    .padding(.top, 5)
                    .offset(y: -10)
                    Spacer()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        
        return path
    }
}
