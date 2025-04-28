import SwiftUI
import AVFoundation

struct CustomTransitionBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.blue.opacity(0.15),
                    Color(UIColor.systemBackground).opacity(0.95),
                    Color(UIColor.systemBackground)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.blue.opacity(0.2),
                                Color.black.opacity(0.05)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 320, height: 320)
                    .blur(radius: 60)
                    .offset(y: -100)
                
                // Animated ripples (Multiple circles)
                ForEach(0..<3) { index in
                    Circle()
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.blue.opacity(0.3),
                                    Color.blue.opacity(0.1)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: 2
                        )
                        .frame(width: 200 + CGFloat(index * 50))
                        .blur(radius: 3)
                        .offset(y: -100)
                }
            }
            .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: UUID())
        }
    }
}

struct GoalInputView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var dailyGoal: Int
    @State private var inputValue: String = ""
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Set Daily Goal")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.primary)
            
            TextField("Enter amount in oz", text: $inputValue)
                .keyboardType(.numberPad)
                .font(.system(size: 32, weight: .medium))
                .multilineTextAlignment(.center)
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
            
            HStack(spacing: 16) {
                Button("Cancel") {
                    dismiss()
                }
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(12)
                
                Button("Set") {
                    if let value = Int(inputValue), value > 0 {
                        dailyGoal = value
                        dismiss()
                    }
                }
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.blue)
                .cornerRadius(12)
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 24)
        .background(Color(UIColor.systemBackground))
    }
}

struct WaterTrackerView: View {
    @AppStorage("dailyGoal") private var dailyGoal: Int = 128 // Default to 128 oz
    @AppStorage("currentIntake") private var currentIntake: Int = 0
    @AppStorage("addWaterAmount") private var addWaterAmount: Int = 8 // Store the water fill amount
    
    // Separate sheet states for each type
    @State private var showingGoalOptions: Bool = false
    @State private var showingQuickSet: Bool = false
    @State private var showingCalculator: Bool = false
    @State private var showingFillAmount: Bool = false
    
    @State private var inputValue: String = ""
    @State private var userName: String = ""
    @State private var hasAppeared: Bool = false
    
    private var fillPercentage: CGFloat {
        return min(CGFloat(currentIntake) / CGFloat(dailyGoal), 1.0)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                CustomTransitionBackground()
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Goal Button at Top
                        Button(action: {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                                showingGoalOptions = true
                            }
                        }) {
                            HStack {
                                Image(systemName: "target")
                                    .font(.system(size: 20, weight: .medium))
                                Text("Set Goal")
                                    .font(.system(size: 16, weight: .medium))
                            }
                            .foregroundColor(.primary)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(20)
                        }
                        .padding(.top, 16)
                        .padding(.bottom, 24)
                        
                        // Welcome Section
                        VStack(spacing: 6) {
                            Text("Stay Hydrated")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.primary)
                            
