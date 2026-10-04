import SwiftUI
import Foundation
import Combine

// MARK: - Data Models
struct Card: Identifiable, Codable {
    var id: UUID
    var subject: String
    var topic: String
    var front: String
    var back: String
    var box: Int
    var due: Date
    var suspended: Bool
    var misses: Int

    init(id: UUID = UUID(), subject: String, topic: String = "", front: String, back: String, box: Int = 0, due: Date = Date(), suspended: Bool = false, misses: Int = 0) {
        self.id = id
        self.subject = subject
        self.topic = topic
        self.front = front
        self.back = back
        self.box = box
        self.due = due
        self.suspended = suspended
        self.misses = misses
    }
}

struct StudySession: Identifiable, Codable {
    var id: UUID
    var subject: String
    var minutes: Double
    var note: String
    var day: Date

    init(id: UUID = UUID(), subject: String, minutes: Double, note: String = "", day: Date = Date()) {
        self.id = id
        self.subject = subject
        self.minutes = minutes
        self.note = note
        self.day = day
    }
}

struct Paper: Identifiable, Codable {
    var id: UUID
    var subject: String
    var title: String
    var link: String
    var kind: String
    var done: Bool
    var score: Double?
    var maxScore: Double?
    var doneOn: Date?

    init(id: UUID = UUID(), subject: String, title: String, link: String, kind: String = "link", done: Bool = false, score: Double? = nil, maxScore: Double? = nil, doneOn: Date? = nil) {
        self.id = id
        self.subject = subject
        self.title = title
        self.link = link
        self.kind = kind
        self.done = done
        self.score = score
        self.maxScore = maxScore
        self.doneOn = doneOn
    }
}

struct Note: Identifiable, Codable {
    var id: UUID
    var subject: String
    var title: String
    var content: String
    var created: Date

    init(id: UUID = UUID(), subject: String, title: String, content: String, created: Date = Date()) {
        self.id = id
        self.subject = subject
        self.title = title
        self.content = content
        self.created = created
    }
}

struct CalendarEvent: Identifiable, Codable {
    var id: UUID
    var subject: String
    var kind: String
    var title: String
    var day: Date
    var done: Bool

    init(id: UUID = UUID(), subject: String, kind: String, title: String, day: Date, done: Bool = false) {
        self.id = id
        self.subject = subject
        self.kind = kind
        self.title = title
        self.day = day
        self.done = done
    }
}

struct Essay: Identifiable, Codable {
    var id: UUID
    var subject: String
    var title: String
    var marks: Int
    var score: Int?
    var status: String
    var plan: String
    var body: String
    var feedback: String
    var updated: Date

    init(id: UUID = UUID(), subject: String, title: String, marks: Int = 12, score: Int? = nil, status: String = "Planning", plan: String = "", body: String = "", feedback: String = "", updated: Date = Date()) {
        self.id = id
        self.subject = subject
        self.title = title
        self.marks = marks
        self.score = score
        self.status = status
        self.plan = plan
        self.body = body
        self.feedback = feedback
        self.updated = updated
    }
}

struct AppData: Codable {
    static let defaultSubjects = [
        "Maths (Edexcel)",
        "Further Maths (Edexcel)",
        "Economics (Edexcel)",
        "Religious Studies (OCR)"
    ]

    var cards: [Card]
    var sessions: [StudySession]
    var papers: [Paper]
    var notes: [Note]
    var essays: [Essay]
    var events: [CalendarEvent]
    var settings: [String: String]
}

// MARK: - Data Manager
final class DataManager {
    static let shared = DataManager()

    private let fileURL: URL

    init() {
        let support = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first ?? FileManager.default.homeDirectoryForCurrentUser
        let appFolder = support.appendingPathComponent("StudyBuddyApp", isDirectory: true)
        try? FileManager.default.createDirectory(at: appFolder, withIntermediateDirectories: true)
        self.fileURL = appFolder.appendingPathComponent("studybuddy-data.json")
    }

    func makeSampleData() -> AppData {
        let now = Date()
        let threeDaysAgo = Calendar.current.date(byAdding: .day, value: -3, to: now) ?? now
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: now) ?? now

