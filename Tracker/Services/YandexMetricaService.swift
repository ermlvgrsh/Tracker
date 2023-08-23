import YandexMobileMetrica

final class YandexMetricaService {
    static let shared = YandexMetricaService()
    private let apiKey = "0e94d3bd-2c7d-4202-9a87-663317cd3a83"
    private init() {}
    
    func activate() {
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: apiKey) else { return }
        YMMYandexMetrica.activate(with: configuration)
    }
    
    func sendEvent(event: String, params: [AnyHashable: Any]? = nil) {
        YMMYandexMetrica.reportEvent(event, parameters: params)
        
    }
}