                            Text("Keep your body refreshed and energized")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.bottom, 24)
                        
                        ZStack {
                            // Water Splash Effect
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color.blue.opacity(0.2),
                                                Color.blue.opacity(0.05)
                                            ]),
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                    .frame(width: 300, height: 300)
                                    .blur(radius: 15)
                                    .offset(y: -10)
                                    .shadow(color: Color.blue.opacity(0.1), radius: 20, x: 0, y: 10)
                                
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color.blue.opacity(0.15),
                                                Color.black.opacity(0.02)
                                            ]),
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                    .frame(width: 240, height: 240)
                                    .blur(radius: 8)
                                    .offset(y: -5)
                                
                                ForEach(0..<3) { index in
                                    Circle()
                                        .stroke(
                                            LinearGradient(
                                                gradient: Gradient(colors: [
                                                    Color.blue.opacity(0.3 - Double(index) * 0.05),
                                                    Color.blue.opacity(0.1 - Double(index) * 0.02)
                                                ]),
                                                startPoint: .top,
                                                endPoint: .bottom
                                            ),
                                            lineWidth: 2
                                        )
                                        .frame(width: 200 + CGFloat(index * 25))
                                        .blur(radius: 2)
                                }
                            }
                            .offset(y: fillPercentage * -20)
                            .animation(
                                .easeInOut(duration: 3)
                                .repeatForever(autoreverses: true)
                                .delay(Double.random(in: 0...1)),
                                value: fillPercentage
                            )
                            
                            // Water Bottle
                            ZStack {
                                Image("wb2")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 240, height: 240)
                                    .shadow(color: Color.black.opacity(0.15), radius: 15, x: 0, y: 8)
                                Rectangle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color.blue.opacity(0.7),
                                                Color.blue.opacity(0.8)
                                            ]),
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                    .frame(width: 240, height: 240 * fillPercentage)
                                    .offset(y: 240 * (1 - fillPercentage) / 2)
                                    .mask(
                                        Image("wb2")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 240, height: 240)
                                    )
                                    .animation(.spring(response: 0.8, dampingFraction: 0.8), value: fillPercentage)
                            }
                        }
                        .padding(.bottom, 24)
                        
                        Text("\(currentIntake) / \(dailyGoal) oz")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.primary)
                            .padding(.bottom, 24)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 100)
                }
                
                VStack {
                    Spacer()
                    
                    Button(action: {  // Vibrations (Haptic feedback)
                        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                        impactFeedback.prepare()
                        impactFeedback.impactOccurred()
                        
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            addWater()
                        }
                    }) {
                        VStack(spacing: 8) {
                            Image(systemName: "drop.fill")
                                .font(.system(size: 32, weight: .medium))
                                .foregroundStyle(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.white, .white.opacity(0.8)]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                            
                            Text("\(addWaterAmount) oz")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white)
                        }
                        .frame(width: 110, height: 110)
                        .background(
                            ZStack {
                                // Main gradient background
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color.blue.opacity(0.8),
                                                Color.blue.opacity(1.0)
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                
                                Circle()
                                    .fill(Color.white.opacity(0.2))
                                    .frame(width: 80, height: 80)
                                    .blur(radius: 10)
                                    .offset(x: -20, y: -20)
                            }
                        )
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.3), lineWidth: 2)
                        )
                        .clipShape(Circle())
                        .shadow(color: Color.blue.opacity(0.5), radius: 15, x: 0, y: 8)
                        .contentShape(Circle())
                    }
                    .buttonStyle(ScaleButtonStyle()) // Custom button style for press animation
                    .padding(.bottom, 100) // Space above bottom bar
                }
                
                // Bottom Bar
                VStack {
                    Spacer()
                    
                    bottomBar
                }
            }
            .sheet(isPresented: $showingGoalOptions) {
                ZStack {
                    // Blur effect behind the sheet
                    Color.black.opacity(0.15)
                        .background(.ultraThinMaterial)
                        .ignoresSafeArea()
                    
                    CustomTransitionBackground()
                    
                    VStack(spacing: 24) {
                        Text("How would you like to set your goal?")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.primary)
                            .padding(.top, 24)
                        
                        VStack(spacing: 16) {
                            Button(action: {
                                showingGoalOptions = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    showingQuickSet = true
                                }
                            }) {
                                HStack(spacing: 12) {
                                    Image(systemName: "number.circle.fill")
                                        .font(.system(size: 24))
                                    Text("Quick Set")
                                        .font(.system(size: 16, weight: .medium))
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 14, weight: .semibold))
                                }
                                .foregroundColor(.primary)
                                .padding()
                                .background(Color(UIColor.systemGray6))
                                .cornerRadius(12)
                            }
                            
                            Button(action: {
                                showingGoalOptions = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    showingCalculator = true
                                }
                            }) {
                                HStack(spacing: 12) {
                                    Image(systemName: "chart.bar.fill")
                                        .font(.system(size: 24))
                                    Text("Calculate")
                                        .font(.system(size: 16, weight: .medium))
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 14, weight: .semibold))
                                }
                                .foregroundColor(.primary)
                                .padding()
                                .background(Color(UIColor.systemGray6))
                                .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                    }
                    .padding(.vertical, 24)
                    .background(Color(UIColor.systemBackground).opacity(0.9))
                    .background(.ultraThinMaterial)
                    .cornerRadius(24)
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                    .padding(.horizontal)
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .bottom)
                        .combined(with: .opacity)
                        .combined(with: .scale(scale: 0.95)),
                    removal: .move(edge: .bottom)
                        .combined(with: .opacity)
                        .combined(with: .scale(scale: 0.95))
                ))
                .animation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.2), value: showingGoalOptions)
            }
            
            // Quick Set Sheet
            .sheet(isPresented: $showingQuickSet) {
                ZStack {
                    // Blur effect behind the sheet
                    Color.black.opacity(0.15)
                        .background(.ultraThinMaterial)
                        .ignoresSafeArea()
                    
                    CustomTransitionBackground()
                    
                    GoalInputView(dailyGoal: $dailyGoal)
                        .background(Color(UIColor.systemBackground).opacity(0.9))
                        .background(.ultraThinMaterial)
                        .cornerRadius(24)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                        .padding(.horizontal)
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .bottom)
                        .combined(with: .opacity)
                        .combined(with: .scale(scale: 0.95)),
                    removal: .move(edge: .bottom)
                        .combined(with: .opacity)
                        .combined(with: .scale(scale: 0.95))
                ))
                .animation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.2), value: showingQuickSet)
            }
            
            // Calculator Sheet
            .sheet(isPresented: $showingCalculator) {
                ZStack {
                    WaterGoalCalculator(dailyGoal: $dailyGoal)
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .bottom)
                        .combined(with: .opacity)
                        .combined(with: .scale(scale: 0.95)),
                    removal: .move(edge: .bottom)
                        .combined(with: .opacity)
                        .combined(with: .scale(scale: 0.95))
                ))
                .animation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.2), value: showingCalculator)
            }
            
            // Fill Amount Sheet
            .sheet(isPresented: $showingFillAmount) {
                ZStack {
                    // Blur effect behind the sheet
                    Color.black.opacity(0.15)
                        .background(.ultraThinMaterial)
                        .ignoresSafeArea()
                    
                    CustomTransitionBackground()
                    
                    // Fill Amount Input View
                    VStack(spacing: 28) {
                        Text("Change Fill Amount")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.primary)
                            .padding(.top, 12)
                            .padding(.horizontal, 8)
                            .multilineTextAlignment(.center)
                        
                        TextField("Enter amount in oz", text: $inputValue)
                            .keyboardType(.numberPad)
                            .font(.system(size: 32, weight: .medium))
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(12)
                            .padding(.horizontal, 24)
                        
                        HStack(spacing: 16) {
                            Button("Cancel") {
                                withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                                    showingFillAmount = false
                                }
                            }
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(12)
                            
                            Button("Set") {
                                if let amount = Int(inputValue), amount > 0 {
                                    addWaterAmount = amount
                                    withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                                        showingFillAmount = false
                                    }
                                }
                            }
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.blue)
                            .cornerRadius(12)
                        }
                        .padding(.horizontal, 24)
                    }
                    .padding(.vertical, 28)
                    .background(Color(UIColor.systemBackground).opacity(0.9))
                    .background(.ultraThinMaterial)
                    .cornerRadius(24)
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                    .padding(.horizontal, 20)
                    .transition(.scale(scale: 0.9).combined(with: .opacity))
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .bottom)
                        .combined(with: .opacity)
                        .combined(with: .scale(scale: 0.95)),
                    removal: .move(edge: .bottom)
                        .combined(with: .opacity)
                        .combined(with: .scale(scale: 0.95))
                ))
                .animation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.2), value: showingFillAmount)
            }
        }
        .navigationViewStyle(.stack)
        .transition(.asymmetric(
            insertion: .move(edge: .trailing)
                .combined(with: .opacity)
                .combined(with: .scale(scale: 0.98)),
            removal: .move(edge: .leading)
                .combined(with: .opacity)
                .combined(with: .scale(scale: 0.98))
        ))
        .animation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.2), value: true)
        .onAppear {
            // Initialize the input value to current amount when app launches
            inputValue = String(addWaterAmount)
            checkForNewDay()
            
            // Set initial state only once
            if !hasAppeared {
                hasAppeared = true
            }
        }
    }
    
    // MARK: - Intake Functions
    
    private func addWater() {
        currentIntake += addWaterAmount
        updateHistory()
    }
    
    private func clearIntake() {
        currentIntake = 0
        updateHistory()
    }
    
    private func checkForNewDay() {
        let lastSavedDate = UserDefaults.standard.object(forKey: "lastSavedDate") as? Date ?? Date()
        let calendar = Calendar.current
        if !calendar.isDateInToday(lastSavedDate) {
            currentIntake = 0
            UserDefaults.standard.set(Date(), forKey: "lastSavedDate")
            updateHistory()
        }
    }
    
    private func getDateKey(for date: Date) -> String {
        return DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .none)
    }
    
    private func updateHistory() {
        let dateKey = getDateKey(for: Date())
        var history: [String: Int] = [:]
        
        if let data = UserDefaults.standard.string(forKey: "waterHistory"),
           let decoded = try? JSONDecoder().decode([String: Int].self, from: Data(data.utf8)) {
            history = decoded
        }
        
        history[dateKey] = currentIntake
        
        if let encoded = try? JSONEncoder().encode(history) {
            UserDefaults.standard.set(String(data: encoded, encoding: .utf8), forKey: "waterHistory")
        }
    }
    
    // Update the bottom bar buttons to use the new input system
    private var bottomBar: some View {
        VStack(spacing: 0) {
            Divider()
                .opacity(0.3)
            
            HStack(spacing: 0) {

                Button(action: {
                    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                    impactFeedback.prepare()
                    impactFeedback.impactOccurred()
                    
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        clearIntake()
                    }
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.system(size: 22))
                        Text("Reset")
                            .font(.system(size: 12))
                    }
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                    .foregroundColor(.red)
                }
                .buttonStyle(ScaleButtonStyle())
                
                // Fill Button - now uses dedicated state
                Button(action: {
                    // Add haptic feedback
                    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                    impactFeedback.prepare()
                    impactFeedback.impactOccurred()
                    
                    inputValue = String(addWaterAmount) 
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                        showingFillAmount = true
                    }
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: "drop.fill")
                            .font(.system(size: 22))
                        Text("Amount")
                            .font(.system(size: 12))
                    }
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                    .foregroundColor(.primary)
                }
                .buttonStyle(ScaleButtonStyle())
                
                // View History Button
                NavigationLink(destination: CalendarView()) {
                    VStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.system(size: 22))
                        Text("History")
                            .font(.system(size: 12))
                    }
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                    .foregroundColor(.primary)
                }
                .buttonStyle(ScaleButtonStyle())
            }
            .padding(.vertical, 12)
            .background(.ultraThinMaterial)
            .background(Color(UIColor.systemBackground).opacity(0.8))
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: -3)
        }
    }
}

