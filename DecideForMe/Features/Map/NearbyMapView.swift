import SwiftUI
import WebKit

struct NearbyMapView: UIViewRepresentable {
    let lat: Double
    let lng: Double
    let apiKey: String
    var onDismiss: (() -> Void)? = nil
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        let html = """
        <!DOCTYPE html>
        <html>
        <head>
            <meta name=\"viewport\" content=\"initial-scale=1.0, user-scalable=no\" />
            <style>html, body, #map { height: 100%; margin: 0; padding: 0; }</style>
            <script src=\"https://maps.googleapis.com/maps/api/js?key=\(apiKey)\"></script>
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
        <body onload=\"initMap()\">
            <div id=\"map\" style=\"width:100vw;height:100vh\"></div>
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
