import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @StateObject private var gyroManager = GyroManager()
    @StateObject private var configManager = MinecraftConfigManager()
    
    @State private var isVsyncDisabled: Bool = true
    @State private var gyroEnabled: Bool = true
    @State private var gyroSensitivity: Double = 1.8
    @State private var fpsLimit: Double = 120
    @State private var clawLayoutMode: String = "4-Finger Claw"
    @State private var showFileImporter: Bool = false
    @State private var showShareSheet: Bool = false
    @State private var exportedOptionsURL: URL?
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

    let clawModes = ["2-Finger", "3-Finger", "4-Finger Claw"]

    var body: some View {
        ZStack {
            // Deep Dark Gradient Background
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.05, green: 0.06, blue: 0.09), Color(red: 0.09, green: 0.11, blue: 0.16)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 16) {
                // Top Navigation Header
                HStack {
                    HStack(spacing: 12) {
                        Image(systemName: "snowflake")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.cyan)
                            .padding(10)
                            .background(Color.cyan.opacity(0.15))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("SNOW CLIENT")
                                .font(.system(size: 22, weight: .heavy, design: .rounded))
                                .foregroundColor(.white)
                            Text("iPadOS Bedrock Edition • \(configManager.statusMessage)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Spacer()
                    
                    // Export options.txt button
                    Button(action: {
                        if let url = configManager.generateModifiedOptions(vsyncDisabled: isVsyncDisabled, maxFps: Int(fpsLimit)) {
                            exportedOptionsURL = url
                            showShareSheet = true
                        }
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "square.and.arrow.up")
                            Text("تصدير الإعدادات")
                        }
                        .font(.subheadline.bold())
                        .padding(.horizontal, 14)
                        .padding(.vertical, 12)
                        .background(Color.white.opacity(0.1))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }

                    // Launch Minecraft Button
                    Button(action: launchMinecraft) {
                        HStack(spacing: 8) {
                            Image(systemName: "play.fill")
                            Text("تشغيل اللعبة")
                        }
                        .font(.headline)
                        .padding(.horizontal, 22)
                        .padding(.vertical, 12)
                        .background(
                            LinearGradient(colors: [.cyan, .blue], startPoint: .leading, endPoint: .trailing)
                        )
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(color: .cyan.opacity(0.4), radius: 8, x: 0, y: 4)
                    }
                }
                .padding()
                .background(Color.white.opacity(0.04))
                .cornerRadius(16)
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.08), lineWidth: 1))

                // Main Grid Content (Optimized for iPad Landscape/Portrait)
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                        
                        // Card 1: Performance & V-Sync Disabler
                        VStack(alignment: .leading, spacing: 14) {
                            Label("الأداء و V-Sync Disabler", systemImage: "bolt.fill")
                                .font(.headline)
                                .foregroundColor(.cyan)
                            
                            Toggle(isOn: $isVsyncDisabled) {
                                VStack(alignment: .leading) {
                                    Text("تعطيل V-Sync")
                                        .font(.subheadline.bold())
                                    Text("تقليل تأخير اللمس (Input Lag) لأقصى استجابة")
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                }
                            }
                            .tint(.cyan)
                            
                            Divider().background(Color.white.opacity(0.1))
                            
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text("سقف الفريمات (FPS Limit)")
                                        .font(.subheadline)
                                    Spacer()
                                    Text("\(Int(fpsLimit)) FPS")
                                        .font(.subheadline.bold())
                                        .foregroundColor(.cyan)
                                }
                                Slider(value: $fpsLimit, in: 60...240, step: 30)
                                    .tint(.cyan)
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.04))
                        .cornerRadius(16)
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.08), lineWidth: 1))

                        // Card 2: iPad Gyroscope Engine
                        VStack(alignment: .leading, spacing: 14) {
                            Label("محرك الجيروسكوب (iPad Gyro)", systemImage: "gyroscope")
                                .font(.headline)
                                .foregroundColor(.purple)
                            
                            Toggle(isOn: $gyroEnabled) {
                                VStack(alignment: .leading) {
                                    Text("تفعيل التوجيه بالجيروسكوب")
                                        .font(.subheadline.bold())
                                    Text("تحكم دقيق بالكاميرا والـ Aim عبر حركة الآيباد")
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                }
                            }
                            .tint(.purple)
                            .onChange(of: gyroEnabled) { enabled in
                                if enabled {
                                    gyroManager.startGyro(sensitivity: gyroSensitivity)
                                } else {
                                    gyroManager.stopGyro()
                                }
                            }
                            
                            Divider().background(Color.white.opacity(0.1))
                            
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text("حساسية الجيروسكوب")
                                        .font(.subheadline)
                                    Spacer()
                                    Text("\(String(format: "%.1f", gyroSensitivity))x")
                                        .font(.subheadline.bold())
                                        .foregroundColor(.purple)
                                }
                                Slider(value: $gyroSensitivity, in: 0.5...5.0, step: 0.1)
                                    .tint(.purple)
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.04))
                        .cornerRadius(16)
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.08), lineWidth: 1))

                        // Card 3: In-Game Pack Changer
                        VStack(alignment: .leading, spacing: 14) {
                            HStack {
                                Label("مُغير الباكات (Pack Changer)", systemImage: "shippingbox.fill")
                                    .font(.headline)
                                    .foregroundColor(.orange)
                                Spacer()
                                Button(action: { showFileImporter = true }) {
                                    Label("استيراد باك", systemImage: "plus.circle.fill")
                                        .font(.caption.bold())
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                        .background(Color.orange.opacity(0.2))
                                        .foregroundColor(.orange)
                                        .cornerRadius(8)
                                }
                            }
                            
                            ForEach(configManager.installedPacks, id: \.self) { pack in
                                HStack {
                                    Image(systemName: configManager.activePack == pack ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(configManager.activePack == pack ? .green : .gray)
                                    Text(pack)
                                        .font(.subheadline)
                                        .lineLimit(1)
                                    Spacer()
                                    if configManager.activePack == pack {
                                        Text("مُفعّل")
                                            .font(.caption2.bold())
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(Color.green.opacity(0.2))
                                            .foregroundColor(.green)
                                            .cornerRadius(6)
                                    }
                                }
                                .padding(10)
                                .background(Color.black.opacity(0.25))
                                .cornerRadius(10)
                                .onTapGesture {
                                    configManager.activePack = pack
                                    configManager.statusMessage = "تم اختيار: \(pack)"
                                }
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.04))
                        .cornerRadius(16)
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.08), lineWidth: 1))

                        // Card 4: iPad PvP HUD & Layout
                        VStack(alignment: .leading, spacing: 14) {
                            Label("تخصيص التحكم للآيباد (PvP HUD)", systemImage: "ipad.landscape")
                                .font(.headline)
                                .foregroundColor(.green)
                            
                            Text("وضع الأصابع المفضل:")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            Picker("Claw Mode", selection: $clawLayoutMode) {
                                ForEach(clawModes, id: \.self) { mode in
                                    Text(mode).tag(mode)
                                }
                            }
                            .pickerStyle(.segmented)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: "scope")
                                        .foregroundColor(.green)
                                    Text("تفعيل Zoom السريع + Toggle Sprint")
                                        .font(.caption)
                                }
                                HStack {
                                    Image(systemName: "eye")
                                        .foregroundColor(.green)
                                    Text("تفعيل FreeLook 360° (منظور حر)")
                                        .font(.caption)
                                }
                            }
                            .padding(.top, 4)
                        }
                        .padding()
                        .background(Color.white.opacity(0.04))
                        .cornerRadius(16)
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.08), lineWidth: 1))
                    }
                }
            }
            .padding()
        }
        .onAppear {
            if gyroEnabled {
                gyroManager.startGyro(sensitivity: gyroSensitivity)
            }
        }
        .fileImporter(
            isPresented: $showFileImporter,
            allowedContentTypes: [.zip, .data],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let urls):
                if let url = urls.first {
                    configManager.addPack(name: url.lastPathComponent)
                }
            case .failure(let error):
                alertMessage = "فشل استيراد الباك: \(error.localizedDescription)"
                showAlert = true
            }
        }
        .sheet(isPresented: $showShareSheet) {
            if let url = exportedOptionsURL {
                ShareSheet(activityItems: [url])
            }
        }
        .alert("تنبيه", isPresented: $showAlert) {
            Button("حسناً", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }

    func launchMinecraft() {
        _ = configManager.generateModifiedOptions(vsyncDisabled: isVsyncDisabled, maxFps: Int(fpsLimit))
        if let url = URL(string: "minecraft://") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                alertMessage = "تطبيق ماينكرافت غير مثبت على هذا الجهاز أو يحتاج تفعيل URL Scheme."
                showAlert = true
            }
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    var activityItems: [Any]
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
