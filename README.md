Neeva 2023 Mobile Project: Mobile Browser


This app is web browser for ios. The app uses the WKWebView component for basis of the browser and SwiftUI.  



Installing and Running:
  
  Simply copy the repository to XCode or download the zip file from Github and open the MobileBrowser-Neeva.xcodeproj file in XCode.
  Next, run the app using one of the selected simulator or your own device.
  
  
  
 Added Features:
 
  The primary extra feature that I chose to implement was the thumbnail picture for tabs feature. My secondary concern for this project was usability
  _I will discuss my approach to each of these features/focuses in the next section_
  
  
 
 Approaches & Design Decisions:
 
 - Tabs & WKWebView to SwiftUI -
 
  The main design scheme for this app is oriented around the tab system which is actualized by the web browser state class. The web browser state class acomplishes this by keeping track of each webpage (WKWebView) or tab in a published array for the TabList View to display. The web browser state object is also responsible for tracking the active webpage or active tab which it can easily switch between by selecting a value from its previously mentioned webpages array. Furthermore, the web browser state (WebBrowserState) class adheres to the WKNavigationDelegate Protocol to manage the active webpage/tab. The active webpage/tab/WKWebView is presented to the user via a UIViewRepresentable structure called WebBrowser. This structure does NOT return a WKWebView, but a generic UIView(). The active webpage (WKWebView) is simply presented as a framed subview through/via the WebBrowser structure. This is done to prevent the active WKWebView from reloading when being displayed so that switching between tabs is more fluid.
  
  The WebBrowserStates lifecycle is as follows: it is created/initialized upon launching of the app as a StateObject of the manager view so that it can be passed as an ObservedObject to any views that utilize it. Then, the active_webpage value is presented in the ActiveWebBrowser View via the WebBrowser structure.
  


- Tab Thumbnail Pictures -

  The Tab thumbnails are captured via a screencapture (provided by the WKNavigationDelegate protocol) right before the Tab View List is presented. The screencaptures are stored in a dictionary in the WebBrowserState class which is passed as an ovserved object to the TabList View. I decided to present the tab thumbnails as pictures/Images rather than actual live websites because rendering multiple live websites in the TabList view prooved to utilize a lot of processing power. The structure of my app could support presenting multiple live WKWebviews since the WebBrowserState class is designed such that it could manage multiple active browsers at once. This is because each WKWebView in the WebBrowserState class is stored in an array of value type structs such that each posses the necessary information to accuralty call WKNavigationDelegate methods.
  
  
  
- UI & Usability - 

  I dedicated a lot of time to improve the usability my mobile browser. The most notable usability feature, I think, is the versatility of the search bar. The search bar is designed so any .com search is garunteed to have https://www. at the beginning of it, and any search that does not appear to be a valid url is sent as a google search request with the url: https://www.google.com/search?q=%s. One shortcoming here is that I did not have the time correct google searches with special characters such as ^ & * $ to name a few. Entering any of these characters in the search bar while also not in url form will result in an error page being presented to the user. To fix this I would need to read through google's search documentation in order to correclty format searches with special characters.
  
  I also took particular care to ensure that value presented to the user in the search bar always reflects the url or search string (%s in the search url) that would take them to the webpage they are currenly one. This way reloading and pressing the submit search button essential function the same if the search value is not modified. 
  
  
  Notable Bugs & Shortcomings:
  
  1)  Searching with special characters results in an error page being presented to the user
  2)  The app does not reasonably support horizontal mode on mobile devices
  3)  After selecting a tab from the TabList View the loading icon will persist until a navigating action is made (this might be a bug with WKWebView)
  
