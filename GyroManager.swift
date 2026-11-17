import Foundation
import CoreMotion
import Combine

class GyroManager: ObservableObject {
    private var motionManager = CMMotionManager()
    @Published var pitch: Double = 0.0
    @Published var yaw: Double = 0.0
    @Published var isActive: Bool = false
    
    func startGyro(sensitivity: Double) {
        guard motionManager.isGyroAvailable else { return }
        motionManager.gyroUpdateInterval = 1.0 / 120.0 // 120Hz polling for iPad Pro
        motionManager.startGyroUpdates(to: .main) { [weak self] data, error in
            guard let data = data, error == nil else { return }
            self?.pitch = data.rotationRate.x * sensitivity
            self?.yaw = data.rotationRate.y * sensitivity
        }
        isActive = true
    }
    
    func stopGyro() {
        motionManager.stopGyroUpdates()
        isActive = false
    }
}
