import SwiftUI

@main
struct StudyBuddyApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
        .commands {
            CommandMenu("StudyBuddy") {
                Button("Reset demo data") {
                    appState.resetDemoData()
                }
            }
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        TabView {
            TrackerView()
                .tabItem {
                    Label("Tracker", systemImage: "chart.line.uptrend.xyaxis")
                }

            FlashcardsView()
                .tabItem {
                    Label("Cards", systemImage: "rectangle.stack.fill")
                }

            PapersView()
                .tabItem {
                    Label("Papers", systemImage: "doc.text.fill")
                }

            NotesView()
                .tabItem {
                    Label("Notes", systemImage: "note.text")
                }

            CalendarView()
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }

            EssayPlannerView()
                .tabItem {
                    Label("Essays", systemImage: "pencil.and.outline")
                }
        }
        .frame(minWidth: 1100, minHeight: 700)
    }
}

struct TrackerView: View {
    @EnvironmentObject var appState: AppState
    @State private var manualMinutes: String = ""
    @State private var manualNote: String = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                HStack {
                    StatTile(title: "Minutes today", value: String(format: "%.0f", appState.todayMinutes))
                    StatTile(title: "Due cards", value: String(appState.dueCards.count))
                    StatTile(title: "Total sessions", value: String(appState.data.sessions.count))
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Log study time")
                        .font(.headline)
                    HStack {
                        Picker("Subject", selection: Binding(get: { appState.selectedSubject }, set: { appState.selectedSubject = $0 })) {
                            ForEach(appState.subjects, id: \ .self) { subject in
                                Text(subject).tag(subject)
                            }
                        }
                        .frame(width: 220)

                        TextField("Minutes", text: $manualMinutes)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 110)

                        TextField("What did you do?", text: $manualNote)
                            .textFieldStyle(.roundedBorder)

                        Button("Add") {
                            if let mins = Double(manualMinutes), mins > 0 {
                                appState.addSession(subject: appState.selectedSubject, minutes: mins, note: manualNote)
                                manualMinutes = ""
                                manualNote = ""
                            }
                        }
                    }
                }
                .padding()
                .background(Color(NSColor.controlBackgroundColor))
                .cornerRadius(12)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Recent sessions")
                        .font(.headline)

                    if appState.data.sessions.isEmpty {
                        Text("No study sessions logged yet.")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(appState.data.sessions.prefix(8)) { session in
                            HStack {
                                Text(session.subject)
                                Spacer()
                                Text("\(Int(session.minutes)) min")
                                if !session.note.isEmpty {
                                    Text("• \(session.note)")
                                        .foregroundColor(.secondary)
                                }
                                Button("Delete") {
                                    appState.deleteSession(session.id)
                                }
                                .buttonStyle(.borderless)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
                .padding()
                .background(Color(NSColor.controlBackgroundColor))
                .cornerRadius(12)
            }
            .padding()
        }
    }
}

struct StatTile: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(value)
                .font(.title2)
                .fontWeight(.semibold)
            Text(title)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, minHeight: 70)
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(12)
    }
}

struct FlashcardsView: View {
    @EnvironmentObject var appState: AppState
    @State private var addSubject: String = "Maths (Edexcel)"
    @State private var addTopic: String = ""
    @State private var addFront: String = ""
    @State private var addBack: String = ""

