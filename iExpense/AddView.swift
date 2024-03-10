//
//  AddView.swift
//  iExpense
//
//  Created by Margarita Mayer on 04/01/24.
//

import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var name = "Add new expense"
    @State private var type = "Personal"
    @State private var amount = 0.0
    @State private var currencyCode = "USD"
    
    var expenses: Expenses
    
    let types = ["Business", "Personal"]
    let currencyTypes = ["USD", "EUR", "GBP"]
    
    var body: some View {
        NavigationStack {
            Form {
//                TextField("Name", text: $name)
                
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                
                HStack {
                    TextField("Amount", value: $amount, format: .currency(code: currencyCode))
                        .keyboardType(.decimalPad)
                    
                    Picker("", selection: $currencyCode) {
                        ForEach(currencyTypes, id: \.self) { currency in
                            Text(currency)
                        }
                    }
                }
                
                
            }
            .navigationTitle($name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let item = ExpenseItem(name: name, type: type, amount: amount, currencyCode: currencyCode)
                        expenses.items.append(item)
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .navigationBarBackButtonHidden()
            
        }
    }
}

#Preview {
    AddView(expenses: Expenses())
}
