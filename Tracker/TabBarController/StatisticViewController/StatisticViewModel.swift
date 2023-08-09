
final class StatisticViewModel {
    
    private let trackerService = TrackerService.shared
    
    @Observable
    private(set) var isPlaceholderHidden = true
    
    @Observable
    private(set) var bestPeriodValue = 0
    
    @Observable
    private(set) var bestDaysValue = 0
    
    @Observable
    private(set) var completedTrackerValue = 0
    
    @Observable
    private(set) var averageValue = 0
    
    
    func viewDidLoad() {
        observeCompletedTrackers()
        isShowingStatistic()
    }
    
    
    func observeCompletedTrackers() {
        completedTrackerValue = trackerService.completedTrackers.count
        trackerService.$completedTrackers.bind {[weak self] completedTrackers in
            self?.completedTrackerValue = completedTrackers.count
            self?.isShowingStatistic()
        }
    }
    
    func isShowingStatistic() {
        if bestPeriodValue == 0 &&
            bestDaysValue == 0 &&
            completedTrackerValue == 0 &&
            averageValue == 0 {
            isPlaceholderHidden = false
            
        } else {
            isPlaceholderHidden = true
        }
    }
    
    
}