    var cards: [Card] {
        appState.data.cards.filter { $0.subject == appState.selectedSubject || appState.selectedSubject.isEmpty }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Add a card")
                        .font(.headline)

                    HStack {
                        Picker("Subject", selection: $addSubject) {
                            ForEach(appState.subjects, id: \ .self) { Text($0) }
                        }
                        .frame(width: 220)

                        TextField("Topic", text: $addTopic)
                            .textFieldStyle(.roundedBorder)
                    }

                    TextField("Front", text: $addFront, axis: .vertical)
                        .lineLimit(3...
                            6)
                        .textFieldStyle(.roundedBorder)

                    TextField("Back", text: $addBack, axis: .vertical)
                        .lineLimit(3...
                            6)
                        .textFieldStyle(.roundedBorder)

                    Button("Add card") {
                        appState.addCard(subject: addSubject, topic: addTopic, front: addFront, back: addBack)
                        addFront = ""
                        addBack = ""
                        addTopic = ""
                    }
                }
                .padding()
                .background(Color(NSColor.controlBackgroundColor))
                .cornerRadius(12)

                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Flashcards")
                            .font(.headline)
                        Spacer()
                        Picker("Subject", selection: Binding(get: { appState.selectedSubject }, set: { appState.selectedSubject = $0 })) {
                            ForEach(appState.subjects, id: \ .self) { Text($0) }
                        }
                        .frame(width: 220)
                    }

                    if appState.data.cards.isEmpty {
                        Text("No cards yet.")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(cards) { card in
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(card.front)
                                        .fontWeight(.semibold)
                                    Spacer()
                                    Text("Box \(card.box)")
                                        .foregroundStyle(.secondary)
                                }
                                Text(card.back)
                                HStack {
                                    Button("Missed") { appState.gradeCard(card.id, rating: 0) }
                                    Button("Hard") { appState.gradeCard(card.id, rating: 1) }
                                    Button("Medium") { appState.gradeCard(card.id, rating: 2) }
                                    Button("Easy") { appState.gradeCard(card.id, rating: 3) }
                                    Spacer()
                                    Button("Pause") { appState.toggleSuspend(card.id) }
                                    Button("Delete") { appState.deleteCard(card.id) }
                                }
                                .buttonStyle(.bordered)
                            }
                            .padding(10)
                            .background(Color(NSColor.textBackgroundColor))
                            .cornerRadius(10)
                        }
                    }
                }
                .padding()
                .background(Color(NSColor.controlBackgroundColor))
                .cornerRadius(12)
            }
            .padding()
        }
    }
}

struct PapersView: View {
    @EnvironmentObject var appState: AppState
    @State private var title: String = ""
    @State private var link: String = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Add a paper")
                        .font(.headline)

                    HStack {
                        Picker("Subject", selection: Binding(get: { appState.selectedSubject }, set: { appState.selectedSubject = $0 })) {
                            ForEach(appState.subjects, id: \ .self) { Text($0) }
                        }
                        .frame(width: 220)

                        TextField("Title", text: $title)
                            .textFieldStyle(.roundedBorder)
                    }

                    TextField("Link", text: $link)
                        .textFieldStyle(.roundedBorder)

                    Button("Save paper") {
                        appState.addPaper(subject: appState.selectedSubject, title: title, link: link)
                        title = ""
                        link = ""
                    }
                }
                .padding()
                .background(Color(NSColor.controlBackgroundColor))
                .cornerRadius(12)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Past papers")
                        .font(.headline)

                    ForEach(appState.data.papers) { paper in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(paper.title)
                                    .fontWeight(.semibold)
                                Text(paper.subject)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Toggle("Done", isOn: Binding(get: { paper.done }, set: { _ in appState.updatePaperDone(paper.id, done: !$0) }))
                        }
                        .padding(8)
                        .background(Color(NSColor.textBackgroundColor))
                        .cornerRadius(8)
                    }
                }
                .padding()
                .background(Color(NSColor.controlBackgroundColor))
                .cornerRadius(12)
            }
            .padding()
        }
    }
}

struct NotesView: View {
    @EnvironmentObject var appState: AppState
    @State private var title: String = ""
    @State private var content: String = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("New note")
                        .font(.headline)

                    Picker("Subject", selection: Binding(get: { appState.selectedSubject }, set: { appState.selectedSubject = $0 })) {
                        ForEach(appState.subjects, id: \ .self) { Text($0) }
                    }
                    .frame(width: 240)

                    TextField("Title", text: $title)
                        .textFieldStyle(.roundedBorder)

                    TextEditor(text: $content)
                        .frame(minHeight: 140)
                        .padding(4)
                        .background(Color(NSColor.textBackgroundColor))
                        .cornerRadius(8)

                    Button("Save note") {
                        appState.addNote(subject: appState.selectedSubject, title: title, content: content)
                        title = ""
                        content = ""
                    }
                }
                .padding()
                .background(Color(NSColor.controlBackgroundColor))
                .cornerRadius(12)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Saved notes")
                        .font(.headline)

                    ForEach(appState.data.notes) { note in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(note.title)
                                    .fontWeight(.semibold)
                                Spacer()
                                Button("Delete") { appState.deleteNote(note.id) }
                                    .buttonStyle(.borderless)
                            }
                            Text(note.subject)
                                .foregroundColor(.secondary)
                            Text(note.content)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(10)
                        .background(Color(NSColor.textBackgroundColor))
                        .cornerRadius(8)
                    }
                }
                .padding()
                .background(Color(NSColor.controlBackgroundColor))
                .cornerRadius(12)
            }
            .padding()
        }
    }
}

