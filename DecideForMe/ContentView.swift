//
//  ContentView.swift
//  DecideForMe
//
//  Created by Sikun Chen on 2025-07-15.
//

import SwiftUI

struct ContentView: View {
    @State private var navigationPath = NavigationPath()
    @State private var isAnimating = false
    @State private var selectedButton: String?
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.white, Color.orange.opacity(0.1)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    // Logo and App Title
                    VStack(spacing: 16) {
                        LogoView()
                            .scaleEffect(isAnimating ? 1.1 : 1.0)
                            .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: isAnimating)
                        
                        Text("DecideForMe")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.black)
                        
                        Text("Let us help you decide")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundColor(.orange)
                            .opacity(0.8)
                    }
                    .padding(.top, 40)
                    
                    // Feature Buttons
                    VStack(spacing: 24) {
                        HStack(spacing: 24) {
                            FeatureButton(
                                title: "item",
                                icon: "gear",
                                description: "Custom your own",
                                isSelected: selectedButton == "delivery"
                            ) {
                                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                    selectedButton = "delivery"
                                    navigationPath.append("delivery")
                                }
                            }
                            
                            FeatureButton(
                                title: "map",
                                icon: "map",
                                description: "Places & Locations",
                                isSelected: selectedButton == "map"
                            ) {
                                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                    selectedButton = "map"
                                    navigationPath.append("map")
                                }
                            }
                        }
                        
                        FeatureButton(
                            title: "image",
                            icon: "photo",
                            description: "Visual Decisions",
                            isSelected: selectedButton == "image"
                        ) {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                selectedButton = "image"
                                navigationPath.append("image")
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // Footer
                    Text("Tap any feature to get started")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(.gray)
                        .padding(.bottom, 20)
                }
                .padding()
            }
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(for: String.self) { route in
                switch route {
                case "delivery":
                    DeliveryDecisionView()
                case "map":
                    MapDecisionView()
                case "image":
                    ImageMarkView()
                default:
                    EmptyView()
                }
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

struct LogoView: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.orange)
                .frame(width: 80, height: 80)
                .shadow(color: .orange.opacity(0.3), radius: 10, x: 0, y: 5)
            
            Image(systemName: "dice.fill")
                .font(.system(size: 40))
                .foregroundColor(.white)
        }
    }
}

struct FeatureButton: View {
    let title: String
    let icon: String
    let description: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 28, weight: .medium))
                    .foregroundColor(isSelected ? .white : .orange)
                
                Text(title.capitalized)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(isSelected ? .white : .black)
                
                Text(description)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(isSelected ? .white.opacity(0.9) : .gray)
                    .multilineTextAlignment(.center)
            }
            .frame(width: 140, height: 120)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? Color.orange : Color.white)
                    .shadow(color: isSelected ? .orange.opacity(0.4) : .black.opacity(0.1), radius: 8, x: 0, y: 4)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.orange, lineWidth: isSelected ? 0 : 2)
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ContentView()
}
