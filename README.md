Neeva 2023 Mobile Project: Mobile Browser


This app is web browser for ios. The app uses the WKWebView component for basis of the browser and SwiftUI.  


Installing and Running:
  
  Simply copy the repository to XCode or download the zip file from Github and open the MobileBrowser-Neeva.xcodeproj file in XCode.
  Next, run the app using one of the selected simulator or your own device.
  
  
  
 Added Features:
 
  The primary extra feature that I chose to implement was the thumbnail picture for tabs feature
  My secondary concern for this project was usability
  _I will discuss my approach to each of these features/focuses in the next section_
  
  
 
 Approaches & Design Decisions:
 
 - Tabs & WKWebView to SwiftUI -
 
  The main design scheme for this app is oriented around the tab system which is actualized by the web browser state class. The web browser state class acomplishes this by keeping track of each webpage (WKWebView) or tab in a published array for the TabList View to display. The web browser state object is also responsible for tracking the active webpage or active tab which it can easily switch between by selecting a value from its previously mentioned webpages array. Furthermore, the web browser state (WebBrowserState) class adheres to the WKNavigationDelegate Protocol to manage the active webpage/tab. The active webpage/tab/WKWebView is presented to the user via a UIViewRepresentable structure called WebBrowser. This structure does NOT return a WKWebView, but a generic UIView(). The active webpage (WKWebView) is simply presented as a framed subview through/via the WebBrowser structure. 
  
  The WebBrowserStates lifecycle is as follows: it is created/initialized upon launching of the app as a StateObject of the manager view so that it can be passed as an ObservedObject to any views that utilize it. Then, the active_webpage value is presented in the ActiveWebBrowser View via the WebBrowser structure.
  


- Tab Thumbnail Pictures -

  The Tab thumbnails are captured via a screencapture (provided by the WKNavigationDelegate protocol) right before the Tab View List is presented. The screencaptures are stored in a dictionary in the WebBrowserState class which is passed as an ovserved object to the TabList View. I decided to present the tab thumbnails as pictures/Images rather than actual live websites because rendering multiple live websites in the TabList view prooved to utilize a lot of processing power. The structure of my app however would not need very much since the WebBrowserState class is designed such that it could manage multiple active browsers at once. This is because each WKWebView in the WebBrowserState class 
