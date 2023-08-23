import Foundation


final class AnalyticsService {
    
    static let shared = AnalyticsService()
    private let yandexService = YandexMetricaService.shared
    private let openTracker = "open"
    private let trackerClosed = "closed"
    private let trackerTapped = "tapped"
    
    
    private let screenParamKey = "screen"
    private let itemParamKey = "item"
    
    private let mainScreen = "Main"
    
    private init() { }
    
    func screenEventDidShowed() {
        yandexService.sendEvent(event: openTracker, params: [screenParamKey: mainScreen])
    }
    
    func screenEventDidDisappear() {
        yandexService.sendEvent(event: trackerClosed, params: [screenParamKey: mainScreen])
    }
    
    func screenAddNewTracker() {
        yandexService.sendEvent(event: trackerTapped, params: [screenParamKey: mainScreen, itemParamKey: "add_Tracker"])
    }
    
    func sendEditTrackerEvent() {
        yandexService.sendEvent(event: trackerTapped, params: [screenParamKey: mainScreen, itemParamKey: "edit"])
    }
    
    func sendTrackerTapEvent() {
        yandexService.sendEvent(event: trackerTapped, params: [screenParamKey: mainScreen, itemParamKey: "track"])
    }
    
    func sendTrackerDeleteEvent() {
        yandexService.sendEvent(event: trackerTapped, params: [screenParamKey: mainScreen, itemParamKey: "delete"])
    }
    
    func sendTrackerFilterEvent() {
        yandexService.sendEvent(event: trackerTapped, params: [screenParamKey: mainScreen, itemParamKey: "filter"])
    }
}
