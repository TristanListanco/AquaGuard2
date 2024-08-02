
    private var addDataPopoverContent: some View {
        NavigationView {
            Form {
                Section {
                    DatePicker("Date", selection: $newDate, displayedComponents: .date)
                    DatePicker("Time", selection: $newTime, displayedComponents: .hourAndMinute)
                    TextField("Enter value", text: $newValue)
                }
            }
            .navigationTitle(Text(selectedDataType.rawValue))
            .navigationBarTitleDisplayMode(.inline) // This sets the navigation bar title to use the inline style
            .navigationBarItems(
                leading: Button("Cancel") {
                    isPopoverPresented = false
                },
                trailing: Button("Add") {
                    addData()
                }
            )
        }
    }
