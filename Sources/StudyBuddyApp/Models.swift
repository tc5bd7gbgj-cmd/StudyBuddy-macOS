import Foundation

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
