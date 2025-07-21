import Foundation

class OptionViewModel: ObservableObject {
    @Published var options: [Option] = Option.load() {
        didSet { Option.save(options) }
    }
    @Published var selectedTags: Set<String> = []
    @Published var selectedOption: Option?
    
    var filteredOptions: [Option] {
        selectedTags.isEmpty ? options : options.filter { !Set($0.tags).isDisjoint(with: selectedTags) }
    }
    func addOption(name: String, tags: [String]) {
        options.append(Option(id: UUID(), name: name, tags: tags, weight: 1))
    }
    
    func removeOption(_ option: Option) {
        options.removeAll { $0.id == option.id }
    }
    
    func allTags() -> [String] {
        Set(options.flatMap { $0.tags }).sorted()
    }
    
    func decide() {
        let pool = filteredOptions.flatMap { Array(repeating: $0, count: max($0.weight,1)) }
        selectedOption = pool.randomElement()
    }
    
    func feedback(liked: Bool) {
        guard let sel = selectedOption, let idx = options.firstIndex(of: sel) else { return }
        options[idx].weight += liked ? 1 : -1
        options[idx].weight = max(options[idx].weight, 1)
    }
} 
