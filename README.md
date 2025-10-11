# DecideForMe - iOS Decision Making App

A SwiftUI iOS application that helps users make decisions through three distinct features: customizable list decisions, location-based place recommendations, and image marking selections.

## 🚀 Features

### 1. **Delivery Decision**
- Create custom lists with options and tags
- Apply filters to narrow down choices
- Weighted random selection based on user feedback
- Like/dislike feedback system to improve future selections
- Persistent storage using UserDefaults

### 2. **Map Decision**
- Search for nearby places using Google Places API
- Filter results by distance and rating
- Location-based recommendations using device GPS
- Fallback to Toronto location if permission denied
- Weighted selection combining distance and user feedback
- Interactive map display with place details
- Persistent place preferences

### 3. **Image Marking Decision**
- Select or capture photos from camera/photo library
- Add numbered marks on images by tapping
- Long-press to rename marks
- Random selection from marked locations
- Visual feedback for selected marks

## 🛠 Technical Stack

- **Framework:** SwiftUI (iOS 16+)
- **Architecture:** MVVM (Model-View-ViewModel)
- **Data Persistence:** UserDefaults
- **Networking:** URLSession for Google Places API
- **Location Services:** CoreLocation
- **Image Handling:** PhotosUI, UIKit integration
- **Testing:** XCTest framework
- **API:** Google Places API, Maps JavaScript API

## 📱 Screenshots

*[Screenshots would be added here]*

## 🔧 Setup Instructions

### Prerequisites
- Xcode 15.0+
- iOS 16.0+ deployment target
- Google Places API key

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/DecideForMe.git
   cd DecideForMe
   ```

2. **Configure Google Places API**
   - Create a project in [Google Cloud Console](https://console.cloud.google.com/)
   - Enable Places API and Maps JavaScript API
   - Create an API key with iOS app restrictions
   - Copy your API key

3. **Set up API Key**
   - Create `Secrets.xcconfig` file in the project root:
     ```
     GOOGLE_PLACES_API_KEY=your_actual_api_key_here
     ```
   - In Xcode: Project Settings → Info → Configurations → Set to `Secrets.xcconfig`

4. **Build and Run**
   - Open `DecideForMe.xcodeproj` in Xcode
   - Select your target device/simulator
   - Build and run the project (⌘+R)

### Security Notes
- `Secrets.xcconfig` is included in `.gitignore` to prevent API key exposure
- Never commit API keys to version control
- Use environment-specific configuration files for different build targets

## 🏗 Project Structure

```
DecideForMe/
├── DecideForMe/
│   ├── DecideForMeApp.swift          # App entry point
│   ├── ContentView.swift             # Main navigation hub
│   ├── Features/
│   │   ├── Delivery/
│   │   │   ├── Option.swift          # Data model
│   │   │   ├── OptionViewModel.swift # Business logic
│   │   │   └── DeliveryDecisionView.swift # UI
│   │   ├── Map/
│   │   │   ├── Place.swift           # Place data model
│   │   │   ├── MapDecisionViewModel.swift # Location & API logic
│   │   │   ├── MapDecisionView.swift # Main map UI
│   │   │   ├── PlaceDetailView.swift # Place details
│   │   │   └── NearbyMapView.swift   # Interactive map
│   │   └── Image/
│   │       ├── ImageMark.swift       # Mark data model
│   │       ├── ImageMarkViewModel.swift # Image logic
│   │       └── ImageMarkView.swift   # Image UI
│   ├── Info.plist                    # App configuration
│   └── Assets.xcassets/              # App assets
├── DecideForMeTests/
│   └── DecideForMeTests.swift        # Unit tests
├── DecideForMeUITests/               # UI tests
├── Secrets.xcconfig                  # API keys (gitignored)
└── README.md                         # This file
```

## 🧪 Testing

### Running Tests
```bash
# Run all tests
xcodebuild -project DecideForMe.xcodeproj -scheme DecideForMe -destination 'platform=iOS Simulator,name=iPhone 16' test

# Run specific test
xcodebuild -project DecideForMe.xcodeproj -scheme DecideForMe -destination 'platform=iOS Simulator,name=iPhone 16' test -only-testing:DecideForMeTests/testMapDecisionViewModelLocation
```

### Test Coverage
- **Model Tests:** Data persistence, initialization, validation
- **ViewModel Tests:** Business logic, filtering, decision algorithms
- **Location Tests:** GPS functionality, permission handling, coordinate calculations
- **Utility Tests:** Distance calculations, ID generation

## 🎨 UI/UX Design

### Design Principles
- **Minimalist:** Clean, uncluttered interface
- **Color Scheme:** Black, white, and orange only
- **Accessibility:** High contrast, readable fonts
- **Responsive:** Adapts to different screen sizes

### Navigation
- **NavigationStack:** Modern iOS 16+ navigation
- **Modal Presentations:** Sheets for detailed views
- **Tab-based:** Three main feature areas

## 🔄 Data Flow

### Delivery Feature
1. User adds options with tags
2. Filters applied to narrow choices
3. Weighted random selection based on feedback history
4. User provides like/dislike feedback
5. Weights updated and persisted

### Map Feature
1. User enters search keyword
2. Current location obtained (or default used)
3. Google Places API queried for nearby places
4. Results filtered by distance/rating
5. Weighted selection combines distance and user feedback
6. Place details fetched and displayed

### Image Feature
1. User selects or captures image
2. Taps to add numbered marks
3. Long-press to rename marks
4. Random selection from marked locations
5. Visual feedback for selection

## 🚀 Deployment

### App Store Preparation
1. **Code Signing:** Configure with your Apple Developer account
2. **App Icons:** Ensure all required sizes are present
3. **Screenshots:** Capture for all supported devices
4. **Metadata:** Prepare app description, keywords, etc.
5. **Testing:** Test on physical devices before submission

### Build Configuration
- **Debug:** Development with logging
- **Release:** Production with optimizations
- **TestFlight:** Beta testing distribution

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Google Places API** for location services
- **SwiftUI** for modern iOS development
- **CoreLocation** for GPS functionality
- **PhotosUI** for image handling

## 📞 Support

For support, email support@decideforme.app or create an issue in this repository.

---

**Built with ❤️ using SwiftUI and modern iOS development practices** 