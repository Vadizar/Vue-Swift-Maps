//
//  BottomSheetMapView.swift
//  MapsBottomSheet
//

import SwiftUI

enum SheetPosition {
    case collapsed
    case middle
    case expanded
    
    func offsetY(screenHeight: CGFloat, collapsedHeight: CGFloat) -> CGFloat {
        switch self {
        case .collapsed:
            return screenHeight - collapsedHeight
        case .middle:
            return screenHeight * 0.5
        case .expanded:
            return 60
        }
    }
}

struct BottomSheetMapView: View {
    @State private var currentOffset: CGFloat = 0
    @State private var lastOffset: CGFloat = 0
    @State private var currentPosition: SheetPosition = .collapsed
    
    private let collapsedHeight: CGFloat = 120
    
    var body: some View {
        GeometryReader { geometry in
            let screenHeight = geometry.size.height
            
            ZStack(alignment: .top) {
                // Map Background
                MapPlaceholderView()
                
                // Floating Buttons (below sheet)
                FloatingButtonsView(
                    currentOffset: currentOffset,
                    screenHeight: screenHeight
                )
                
                // Bottom Sheet (on top, covers buttons)
                BottomSheetView(currentPosition: currentPosition)
                    .offset(y: currentOffset)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                handleDragChanged(
                                    value: value,
                                    screenHeight: screenHeight
                                )
                            }
                            .onEnded { value in
                                handleDragEnded(
                                    value: value,
                                    screenHeight: screenHeight
                                )
                            }
                    )
            }
            .onAppear {
                // Set initial position
                currentOffset = SheetPosition.collapsed.offsetY(
                    screenHeight: screenHeight,
                    collapsedHeight: collapsedHeight
                )
                lastOffset = currentOffset
            }
            .onChange(of: geometry.size) { _, newSize in
                // Update offset on rotation/resize
                currentOffset = currentPosition.offsetY(
                    screenHeight: newSize.height,
                    collapsedHeight: collapsedHeight
                )
                lastOffset = currentOffset
            }
        }
        .statusBarHidden(false)
    }
    
    private func handleDragChanged(value: DragGesture.Value, screenHeight: CGFloat) {
        let translation = value.translation.height
        let newOffset = lastOffset + translation
        
        // Constrain between min and max
        let minOffset: CGFloat = 60
        let maxOffset = screenHeight - collapsedHeight
        
        currentOffset = max(minOffset, min(maxOffset, newOffset))
    }
    
    private func handleDragEnded(value: DragGesture.Value, screenHeight: CGFloat) {
        let velocity = value.predictedEndLocation.y - value.location.y
        
        let expandedOffset = SheetPosition.expanded.offsetY(
            screenHeight: screenHeight,
            collapsedHeight: collapsedHeight
        )
        let middleOffset = SheetPosition.middle.offsetY(
            screenHeight: screenHeight,
            collapsedHeight: collapsedHeight
        )
        let collapsedOffset = SheetPosition.collapsed.offsetY(
            screenHeight: screenHeight,
            collapsedHeight: collapsedHeight
        )
        
        var targetPosition: SheetPosition
        
        // Strong velocity - immediate decision
        if abs(velocity) > 200 {
            if velocity < 0 {
                // Fast swipe up
                targetPosition = currentOffset > middleOffset ? .middle : .expanded
            } else {
                // Fast swipe down
                targetPosition = currentOffset < middleOffset ? .middle : .collapsed
            }
        } else {
            // Snap to nearest
            let distances: [(SheetPosition, CGFloat)] = [
                (.expanded, abs(currentOffset - expandedOffset)),
                (.middle, abs(currentOffset - middleOffset)),
                (.collapsed, abs(currentOffset - collapsedOffset))
            ]
            
            targetPosition = distances.min(by: { $0.1 < $1.1 })?.0 ?? .collapsed
        }
        
        let targetOffset = targetPosition.offsetY(
            screenHeight: screenHeight,
            collapsedHeight: collapsedHeight
        )
        
        withAnimation(.spring(response: 0.4, dampingFraction: 0.825)) {
            currentPosition = targetPosition
            currentOffset = targetOffset
        }
        
        lastOffset = targetOffset
    }
}

// MARK: - Map Placeholder

struct MapPlaceholderView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.498, green: 0.690, blue: 0.412),  // #7FB069
                    Color(red: 0.722, green: 0.831, blue: 0.745),  // #B8D4BE
                    Color(red: 0.616, green: 0.765, blue: 0.902),  // #9DC3E6
                    Color(red: 0.357, green: 0.608, blue: 0.835)   // #5B9BD5
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            Text("iOS Maps")
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.white.opacity(0.5))
        }
        .ignoresSafeArea()
    }
}

// MARK: - Floating Buttons

struct FloatingButtonsView: View {
    let currentOffset: CGFloat
    let screenHeight: CGFloat
    
    var body: some View {
        VStack(spacing: 12) {
            FloatingButton(icon: "binoculars.fill")
            FloatingButton(text: "3D")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        .padding(.trailing, 16)
        .padding(.bottom, 140)
        .offset(y: buttonOffset)
    }
    
    private var buttonOffset: CGFloat {
        let collapsedHeight: CGFloat = 120
        let collapsedOffset = screenHeight - collapsedHeight
        let middleOffset = screenHeight * 0.5
        
        // Calculate how much sheet has moved from collapsed position
        let movement = collapsedOffset - currentOffset
        
        // Maximum movement (from collapsed to middle)
        let maxMovement = collapsedOffset - middleOffset
        
        // Limit movement to maxMovement
        let actualMovement = min(movement, maxMovement)
        
        return -actualMovement
    }
}

struct FloatingButton: View {
    var icon: String?
    var text: String?
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: 48, height: 48)
                .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 2)
            
            if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.blue)
            } else if let text = text {
                Text(text)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.blue)
            }
        }
    }
}

// MARK: - Bottom Sheet

struct BottomSheetView: View {
    let currentPosition: SheetPosition
    
    var body: some View {
        VStack(spacing: 0) {
            // Handle
            VStack {
                Capsule()
                    .fill(Color(white: 0.78))
                    .frame(width: 36, height: 5)
                    .padding(.top, 12)
                    .padding(.bottom, 12)
            }
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
            
            // Content
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Bottom Sheet")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.black)
                    
                    Text("Drag up or down")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                        .padding(.bottom, 16)
                    
                    HStack {
                        Spacer()
                        VStack(spacing: 4) {
                            Text("Current position:")
                                .font(.system(size: 13))
                                .foregroundColor(.secondary)
                            Text(positionName)
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.blue)
                        }
                        Spacer()
                    }
                    .padding()
                    .background(Color(white: 0.95))
                    .cornerRadius(12)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
            .simultaneousGesture(
                // Allow scrolling when sheet is expanded
                DragGesture().onChanged { _ in }
            )
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -2)
    }
    
    private var positionName: String {
        switch currentPosition {
        case .collapsed:
            return "Collapsed"
        case .middle:
            return "Middle (50%)"
        case .expanded:
            return "Expanded"
        }
    }
}

#Preview {
    BottomSheetMapView()
}
