import Foundation

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
            Card(subject: "Maths (Edexcel)", topic: "Differentiation", front: "Differentiate x^n", back: "nx^(n-1)", due: now, box: 1),
            Card(subject: "Maths (Edexcel)", topic: "Integration", front: "Integrate 1/x", back: "ln|x| + C", due: now, box: 2),
            Card(subject: "Economics (Edexcel)", topic: "Elasticity", front: "PED formula", back: "% change in quantity demanded / % change in price", due: threeDaysAgo, box: 0),
            Card(subject: "Religious Studies (OCR)", topic: "Ethics", front: "Kant's categorical imperative", back: "Universal law; humanity as an end; kingdom of ends", due: tomorrow, box: 3)
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
            settings: [
                "goalMinutes": "60",
                "theme": "system"
            ]
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
