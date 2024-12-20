# Bitcoin Exchange

MedalBox is a simple app that showcases the Bitcoin price for the past 14 days, along with the current price, which updates in real time every 60 seconds.

## Key Features & Design Considerations

Please note that this project is still a work in progress, and much of the functionality is incomplete due to time constraints. Below is a breakdown of what's done and what's still pending:

### ✅ **What is already done**:  

- The app includes a **networking layer** that fetches Bitcoin price data for the past 14 days (in EUR, GBP, and USD) and stores it in the model.  
- It displays the **current price** of Bitcoin and updates every 60 seconds.

### ❌ **What is still not done**:  

- The **detail view** is not yet implemented.  
- The **Coordinator** pattern for navigation, which helps isolate navigation logic and modularize the app's flow, has not been integrated yet.  
- **Unit testing** has not been added.

### Architecture  
The app follows a simplified version of the **MVVM** (Model-View-ViewModel) pattern, helping to separate concerns between the UI and data layers for cleaner and more maintainable code.

### Future Considerations  
Given the lightweight nature of this app and the absence of a live API, caching and data persistence were not implemented. However, as the app grows, it would benefit from:
- Integrating native persistence solutions like **UserDefaults** or **CoreData** to store data locally.
- Using third-party libraries like **Kingfisher** for image caching to improve performance and user experience.

### UI Implementation  
I used **storyboards** for the UI design, which provides a clear, visual structure for the app. While programmatic UI might be more suitable for collaborative environments, storyboards were a better fit for this project’s scope.

---

Feel free to reach out if you have any questions or encounter any issues!
