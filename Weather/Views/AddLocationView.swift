//
//  AddLocationView.swift
//  Weather
//
//  Created by Tino on 29/11/21.
//

import SwiftUI

struct AddLocationView: View {
    enum Field {
        case name
    }
    
    @Binding var locations: [String]
    @State private var name = ""
    @FocusState private var focusedField: Field?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                    .focused($focusedField, equals: .name)
                    .submitLabel(.done)
                    .onSubmit(addLocation)
            }
            .toolbar {
                addButton
            }
            .navigationTitle("Add location")
        }
        .task {
            focusedField = .name
        }
    }
}

private extension AddLocationView {
    func addLocation() {
        if !locations.contains(name) {
            locations.append(name)
        }
        dismiss()
    }
    
    var disabled: Bool {
        let name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        return name.isEmpty
    }
    
    var addButton: some View {
        Button {
            addLocation()
        } label: {
            Text("Add")
        }
        .disabled(disabled)
    }
}

struct AddLocationView_Previews: PreviewProvider {
    static var previews: some View {
        AddLocationView(locations: .constant([]))
    }
}
