import SwiftUI
import WebKit

struct NearbyMapView: UIViewRepresentable {
    let lat: Double
    let lng: Double
    let apiKey: String
    var onDismiss: (() -> Void)? = nil
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        
        // Validate API key
        guard !apiKey.isEmpty && apiKey != "NULL" && apiKey != "demo" else {
            let errorHTML = """
            <!DOCTYPE html>
            <html>
            <head>
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <style>
                    body {
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        height: 100vh;
                        margin: 0;
                        font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        color: white;
                    }
                    .container {
                        text-align: center;
                        padding: 40px;
                        background: rgba(255, 255, 255, 0.1);
                        border-radius: 20px;
                        backdrop-filter: blur(10px);
                        max-width: 400px;
                    }
                    h2 {
                        margin: 0 0 20px 0;
                        font-size: 24px;
                    }
                    p {
                        margin: 10px 0;
                        line-height: 1.6;
                        opacity: 0.9;
                    }
                    .icon {
                        font-size: 48px;
                        margin-bottom: 20px;
                    }
                </style>
            </head>
            <body>
                <div class="container">
                    <div class="icon">🔑</div>
                    <h2>API Key Required</h2>
                    <p>Please configure your Google Maps API key in <strong>Secrets.xcconfig</strong></p>
                    <p style="font-size: 14px; opacity: 0.8;">Make sure the key has Maps JavaScript API enabled in Google Cloud Console.</p>
                </div>
            </body>
            </html>
            """
            webView.loadHTMLString(errorHTML, baseURL: nil)
            return webView
        }
        
        let html = """
        <!DOCTYPE html>
        <html>
        <head>
            <meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
            <style>html, body, #map { height: 100%; margin: 0; padding: 0; }</style>
            <script src="https://maps.googleapis.com/maps/api/js?key=\(apiKey)"></script>
            <script>
                function initMap() {
                    var center = {lat: \(lat), lng: \(lng)};
                    var map = new google.maps.Map(document.getElementById('map'), {
                        center: center,
                        zoom: 15
                    });
                    new google.maps.Marker({position: center, map: map});
                }
            </script>
        </head>
        <body onload="initMap()">
            <div id="map" style="width:100vw;height:100vh"></div>
        </body>
        </html>
        """
        webView.loadHTMLString(html, baseURL: nil)
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
}

struct NearbyMapViewContainer: View {
    @Environment(\.presentationMode) var presentationMode
    let lat: Double
    let lng: Double
    let apiKey: String
    var body: some View {
        ZStack(alignment: .topLeading) {
            NearbyMapView(lat: lat, lng: lng, apiKey: apiKey)
            Button(action: { presentationMode.wrappedValue.dismiss() }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.blue)
                    .padding(8)
                    .background(Color(.systemGray5))
                    .clipShape(Circle())
            }
            .padding([.top, .leading], 16)
        }
    }
}

#Preview {
    NearbyMapViewContainer(lat: 43.6532, lng: -79.3832, apiKey: "demo")
}
