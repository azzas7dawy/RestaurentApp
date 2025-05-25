🍽️ BigTasty Restaurant App

A modern and feature-rich food ordering app built with Flutter, Firebase, and Cubit.

About the App

Restaurant App allows users to explore food menus, reserve tables, place and track orders, interact with an AI-powered chatbot, and complete payments. It’s crafted with beautiful animations and clean UI for an enhanced user experience.

Features

- User Authentication  
  - Email & Password  
  - Google Sign-In via Firebase

- Food Categories & Menus  
  - Dynamic menu fetched from Firebase  
  - Images and descriptions for each dish

- Order Management 
  - Add/remove items  
  - Persistent using SharedPreferences

- Table Reservation 
  - Reserve a table directly through the app  
  - Reservation info stored in Firebase

- AI Chatbot Assistant
  - Responds to user queries using stored data from Firebase  
  - Personalized recommendations  
  - Useful for support and navigation  
  - 🐳 **Dockerized Chatbot** for easy deployment

- Secure Payment Integration
  - Powered by Paymob  
  - Pay for meals with integrated payment gateway

- Ratings & Reviews 
  - Leave feedback on dishes and overall experience  
  - Uses `flutter_rating_bar`

- Profile Image Upload
  - Pick images using `image_picker`  
  - Stored in Firebase Storage

- Localization Support 
  - App supports multiple languages via `flutter_localizations`

- Smooth & Interactive UI
  - `salomon_bottom_bar` for beautiful navigation  
  - `animated_text_kit` for text animations  
  - `carousel_slider` for featured meals  
  - `shimmer` loading placeholders  
  - `cached_network_image` for optimized image loading

- Secure API Key Management
  - Using `flutter_dotenv`

Built With

- **Flutter** – Frontend framework  
- **Firebase** – Auth, Firestore, Storage  
- **Cubit** – State management  
- **Docker** – AI Bot containerization  
- **SharedPreferences** – Persistent local storage  
- **Paymob** – Payment gateway  
- **Google Sign-In**  
- **Multiple Flutter packages** – UI & functional enhancements

Demo
You can find the app demos at this Google Drive link
https://drive.google.com/drive/folders/1NVv_f_tVks0VIIlbte-UgA28W9KRVSCL
