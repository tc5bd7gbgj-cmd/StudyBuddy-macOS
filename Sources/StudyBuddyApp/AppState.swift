import Foundation
import SwiftUI

final class AppState: ObservableObject {
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
