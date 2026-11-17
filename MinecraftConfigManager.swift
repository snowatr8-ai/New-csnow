import Foundation

class MinecraftConfigManager: ObservableObject {
    @Published var installedPacks: [String] = [
        "Default Edit 1.8.9 PvP [16x]",
        "Snow Smooth FPS Boost Pack",
        "Clean UI & Low Fire"
    ]
    @Published var activePack: String = "Default Edit 1.8.9 PvP [16x]"
    @Published var statusMessage: String = "جاهز للتشغيل"
    
    // Export modified options.txt so user can place it in Minecraft/games/com.mojang/minecraftpe/
    func generateModifiedOptions(vsyncDisabled: Bool, maxFps: Int) -> URL? {
        let vsyncVal = vsyncDisabled ? "0" : "1"
        let content = """
        gfx_vsync:\(vsyncVal)
        gfx_max_framerate:\(maxFps)
        gfx_renderdistance_new:12
        gfx_fancygraphics:0
        gfx_fancyskies:0
        gfx_smoothlighting:0
        """
        
        let tempDir = FileManager.default.temporaryDirectory
        let fileURL = tempDir.appendingPathComponent("options.txt")
        do {
            try content.write(to: fileURL, atomically: true, encoding: .utf8)
            statusMessage = "تم تحديث إعدادات V-Sync والفريمات بنجاح"
            return fileURL
        } catch {
            statusMessage = "خطأ في حفظ الملف"
            return nil
        }
    }
    
    func addPack(name: String) {
        if !installedPacks.contains(name) {
            installedPacks.append(name)
            activePack = name
            statusMessage = "تم تفعيل: \(name)"
        }
    }
}
