//
//  ContentView.swift
//  DecideForMe
//
//  Created by Sikun Chen on 2025-07-15.
//

import SwiftUI

struct ContentView: View {
    @State private var selection: String? = nil
    
    var body: some View {
        NavigationView {
            VStack(spacing: 32) {
                HStack(spacing: 24) {
                    Spacer()
                    MinimalButton(title: "delivery", isSelected: selection == "delivery") { selection = "delivery" }
                        .frame(width: 140)
                    MinimalButton(title: "map", isSelected: selection == "map") { selection = "map" }
                        .frame(width: 140)
                    Spacer()
                }
                HStack {
                    Spacer()
                    MinimalButton(title: "image", isSelected: selection == "image") { selection = "image" }
                        .frame(width: 140)
                    Spacer()
                }
                NavigationLink(destination: DeliveryDecisionView(),
                               tag: "delivery",
                               selection: $selection) { EmptyView() }
                NavigationLink(destination: MapDecisionView(),
                               tag: "map",
                               selection: $selection) { EmptyView() }
                NavigationLink(destination: ImageMarkView(),
                               tag: "image",
                               selection: $selection) { EmptyView() }
            }
            .padding()
            .background(Color.white)
            .navigationBarHidden(true)
        }
    }
}

struct MinimalButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(title.capitalized)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(isSelected ? .white : .black)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(isSelected ? Color.blue : Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.blue, lineWidth: isSelected ? 0 : 2)
                )
                .cornerRadius(16)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ContentView()
}
