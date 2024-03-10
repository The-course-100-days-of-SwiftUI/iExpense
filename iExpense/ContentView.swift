//
//  ContentView.swift
//  iExpense
//
//  Created by Margarita Mayer on 03/01/24.
//

import SwiftUI


struct ExpenseItem: Identifiable, Codable {
    let name: String
    let type: String
    let amount: Double
    let currencyCode: String
    var id = UUID()
}

@Observable
class Expenses {
    var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        
        items = []
    }
}

struct ContentView: View {
    
    @State private var expenses = Expenses()
//    @State private var showingAddExpense = false
    
    
    
    
    var body: some View {
        
        let personalExpenses = expenses.items.filter {$0.type == "Personal"}
        let businessExpenses = expenses.items.filter {$0.type == "Business"}
        
        NavigationStack {
            List{
                
                if !personalExpenses.isEmpty {
                            Section("Personal expenses") {
                            
                                ForEach(personalExpenses) { item in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(item.name)
                                        .font(.headline)
                                    
                                    Text(item.type)
                                    
                                }
                                Spacer()
                                
                                Text(item.amount, format: .currency(code: item.currencyCode))
                                    .foregroundColor(textColour(for: item.amount))
                            }
                            .accessibilityElement()
                            .accessibilityLabel("\(item.name), \(item.amount)")
                            .accessibilityHint(item.type)
                        }
                            .onDelete(perform: removePersonalItems)
                    }
                }
                
            
                    
                if !businessExpenses.isEmpty {
                        
                        Section("Business expenses") {
                        
                            ForEach(businessExpenses) { item in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(item.name)
                                        .font(.headline)
                                    
                                    Text(item.type)
                                    
                                }
                                Spacer()
                                
                                Text(item.amount, format: .currency(code: item.currencyCode))
                                    .foregroundColor(textColour(for: item.amount))
                            }
                            
                        }
                            .onDelete(perform: removeBusinessItems)
                        
                    }
                }
                
               
            }
            .navigationTitle("iExpense")
//            .toolbar {
//                Button("Add expense", systemImage: "plus") {
//                   showingAddExpense = true
//                }
//            }
//            .sheet(isPresented: $showingAddExpense) {
//               AddView(expenses: expenses)
//            }
            
            
            NavigationLink("Add expense", destination: AddView(expenses: expenses))
            
        }
        
        
    }
    
    func removePersonalItems(at offsets: IndexSet) {
        let personalExpenses = expenses.items.filter {$0.type == "Personal"}
        
        for index in offsets {
            
            let idToDelete = personalExpenses[index].id
            
            expenses.items.removeAll(where: {$0.id == idToDelete})
            
        }
    }
    
    
    func removeBusinessItems(at offsets: IndexSet) {
        
        let businessExpenses = expenses.items.filter {$0.type == "Business"}
        
        for index in offsets {
            
            let idToDelete = businessExpenses[index].id
            
            expenses.items.removeAll(where: {$0.id == idToDelete})
            
        }
    }
  
    
    func textColour(for amount: Double) -> Color {
        if amount < 10 {
            return .green
        } else if amount > 100 {
            return .red
        } else {
            return .blue
        }
    }
    
}


#Preview {
    ContentView()
}
