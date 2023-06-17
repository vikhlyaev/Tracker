import Foundation

final class MockData {
    
    static let shared = MockData()
    
    var categories: [TrackerCategory] = [
        TrackerCategory(
            name: "Домашние дела",
            trackers: [
                Tracker(name: "Поливать цветы", color: .colorSelection11, emoji: "🌼", schedule: [.monday, .thursday]),
                Tracker(name: "Съедать яблоко", color: .colorSelection4, emoji: "🍎", schedule: [.wednesday]),
                Tracker(name: "Готовить ужин по рецепту", color: .colorSelection18, emoji: "🥘", schedule: [.monday, .wednesday, .friday]),
                Tracker(name: "Прикинуться алладином", color: .colorSelection2, emoji: "🧞‍♂️", schedule: [.monday]),
                Tracker(name: "Вязать кофту", color: .colorSelection17, emoji: "🧶", schedule: [.wednesday]),
                Tracker(name: "Слепить снеговика", color: .colorSelection8, emoji: "⛄️", schedule: [.friday])
            ]
        ),
        TrackerCategory(
            name: "По работе",
            trackers: [
                Tracker(name: "Отправлять отчет", color: .colorSelection13, emoji: "✉️", schedule: [.monday]),
                Tracker(name: "Провести оперативку", color: .colorSelection16, emoji: "🥷🏻", schedule: [.wednesday]),
                Tracker(name: "Поплакать", color: .colorSelection1, emoji: "😭", schedule: [.friday])
            ]
        )
    ]
    
    private init() {}
    
}
