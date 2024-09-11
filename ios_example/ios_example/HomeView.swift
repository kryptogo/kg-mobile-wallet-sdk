import SwiftUI

struct HomeView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                HeaderView()
                
                DataUsageView()
                
                QuickActionsView()
                
                PromotionsView()
            }
            .padding()
        }
        .background(Color(UIColor.systemGroupedBackground))
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarTitle("Home", displayMode: .large)
    }
}

struct HeaderView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Welcome")
                    .font(.headline)
                    .foregroundColor(.secondary)
                Text("John Doe")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("Network Status")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("4G LTE")
                    .font(.headline)
                    .foregroundColor(.green)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
    }
}

struct DataUsageView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Data Usage")
                .font(.headline)
            
            HStack {
                Text("15.2 GB")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                Text("/ 20 GB")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            ProgressView(value: 15.2, total: 20)
                .accentColor(.blue)
            
            Text("6 days remaining")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
    }
}

struct QuickActionsView: View {
    let actions = ["Bill Pay", "Add Data", "Support", "Settings"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Quick Actions")
                .font(.headline)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                ForEach(actions, id: \.self) { action in
                    Button(action: {}) {
                        VStack {
                            Image(systemName: iconName(for: action))
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                                .frame(width: 50, height: 50)
                                .background(Color.blue)
                                .cornerRadius(10)
                            Text(action)
                                .font(.caption)
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
    }
    
    func iconName(for action: String) -> String {
        switch action {
        case "Bill Pay": return "dollarsign.circle"
        case "Add Data": return "arrow.up.circle"
        case "Support": return "questionmark.circle"
        case "Settings": return "gearshape"
        default: return "circle"
        }
    }
}

struct PromotionsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Special Offers")
                .font(.headline)
                .padding(.bottom, 5)
            
            HStack(spacing: 15) {
                Image(systemName: "gift")
                    .font(.system(size: 40))
                    .foregroundColor(.red)
                    .frame(width: 60, height: 60)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Summer Data Boost")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Text("Get 5GB extra data for free!")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color.red.opacity(0.1))
            .cornerRadius(10)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
        }
    }
}
