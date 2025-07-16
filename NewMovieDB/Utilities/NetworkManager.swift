import Reachability

class NetworkManager {

    static let shared = NetworkManager()
    private var reachability: Reachability?

    private init() {
        do {
            reachability = try Reachability()
            try reachability?.startNotifier()
        } catch {
            print("Reachability setup failed: \(error)")
        }
    }

    var isConnectionUnavailable: Bool {
        return reachability?.connection == .unavailable
    }

    func startMonitoring() {
        reachability?.whenReachable = { reachability in
            print("Connected: \(reachability.connection.description)")
        }

        reachability?.whenUnreachable = { _ in
            print("No internet connection")
        }
    }

    func stopMonitoring() {
        reachability?.stopNotifier()
    }
}