#Preview {
    WaterTrackerView()
}

struct CalendarView: View {
    @AppStorage("dailyGoal") private var dailyGoal: Int = 64
    @State private var waterHistory: [String: Int] = [:]
    @State private var currentMonth: Date = Date()
    @State private var currentStreak: Int = 0
    @State private var isProgressExpanded: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    private let calendar = Calendar.current
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    private var monthName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentMonth)
    }
    
    private var daysInMonth: Int {
        return calendar.range(of: .day, in: .month, for: currentMonth)?.count ?? 30
    }
    
    var body: some View {
        ZStack {
            CustomTransitionBackground()
            
            ScrollView {
                VStack(spacing: 20) {
                    // Custom Back Button
                    HStack {
                        Button(action: {
                            // Add haptic feedback
                            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                            impactFeedback.prepare()
                            impactFeedback.impactOccurred()
                            
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.2)) {
                                dismiss()
                            }
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 18, weight: .semibold))
                                Text("Back")
                                    .font(.system(size: 16, weight: .medium))
                            }
                            .foregroundColor(.primary)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .background(Color(UIColor.systemGray6).opacity(0.8))
                            .background(.ultraThinMaterial)
                            .cornerRadius(20)
                        }
                        .buttonStyle(ScaleButtonStyle())
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    
                    // Streak Banner
                    VStack(spacing: 8) {
                        Text("Current Streak")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.gray)
                        
                        HStack(spacing: 4) {
                            Image(systemName: "flame.fill")
                                .font(.system(size: 22))
                                .foregroundColor(.orange)
                                .shadow(color: .orange.opacity(0.3), radius: 4, x: 0, y: 2)
                            Text("\(currentStreak) Days")
                                .font(.system(size: 28, weight: .bold))
                        }
                        .foregroundColor(.primary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(UIColor.systemGray6).opacity(0.8))
                            
                            // Add subtle gradient
                            RoundedRectangle(cornerRadius: 20)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.white.opacity(0.05), .clear]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        }
                    )
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.07), radius: 8, x: 0, y: 4)
                    .padding(.horizontal)
                    .onAppear {
                        updateStreak()
                    }
                    .onChange(of: waterHistory) { _ in
                        updateStreak()
                    }
                    .onChange(of: dailyGoal) { _ in
                        updateStreak()
                    }
                    
                    // Month Navigation
                    HStack {
                        Button(action: {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                previousMonth()
                            }
                        }) {
                            Image(systemName: "chevron.left.circle.fill")
                                .font(.system(size: 28))
                                .foregroundColor(.blue)
                                .shadow(color: .blue.opacity(0.2), radius: 2, x: 0, y: 1)
                        }
                        .buttonStyle(ScaleButtonStyle())
                        
                        Spacer()
                        
                        Text(monthName)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                nextMonth()
                            }
                        }) {
                            Image(systemName: "chevron.right.circle.fill")
                                .font(.system(size: 28))
                                .foregroundColor(.blue)
                                .shadow(color: .blue.opacity(0.2), radius: 2, x: 0, y: 1)
                        }
                        .buttonStyle(ScaleButtonStyle())
                    }
                    .padding(.horizontal)
                    
                    // Weekday Labels
                    HStack(spacing: 0) {
                        ForEach(["S", "M", "T", "W", "T", "F", "S"], id: \.self) { day in
                            Text(day)
                                .frame(maxWidth: .infinity)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    // Calendar Grid
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(1...daysInMonth, id: \.self) { day in
                            let dateKey = formatDate(day: day)
                            let intake = waterHistory[dateKey] ?? 0
                            let isGoalMet = intake >= dailyGoal
                            
                            VStack(spacing: 4) {
                                // Day Number
                                Text("\(day)")
                                    .font(.system(size: 16, weight: isToday(day: day) ? .bold : .medium))
                                    .foregroundColor(isToday(day: day) ? .blue : .primary)
                                
                                // Water Amount
                                if intake > 0 {
                                    Text("\(intake) oz")
                                        .font(.system(size: 10, weight: .medium))
                                        .foregroundColor(isGoalMet ? .green : .gray)
                                        .lineLimit(1)
                                }
                                
                                // Goal Indicator
                                if isGoalMet {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 12))
                                        .foregroundColor(.green)
                                        .shadow(color: .green.opacity(0.2), radius: 1, x: 0, y: 1)
                                }
                            }
                            .frame(width: 44, height: 60)
                            .background(
                                ZStack {
                                    if isToday(day: day) {
                                        RoundedRectangle(cornerRadius: 14)
                                            .stroke(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [.blue, .blue.opacity(0.7)]),
                                                    startPoint: .top,
                                                    endPoint: .bottom
                                                ),
                                                lineWidth: 2
                                            )
                                            .background(
                                                RoundedRectangle(cornerRadius: 14)
                                                    .fill(Color.blue.opacity(0.1))
                                            )
                                    }
                                }
                            )
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color(UIColor.systemGray6).opacity(0.8))
                                    .shadow(color: Color.black.opacity(0.07), radius: 2, x: 0, y: 1)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color.gray.opacity(0.1), lineWidth: 1)
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    // Progress Summary
                    VStack(spacing: 0) {
                        let daysWithGoal = waterHistory.values.filter { $0 >= dailyGoal }.count
                        let progress = Double(daysWithGoal) / Double(daysInMonth)
                        
                        Button(action: { 
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) { 
                                isProgressExpanded.toggle() 
                            }
                            // Haptic feedback
                            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                            impactFeedback.impactOccurred()
                        }) {
                            HStack {
                                Text("Monthly Progress")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                Text("\(Int(progress * 100))%")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.blue)
                                
                                Image(systemName: isProgressExpanded ? "chevron.up" : "chevron.down")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.gray)
                            }
                            .padding()
                        }
                        .buttonStyle(ScaleButtonStyle())
                        
                        if isProgressExpanded {
                            VStack(spacing: 16) {
                                HStack {
                                    Text("\(daysWithGoal) of \(daysInMonth) days")
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                    
                                    Spacer()
                                }
                                
                                GeometryReader { geometry in
                                    ZStack(alignment: .leading) {
                                        RoundedRectangle(cornerRadius: 6)
                                            .fill(Color(UIColor.systemGray5))
                                            .frame(height: 10)
                                        
                                        RoundedRectangle(cornerRadius: 6)
                                            .fill(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [.blue, .blue.opacity(0.7)]),
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                            .frame(width: geometry.size.width * progress, height: 10)
                                            .shadow(color: .blue.opacity(0.3), radius: 2, x: 0, y: 1)
                                    }
                                }
                                .frame(height: 10)
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 16)
                            .transition(.move(edge: .top).combined(with: .opacity))
                        }
                    }
                    .background(
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(UIColor.systemGray6).opacity(0.8))
                            
                            // Add subtle gradient
                            RoundedRectangle(cornerRadius: 20)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.white.opacity(0.05), .clear]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        }
                    )
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.07), radius: 8, x: 0, y: 4)
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
        }
        .navigationBarHidden(true)
        .transition(.asymmetric(
            insertion: .move(edge: .trailing)
                .combined(with: .opacity)
                .combined(with: .scale(scale: 0.98)),
            removal: .move(edge: .leading)
                .combined(with: .opacity)
                .combined(with: .scale(scale: 0.98))
        ))
        .animation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.2), value: true)
        .onAppear {
            loadHistory()
        }
        .onReceive(Timer.publish(every: 2, on: .main, in: .common).autoconnect()) { _ in
            loadHistory()
        }
    }
    
    private func isToday(day: Int) -> Bool {
        let todayComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        let currentComponents = calendar.dateComponents([.year, .month], from: currentMonth)
        return todayComponents.year == currentComponents.year &&
        todayComponents.month == currentComponents.month &&
        todayComponents.day == day
    }
    
    private func formatDate(day: Int) -> String {
        let components = DateComponents(year: calendar.component(.year, from: currentMonth),
                                        month: calendar.component(.month, from: currentMonth),
                                        day: day)
        if let date = calendar.date(from: components) {
            return DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .none)
        }
        return ""
    }
    
    private func loadHistory() {
        if let data = UserDefaults.standard.string(forKey: "waterHistory"),
           let decoded = try? JSONDecoder().decode([String: Int].self, from: Data(data.utf8)) {
            waterHistory = decoded
        } else {
            waterHistory = [:]
        }
    }
    
    private func saveHistory() {
        if let encoded = try? JSONEncoder().encode(waterHistory) {
            UserDefaults.standard.set(String(data: encoded, encoding: .utf8), forKey: "waterHistory")
        }
    }
    
    private func clearHistory() {
        UserDefaults.standard.removeObject(forKey: "waterHistory")
        waterHistory = [:]
    }
    
    private func createFakeDay() {
        let randomAmount = Int.random(in: 30...100)
        let randomDay = Int.random(in: 1...daysInMonth)
        let dateKey = formatDate(day: randomDay)
        
        waterHistory[dateKey] = randomAmount
        saveHistory()
    }
    
    private func previousMonth() {
        if let previousMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) {
            currentMonth = previousMonth
        }
    }
    
    private func nextMonth() {
        if let nextMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) {
            currentMonth = nextMonth
        }
    }
    
    private func updateStreak() {
        let today = Date()
        var streak = 0
        var currentDate = today
        var isFirstDay = true
        
        while true {
            let dateKey = DateFormatter.localizedString(from: currentDate, dateStyle: .short, timeStyle: .none)
            let intake = waterHistory[dateKey] ?? 0
            
            if isFirstDay {
                // On the first (current) day, don't break even if intake is below goal
                streak += 1
                isFirstDay = false
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
                continue
            }
            
            if intake >= dailyGoal {
                streak += 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
            } else {
                break
            }
        }
        
        currentStreak = streak
    }
}