        let sampleCards = [
            Card(subject: "Maths (Edexcel)", topic: "Differentiation", front: "Differentiate x^n", back: "nx^(n-1)", box: 1, due: now),
            Card(subject: "Maths (Edexcel)", topic: "Integration", front: "Integrate 1/x", back: "ln|x| + C", box: 2, due: now),
            Card(subject: "Economics (Edexcel)", topic: "Elasticity", front: "PED formula", back: "% change in quantity demanded / % change in price", box: 0, due: threeDaysAgo),
            Card(subject: "Religious Studies (OCR)", topic: "Ethics", front: "Kant's categorical imperative", back: "Universal law; humanity as an end; kingdom of ends", box: 3, due: tomorrow)
        ]

        let sampleSessions = [
            StudySession(subject: "Maths (Edexcel)", minutes: 60, note: "Differentiation practice", day: now),
            StudySession(subject: "Economics (Edexcel)", minutes: 45, note: "Elasticity review", day: Date().addingTimeInterval(-86400))
        ]

        let samplePapers = [
            Paper(subject: "Maths (Edexcel)", title: "June 2024 Paper 1", link: "https://example.com/paper1.pdf", kind: "link", done: false),
            Paper(subject: "Economics (Edexcel)", title: "Micro essay practice", link: "https://example.com/econ-essay.pdf", kind: "link", done: true, score: 68, maxScore: 100, doneOn: now)
        ]

        let sampleNotes = [
            Note(subject: "Maths (Edexcel)", title: "Chain rule", content: "Use dy/dx = dy/du * du/dx", created: now),
            Note(subject: "Economics (Edexcel)", title: "Externalities", content: "A cost or benefit to a third party not reflected in the market price.", created: now)
        ]

        let sampleEssays = [
            Essay(subject: "Economics (Edexcel)", title: "Evaluate a carbon tax", marks: 25, status: "Planning", plan: "Intro\nArguments\nEvaluation\nConclusion")
        ]

        let sampleEvents = [
            CalendarEvent(subject: "Maths (Edexcel)", kind: "Homework", title: "Differentiation worksheet", day: tomorrow, done: false),
            CalendarEvent(subject: "Religious Studies (OCR)", kind: "Test", title: "Ethics quiz", day: now, done: false)
        ]

        return AppData(
            cards: sampleCards,
            sessions: sampleSessions,
            papers: samplePapers,
            notes: sampleNotes,
            essays: sampleEssays,
            events: sampleEvents,
            settings: ["goalMinutes": "60", "theme": "system"]
        )
    }

    func load() -> AppData {
        do {
            let data = try Data(contentsOf: fileURL)
            let decoded = try JSONDecoder().decode(AppData.self, from: data)
            return decoded
        } catch {
            let data = makeSampleData()
            save(data)
            return data
        }
    }

    func save(_ data: AppData) {
        do {
            let encoded = try JSONEncoder().encode(data)
            try encoded.write(to: fileURL)
        } catch {
            print("Failed to write StudyBuddy data: \(error)")
        }
    }

    func resetDemoData() {
        save(makeSampleData())
    }
}

// MARK: - App State
final class AppState: NSObject, ObservableObject {
    @Published var data: AppData
    @Published var selectedSubject: String

    init() {
        self.data = DataManager.shared.load()
        self.selectedSubject = AppData.defaultSubjects.first ?? "Maths (Edexcel)"
    }

    func save() {
        DataManager.shared.save(data)
    }

    func reload() {
        data = DataManager.shared.load()
    }

    func resetDemoData() {
        DataManager.shared.resetDemoData()
        data = DataManager.shared.load()
    }

    func addCard(subject: String, topic: String, front: String, back: String) {
        guard !front.isEmpty, !back.isEmpty else { return }
        let card = Card(subject: subject, topic: topic, front: front, back: back)
        data.cards.insert(card, at: 0)
        save()
    }

    func deleteCard(_ id: UUID) {
        data.cards.removeAll { $0.id == id }
        save()
    }

    func toggleSuspend(_ id: UUID) {
        if let index = data.cards.firstIndex(where: { $0.id == id }) {
            data.cards[index].suspended.toggle()
            save()
        }
    }