struct CalendarView: View {
    @EnvironmentObject var appState: AppState
    @State private var title: String = ""
    @State private var eventDate = Date()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Add event")
                        .font(.headline)

                    HStack {
                        Picker("Subject", selection: Binding(get: { appState.selectedSubject }, set: { appState.selectedSubject = $0 })) {
                            ForEach(appState.subjects, id: \ .self) { Text($0) }
                        }
                        .frame(width: 220)

                        Picker("Type", selection: .constant("Homework")) {
                            Text("Homework").tag("Homework")
                            Text("Test").tag("Test")
                            Text("Mock").tag("Mock")
                        }
                        .frame(width: 150)
                    }

                    DatePicker("Date", selection: $eventDate, displayedComponents: [.date])

                    TextField("Title", text: $title)
                        .textFieldStyle(.roundedBorder)

                    Button("Add event") {
                        appState.addEvent(subject: appState.selectedSubject, kind: "Homework", title: title, day: eventDate)
                        title = ""
                    }
                }
                .padding()
                .background(Color(NSColor.controlBackgroundColor))
                .cornerRadius(12)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Upcoming")
                        .font(.headline)

                    ForEach(appState.data.events.sorted { $0.day < $1.day }) { event in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(event.title)
                                    .fontWeight(.semibold)
                                Text("\(event.subject) • \(event.kind)")
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Text(event.day.formatted(date: .abbreviated, time: .omitted))
                            Button("Delete") { appState.deleteEvent(event.id) }
                                .buttonStyle(.borderless)
                        }
                        .padding(8)
                        .background(Color(NSColor.textBackgroundColor))
                        .cornerRadius(8)
                    }
                }
                .padding()
                .background(Color(NSColor.controlBackgroundColor))
                .cornerRadius(12)
            }
            .padding()
        }
    }
}

struct EssayPlannerView: View {
    @EnvironmentObject var appState: AppState
    @State private var essayTitle: String = ""
    @State private var essaySubject: String = "Economics (Edexcel)"
    @State private var essayMarks: String = "25"
    @State private var essayPlan: String = "Intro\nAnalysis\nEvaluation\nConclusion"
    @State private var essayBody: String = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Essay planner")
                        .font(.headline)

                    Picker("Subject", selection: $essaySubject) {
                        ForEach(appState.subjects, id: \ .self) { Text($0) }
                    }
                    .frame(width: 250)

                    HStack {
                        TextField("Title", text: $essayTitle)
                            .textFieldStyle(.roundedBorder)
                        TextField("Marks", text: $essayMarks)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 100)
                    }

                    TextField("Plan", text: $essayPlan, axis: .vertical)
                        .lineLimit(4...8)
                        .textFieldStyle(.roundedBorder)

                    TextEditor(text: $essayBody)
                        .frame(minHeight: 200)
                        .padding(4)
                        .background(Color(NSColor.textBackgroundColor))
                        .cornerRadius(8)

                    Button("Save essay") {
                        if let marks = Int(essayMarks) {
                            appState.addEssay(subject: essaySubject, title: essayTitle, marks: marks, plan: essayPlan, body: essayBody)
                        }
                    }
                }
                .padding()
                .background(Color(NSColor.controlBackgroundColor))
                .cornerRadius(12)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Saved essays")
                        .font(.headline)

                    ForEach(appState.data.essays) { essay in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(essay.title)
                                    .fontWeight(.semibold)
                                Spacer()
                                Button("Delete") { appState.deleteEssay(essay.id) }
                                    .buttonStyle(.borderless)
                            }
                            Text("\(essay.subject) • \(essay.marks) marks")
                                .foregroundColor(.secondary)
                            Text(essay.plan)
                        }
                        .padding(10)
                        .background(Color(NSColor.textBackgroundColor))
                        .cornerRadius(8)
                    }
                }
                .padding()
                .background(Color(NSColor.controlBackgroundColor))
                .cornerRadius(12)
            }
            .padding()
        }
    }
}
