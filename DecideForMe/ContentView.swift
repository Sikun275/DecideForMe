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
                AppTheme.Colors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    // Logo and App Title
                    VStack(spacing: 16) {
                        LogoView()
                            .scaleEffect(isAnimating ? 1.1 : 1.0)
                            .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: isAnimating)
                        
                        Text("DecideForMe")
                            .font(AppTheme.Fonts.title)
                            .foregroundColor(AppTheme.Colors.textPrimary)
                        
                        Text("'idk lol' isn't a strategy")
                            .font(AppTheme.Fonts.subtitle)
                            .foregroundColor(AppTheme.Colors.primary)
                            .opacity(0.8)
                            .multilineTextAlignment(.center)
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
                    Text("Tap any button to get started :)")
                        .font(AppTheme.Fonts.body)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                        .padding(.bottom, AppTheme.Spacing.xl)
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
                .fill(AppTheme.Colors.primary)
                .frame(width: 80, height: 80)
                .applyShadow(AppTheme.Shadows.logo)
            
            Image(systemName: "dice.fill")
                .font(.system(size: 40))
                .foregroundColor(AppTheme.Colors.textOnPrimary)
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
            VStack(spacing: AppTheme.Spacing.md) {
                Image(systemName: icon)
                    .font(.system(size: 28, weight: .medium))
                    .foregroundColor(isSelected ? AppTheme.Colors.textOnPrimary : AppTheme.Colors.primary)
                
                Text(title.capitalized)
                    .font(AppTheme.Fonts.headline)
                    .foregroundColor(isSelected ? AppTheme.Colors.textOnPrimary : AppTheme.Colors.textPrimary)
                
                Text(description)
                    .font(AppTheme.Fonts.caption)
                    .foregroundColor(isSelected ? AppTheme.Colors.textOnPrimary.opacity(0.9) : AppTheme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .frame(width: 140, height: 120)
        }
        .featureButton(isSelected: isSelected)
    }
}

#Preview {
    ContentView()
}