    func gradeCard(_ id: UUID, rating: Int) {
        guard let index = data.cards.firstIndex(where: { $0.id == id }) else { return }
        var card = data.cards[index]
        let box = card.box
        let nextBox = [0, box, min(box + 1, 5), min(box + 2, 5)][max(0, min(3, rating))]
        let intervals = [0, 1, 2, 4, 8, 16]
        let interval = intervals[min(nextBox, intervals.count - 1)]
        let days: Int = rating == 0 ? 0 : interval

        card.box = nextBox
        card.due = rating == 0 ? Date() : Calendar.current.date(byAdding: .day, value: days, to: Date()) ?? Date()
        card.misses = rating == 0 ? card.misses + 1 : max(card.misses - 1, 0)
        data.cards[index] = card
        save()
    }

    func addSession(subject: String, minutes: Double, note: String = "") {
        let session = StudySession(subject: subject, minutes: minutes, note: note, day: Date())
        data.sessions.insert(session, at: 0)
        save()
    }

    func deleteSession(_ id: UUID) {
        data.sessions.removeAll { $0.id == id }
        save()
    }

    func addPaper(subject: String, title: String, link: String) {
        guard !title.isEmpty, !link.isEmpty else { return }
        data.papers.insert(Paper(subject: subject, title: title, link: link), at: 0)
        save()
    }

    func updatePaperDone(_ id: UUID, done: Bool) {
        if let index = data.papers.firstIndex(where: { $0.id == id }) {
            data.papers[index].done = done
            data.papers[index].doneOn = done ? Date() : nil
            save()
        }
    }

    func addNote(subject: String, title: String, content: String) {
        guard !title.isEmpty else { return }
        data.notes.insert(Note(subject: subject, title: title, content: content), at: 0)
        save()
    }

    func deleteNote(_ id: UUID) {
        data.notes.removeAll { $0.id == id }
        save()
    }

    func addEvent(subject: String, kind: String, title: String, day: Date) {
        guard !title.isEmpty else { return }
        data.events.insert(CalendarEvent(subject: subject, kind: kind, title: title, day: day), at: 0)
        save()
    }

    func deleteEvent(_ id: UUID) {
        data.events.removeAll { $0.id == id }
        save()
    }

    func addEssay(subject: String, title: String, marks: Int, plan: String, body: String) {
        data.essays.insert(Essay(subject: subject, title: title, marks: marks, plan: plan, body: body), at: 0)
        save()
    }

    func deleteEssay(_ id: UUID) {
        data.essays.removeAll { $0.id == id }
        save()
    }

    var todayMinutes: Double {
        let today = Calendar.current.startOfDay(for: Date())
        return data.sessions.filter { Calendar.current.isDate($0.day, inSameDayAs: today) }.reduce(0) { $0 + $1.minutes }
    }

    var dueCards: [Card] {
        let now = Date()
        return data.cards.filter { !$0.suspended && $0.due <= now }
    }

    var subjects: [String] {
        AppData.defaultSubjects
    }
}

// MARK: - Main App
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

// MARK: - Content View
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

