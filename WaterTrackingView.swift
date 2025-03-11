import SwiftUI
import AVFoundation

struct WaterTrackerView: View {
    @AppStorage("dailyGoal") private var dailyGoal: Int = 128 // Default to 128 oz
    @AppStorage("currentIntake") private var currentIntake: Int = 0
    @State private var addWaterAmount: Int = 8 // Default add amount
    @State private var showingGoalInput: Bool = false // State to toggle goal input view
    @State private var showingFillInput: Bool = false // State to toggle fill input view
    @State private var newGoal: String = "" // State to store goal input value
    @State private var newFillAmount: String = "" // State to store fill amount input value
    
    private var fillPercentage: CGFloat {
        return min(CGFloat(currentIntake) / CGFloat(dailyGoal), 1.0)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                ZStack {
                    Image("wb2")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                        .shadow(radius: 10)
                    
                    Rectangle()
                        .fill(Color.blue.opacity(0.7))
                        .frame(width: 300, height: 300 * fillPercentage)
                        .offset(y: 300 * (1 - fillPercentage) / 2)
                        .mask(
                            Image("wb2")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 300, height: 300)
                        )
                        .animation(.easeInOut, value: fillPercentage)
                }
                
                Text("\(currentIntake) / \(dailyGoal) oz")
                    .font(.title2)
                    .bold()
                    .padding()
                
                Button(action: addWater) {
                    Text("+ \(addWaterAmount) oz")
                        .font(.title3)
                        .padding()
                        .frame(width: 140)
                        .background(Color.gray.opacity(0.8))
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
                
                NavigationLink(destination: CalendarView()) {
                    Text("View History")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.3))
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
            }
            .padding()
            .navigationTitle("Water Tracker")
            .frame(maxWidth: .infinity, alignment: .center)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: { showingGoalInput.toggle() }) {
                        Text("Set Goal")
                            .font(.caption)
                            .padding(6)
                            .background(Color.gray.opacity(0.7))
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    
                    Button(action: { showingFillInput.toggle() }) {
                        Text("Set Fill")
                            .font(.caption)
                            .padding(6)
                            .background(Color.gray.opacity(0.7))
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    
                    Button(action: { clearIntake() }) {
                        Text("Clear")
                            .font(.caption)
                            .padding(6)
                            .background(Color.red.opacity(0.7))
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
            .onAppear(perform: checkForNewDay)
            .sheet(isPresented: $showingGoalInput) {
                VStack {
                    Text("Enter Your Daily Goal")
                        .font(.title)
                        .padding()
                    
                    TextField("Goal in oz", text: $newGoal)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    
                    Button("Set Goal") {
                        if let goal = Int(newGoal), goal > 0 {
                            dailyGoal = goal
                            showingGoalInput = false
                        }
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding()
            }
            .sheet(isPresented: $showingFillInput) {
                VStack {
                    Text("Enter Water Fill Amount")
                        .font(.title)
                        .padding()
                    
                    TextField("Fill amount in oz", text: $newFillAmount)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    
                    Button("Set Fill Amount") {
                        if let fillAmount = Int(newFillAmount), fillAmount > 0 {
                            addWaterAmount = fillAmount
                            showingFillInput = false
                        }
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding()
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
}

#Preview {
    WaterTrackerView()
}


struct CalendarView: View {
    @AppStorage("dailyGoal") private var dailyGoal: Int = 64 // Default to 64 oz
    @State private var waterHistory: [String: Int] = [:] // Ensures UI updates
    @State private var currentMonth: Date = Date() // Track the current month
    
    private let calendar = Calendar.current
    private let columns = Array(repeating: GridItem(.flexible()), count: 7) // 7 days in a week
    
    private var monthName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentMonth)
    }
    
    private var daysInMonth: Int {
        return calendar.range(of: .day, in: .month, for: currentMonth)?.count ?? 30
    }
    
    // Still calculating firstWeekday in case needed for further alignment
    private var firstWeekday: Int {
        let components = calendar.dateComponents([.year, .month], from: currentMonth)
        guard let firstDay = calendar.date(from: components) else { return 0 }
        let weekday = calendar.component(.weekday, from: firstDay)
        return (weekday - calendar.firstWeekday + 7) % 7
    }
    
    var body: some View {
        VStack(spacing: 10) {
            // Month Header
            HStack {
                Button(action: previousMonth) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
                
                Text(monthName)
                    .font(.title)
                    .bold()
                    .foregroundColor(.primary)
                
                Button(action: nextMonth) {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
            }
            .padding(.vertical)
            
            // Weekday Labels
            HStack {
                ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                    Text(day)
                        .frame(maxWidth: .infinity)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal)
            
            // Calendar Grid (only showing actual days)
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(1...daysInMonth, id: \.self) { day in
                    let dateKey = formatDate(day: day)
                    let intake = waterHistory[dateKey] ?? 0
                    
                    VStack(spacing: 6) {
                        Text("\(day)")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        // For today's date, always display the oz (even if 0),
                        // while for other days, display only if intake > 0.
                        if isToday(day: day) {
                            Text("\(intake) oz")
                                .font(.caption2)
                                .foregroundColor(intake >= dailyGoal ? .green : .gray)
                                .lineLimit(1)
                            
                            if intake >= dailyGoal {
                                Text("✅")
                                    .font(.footnote)
                            }
                        } else {
                            if intake > 0 {
                                Text("\(intake) oz")
                                    .font(.caption2)
                                    .foregroundColor(intake >= dailyGoal ? .green : .gray)
                                    .lineLimit(1)
                                
                                if intake >= dailyGoal {
                                    Text("✅")
                                        .font(.footnote)
                                }
                            } else {
                                Spacer(minLength: 6)
                            }
                        }
                    }
                    .frame(width: 50, height: 60)
                    // Highlight today's date
                    .background(isToday(day: day) ? Color.yellow.opacity(0.3) : Color(.systemGray6))
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
                }
            }
            .padding()
            
            // Buttons for Troubleshooting
            HStack(spacing: 20) {
                Button(action: clearHistory) {
                    Text("Clear History")
                        .font(.subheadline)
                        .padding()
                        .foregroundColor(.red)
                        .background(RoundedRectangle(cornerRadius: 12).stroke(Color.red))
                }
                
                Button(action: createFakeDay) {
                    Text("Create Fake Day")
                        .font(.subheadline)
                        .padding()
                        .foregroundColor(.green)
                        .background(RoundedRectangle(cornerRadius: 12).stroke(Color.green))
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("Water History")
        .padding()
        .onAppear {
            loadHistory()
        }
        // Live update every 10 seconds
        .onReceive(Timer.publish(every: 10, on: .main, in: .common).autoconnect()) { _ in
            loadHistory()
        }
    }
    
    // Helper to determine if a given day is today's date
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
}