enum ActivityLevel: String, CaseIterable {
    case sedentary = "Sedentary"
    case lightlyActive = "Lightly Active"
    case moderatelyActive = "Moderately Active"
    case veryActive = "Very Active"
    
    var minutesOfActivity: Int {
        switch self {
        case .sedentary: return 0
        case .lightlyActive: return 30
        case .moderatelyActive: return 60
        case .veryActive: return 90
        }
    }
}

enum Sex: String, CaseIterable {
    case male = "Male"
    case female = "Female"
}

public struct WaterGoalCalculator: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var dailyGoal: Int
    
    @State private var currentStep = 1
    @State private var weight: String = ""
    @State private var isMetric = false
    @State private var selectedActivity: ActivityLevel = .sedentary
    @State private var isHotClimate = false
    @State private var selectedSex: Sex = .male
    @State private var calculatedGoal: Int = 0
    
    private var totalSteps = 5 // 4 questions + results
    
    public init(dailyGoal: Binding<Int>) {
        self._dailyGoal = dailyGoal
    }
    
    public var body: some View {
        ZStack {
            // Gradient Background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.blue.opacity(0.3),
                    Color(UIColor.systemBackground).opacity(0.95),
                    Color(UIColor.systemBackground).opacity(0.95)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Water Ripple Effect
            ZStack {
                // Background blue shape
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.blue.opacity(0.2),
                                Color.black.opacity(0.05)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 320, height: 320)
                    .blur(radius: 60)
                    .offset(y: -100)
                
                // Animated ripples
                ForEach(0..<3) { index in
                    Circle()
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.blue.opacity(0.3),
                                    Color.blue.opacity(0.1)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: 2
                        )
                        .frame(width: 200 + CGFloat(index * 50))
                        .blur(radius: 3)
                        .offset(y: -100)
                }
            }
            .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: UUID())
            
            // Content
            VStack(spacing: 24) {
                // Progress Indicator
                HStack(spacing: 8) {
                    ForEach(1...totalSteps, id: \.self) { step in
                        Circle()
                            .fill(step <= currentStep ? Color.blue : Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.top, 20)
                
                // Content
                Group {
                    switch currentStep {
                    case 1:
                        weightStep
                    case 2:
                        activityStep
                            .transition(.asymmetric(
                                insertion: .move(edge: .trailing).combined(with: .opacity),
                                removal: .move(edge: .leading).combined(with: .opacity)
                            ))
                    case 3:
                        climateStep
                            .transition(.asymmetric(
                                insertion: .move(edge: .trailing).combined(with: .opacity),
                                removal: .move(edge: .leading).combined(with: .opacity)
                            ))
                    case 4:
                        sexStep
                            .transition(.asymmetric(
                                insertion: .move(edge: .trailing).combined(with: .opacity),
                                removal: .move(edge: .leading).combined(with: .opacity)
                            ))
                    default:
                        resultsStep
                            .transition(.asymmetric(
                                insertion: .move(edge: .trailing).combined(with: .opacity),
                                removal: .move(edge: .leading).combined(with: .opacity)
                            ))
                    }
                }
                .animation(.spring(response: 0.5, dampingFraction: 0.8), value: currentStep)
                
                Spacer()
                
                // Navigation Buttons
                HStack(spacing: 16) {
                    if currentStep > 1 {
                        Button("Back") {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                currentStep -= 1
                            }
                            // Add subtle haptic feedback
                            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                            impactFeedback.impactOccurred()
                        }
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.gray)
                        .buttonStyle(ScaleButtonStyle())
                    }
                    
                    Button(currentStep == totalSteps ? "Set Goal" : "Next") {
                        if currentStep == totalSteps {
                            // Add haptic success feedback
                            let successFeedback = UINotificationFeedbackGenerator()
                            successFeedback.notificationOccurred(.success)
                            
                            dailyGoal = calculatedGoal
                            dismiss()
                        } else {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                currentStep += 1
                                if currentStep == totalSteps {
                                    calculateGoal()
                                }
                            }
                            // Add haptic feedback
                            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                            impactFeedback.impactOccurred()
                        }
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(12)
                    .shadow(color: Color.blue.opacity(0.3), radius: 5, x: 0, y: 2)
                    .buttonStyle(ScaleButtonStyle())
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
        }
        .ignoresSafeArea()
    }
    
    private var weightStep: some View {
        VStack(spacing: 20) {
            Text("What is your weight?")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .center)
            
            HStack {
                TextField("Enter weight", text: $weight)
                    .keyboardType(.decimalPad)
                    .font(.system(size: 32, weight: .medium))
                    .multilineTextAlignment(.center)
                    .frame(width: 120)
                
                Picker("Unit", selection: $isMetric) {
                    Text("lbs").tag(false)
                    Text("kg").tag(true)
                }
                .pickerStyle(.segmented)
                .frame(width: 100)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
            Text(isMetric ? "Enter your weight in kilograms" : "Enter your weight in pounds")
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .center)
            
            // Keyboard dismissal button
            Button(action: {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }) {
                Text("Done")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 120, height: 44)
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding(.top, 16)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .center)
        .background(Color(UIColor.systemBackground).opacity(0.8))
        .cornerRadius(16)
        .padding(.horizontal)
    }
    
    private var activityStep: some View {
        VStack(spacing: 20) {
            Text("How active are you daily?")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .center)
            
            VStack(spacing: 12) {
                ForEach(ActivityLevel.allCases, id: \.self) { activity in
                    Button(action: {
                        selectedActivity = activity
                    }) {
                        HStack {
                            Text(activity.rawValue)
                                .font(.system(size: 16, weight: .medium))
                            Spacer()
                            if selectedActivity == activity {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(selectedActivity == activity ? Color.blue.opacity(0.1) : Color(UIColor.systemGray6))
                        )
                    }
                    .foregroundColor(.primary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    private var climateStep: some View {
        VStack(spacing: 20) {
            Text("Hot Climate?")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Text("Do you live in a hot climate or spend a lot of time in the heat?")
                .font(.system(size: 16))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
            
            HStack(spacing: 20) {
                Button(action: {
                    isHotClimate = true
                }) {
                    VStack(spacing: 8) {
                        Image(systemName: "sun.max.fill")
                            .font(.system(size: 32))
                        Text("Yes")
                            .font(.system(size: 16, weight: .medium))
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(isHotClimate ? Color.blue.opacity(0.1) : Color(UIColor.systemGray6))
                    )
                }
                
                Button(action: {
                    isHotClimate = false
                }) {
                    VStack(spacing: 8) {
                        Image(systemName: "cloud.fill")
                            .font(.system(size: 32))
                        Text("No")
                            .font(.system(size: 16, weight: .medium))
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(!isHotClimate ? Color.blue.opacity(0.1) : Color(UIColor.systemGray6))
                    )
                }
            }
            .foregroundColor(.primary)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    private var sexStep: some View {
        VStack(spacing: 20) {
            Text("What is your sex?")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .center)
            
            HStack(spacing: 20) {
                ForEach(Sex.allCases, id: \.self) { sex in
                    Button(action: {
                        selectedSex = sex
                    }) {
                        VStack(spacing: 8) {
                            Image(systemName: sex == .male ? "figure.arms.open" : "figure.wave")
                                .font(.system(size: 32))
                            Text(sex.rawValue)
                                .font(.system(size: 16, weight: .medium))
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(selectedSex == sex ? Color.blue.opacity(0.1) : Color(UIColor.systemGray6))
                        )
                    }
                    .foregroundColor(.primary)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    private var resultsStep: some View {
        VStack(spacing: 24) {
            Text("Your Recommended Daily Water Intake")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 16) {
                Text("\(calculatedGoal) oz")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading, spacing: 12) {
                    CalculationRow(title: "Base Amount", value: "\(Int(Double(weight) ?? 0 * 0.67)) oz")
                    CalculationRow(title: "Activity Adjustment", value: "+\(selectedActivity.minutesOfActivity / 30 * 12) oz")
                    if isHotClimate {
                        CalculationRow(title: "Climate Adjustment", value: "+10 oz")
                    }
                    if selectedSex == .female {
                        CalculationRow(title: "Sex Adjustment", value: "-10 oz")
                    }
                }
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(12)
            }
            
            Text("This recommendation is based on your weight, activity level, climate, and sex.")
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
    
    private func calculateGoal() {
        guard let weightValue = Double(weight) else { return }
        let weightInPounds = isMetric ? weightValue * 2.20462 : weightValue
        
        // Base calculation
        var total = Int(weightInPounds * 0.67)
        
        // Activity adjustment
        total += selectedActivity.minutesOfActivity / 30 * 12
        
        // Climate adjustment
        if isHotClimate {
            total += 10
        }
        
        // Sex adjustment
        if selectedSex == .female {
            total -= 10
        }
        
        calculatedGoal = max(total, 0) // Ensure we don't return a negative number
    }
}

struct CalculationRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.primary)
        }
    }
}

// Add the ScaleButtonStyle after CalculationRow
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .opacity(configuration.isPressed ? 0.9 : 1)
            .animation(.spring(response: 0.2, dampingFraction: 0.7), value: configuration.isPressed)
    }
}