// MARK: - Tracker View
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
                    Text("Log study time").font(.headline)
                    HStack {
                        Picker("Subject", selection: Binding(get: { appState.selectedSubject }, set: { appState.selectedSubject = $0 })) {
                            ForEach(appState.subjects, id: \.self) { Text($0) }
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
                    Text("Recent sessions").font(.headline)

                    if appState.data.sessions.isEmpty {
                        Text("No study sessions logged yet.").foregroundColor(.secondary)
                    } else {
                        ForEach(appState.data.sessions.prefix(8)) { session in
                            HStack {
                                Text(session.subject)
                                Spacer()
                                Text("\(Int(session.minutes)) min")
                                if !session.note.isEmpty {
                                    Text("• \(session.note)").foregroundColor(.secondary)
                                }
                                Button("Delete") { appState.deleteSession(session.id) }
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
            Text(value).font(.title2).fontWeight(.semibold)
            Text(title).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, minHeight: 70)
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(12)
    }
}

// MARK: - Flashcards View
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
                    Text("Add a card").font(.headline)

                    HStack {
                        Picker("Subject", selection: $addSubject) {
                            ForEach(appState.subjects, id: \.self) { Text($0) }
                        }
                        .frame(width: 220)

                        TextField("Topic", text: $addTopic)
                            .textFieldStyle(.roundedBorder)
                    }

                    TextField("Front", text: $addFront, axis: .vertical)
                        .lineLimit(3, 6)
                        .textFieldStyle(.roundedBorder)

                    TextField("Back", text: $addBack, axis: .vertical)
                        .lineLimit(3, 6)
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
                        Text("Flashcards").font(.headline)
                        Spacer()
                        Picker("Subject", selection: Binding(get: { appState.selectedSubject }, set: { appState.selectedSubject = $0 })) {
                            ForEach(appState.subjects, id: \.self) { Text($0) }
                        }
                        .frame(width: 220)
                    }

                    if appState.data.cards.isEmpty {
                        Text("No cards yet.").foregroundColor(.secondary)
                    } else {
                        ForEach(cards) { card in
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(card.front).fontWeight(.semibold)
                                    Spacer()
                                    Text("Box \(card.box)").foregroundStyle(.secondary)
                                }
                                Text(card.back)
                                HStack(spacing: 8) {
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

// MARK: - Papers View
struct PapersView: View {
    @EnvironmentObject var appState: AppState
    @State private var title: String = ""
    @State private var link: String = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Add a paper").font(.headline)

                    HStack {
                        Picker("Subject", selection: Binding(get: { appState.selectedSubject }, set: { appState.selectedSubject = $0 })) {
                            ForEach(appState.subjects, id: \.self) { Text($0) }
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
                    Text("Past papers").font(.headline)

                    ForEach(appState.data.papers) { paper in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(paper.title).fontWeight(.semibold)
                                Text(paper.subject).foregroundColor(.secondary)
                            }
                            Spacer()
                            Toggle("Done", isOn: Binding(
                                get: { paper.done },
                                set: { newValue in appState.updatePaperDone(paper.id, done: newValue) }
                            ))
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

// MARK: - Notes View
struct NotesView: View {
    @EnvironmentObject var appState: AppState
    @State private var title: String = ""
    @State private var content: String = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("New note").font(.headline)

                    Picker("Subject", selection: Binding(get: { appState.selectedSubject }, set: { appState.selectedSubject = $0 })) {
                        ForEach(appState.subjects, id: \.self) { Text($0) }
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
                    Text("Saved notes").font(.headline)

                    ForEach(appState.data.notes) { note in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(note.title).fontWeight(.semibold)
                                Spacer()
                                Button("Delete") { appState.deleteNote(note.id) }
                                    .buttonStyle(.borderless)
                            }
                            Text(note.subject).foregroundColor(.secondary)
                            Text(note.content).frame(maxWidth: .infinity, alignment: .leading)
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

// MARK: - Calendar View
struct CalendarView: View {
    @EnvironmentObject var appState: AppState
    @State private var title: String = ""
    @State private var eventDate = Date()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Add event").font(.headline)

                    HStack {
                        Picker("Subject", selection: Binding(get: { appState.selectedSubject }, set: { appState.selectedSubject = $0 })) {
                            ForEach(appState.subjects, id: \.self) { Text($0) }
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
                    Text("Upcoming").font(.headline)

                    ForEach(appState.data.events.sorted { $0.day < $1.day }) { event in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(event.title).fontWeight(.semibold)
                                Text("\(event.subject) • \(event.kind)").foregroundColor(.secondary)
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

// MARK: - Essay Planner View
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
                    Text("Essay planner").font(.headline)

                    Picker("Subject", selection: $essaySubject) {
                        ForEach(appState.subjects, id: \.self) { Text($0) }
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
                        .lineLimit(4, 8)
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
                    Text("Saved essays").font(.headline)

                    ForEach(appState.data.essays) { essay in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(essay.title).fontWeight(.semibold)
                                Spacer()
                                Button("Delete") { appState.deleteEssay(essay.id) }
                                    .buttonStyle(.borderless)
                            }
                            Text("\(essay.subject) • \(essay.marks) marks").foregroundColor(.secondary)
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
