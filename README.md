# Alumni Directory (Flutter)

This mobile application serves as an alumni directory, designed and developed as a submission for the **Alumni Relations Cell (ARC) Tech Team 2025 recruitment process**. 


### Core Functionality:

*   **Alumni List Display:** Displays a list of alumni with essential details.
*   **Search and Filter:** Implements a fuzzy search bar to filter alumni by name, role, company, batch, and branch. Filter chips are provided for specific field searches.
*   **Profile Page:** Tapping on an alumni entry navigates to a detailed profile page.

### Implemented Enhancements:

*   **Clean and Polished UI:** The application features a contemporary design with proper spacing, typography, and a cohesive visual language.
*   **Reusable Components:** Key UI elements, such as `AlumniCard` widgets, are designed for reusability, promoting maintainability.
*   **Backend Integration:** Data fetched from a Firestore backend.
*   **Dynamic Theme Integration:** Incorporates Material 3 dynamic theming for Android 12+ devices, offering seamless integration with user-selected wallpapers.
*   **Bottom-Up UX Design:** Implements an unconventional bottom-up design for primary interactions, enhancing one-handed usability.
*   **Advanced Profile Management:** Optimizes profile data loading with separate detail fetching and client-side caching.

## Features Implemented

### 1. Dynamic Material 3 Theming with Nord Fallback

The application prioritizes a modern and adaptive user experience through its theming strategy:
*   **Material You (Dynamic Color):** On Android devices running Android 12 (API 31) and higher, the application dynamically generates its color scheme based on the user's wallpaper, providing a deeply personalized and integrated system experience.
*   themed monochrome icons are also provided to consistent ui across apps.
*   edge-to-edge design is enforced to give a better ux.
*   **System Light/Dark Mode:** The UI automatically adapts to the device's light or dark mode preferences.
*   **Nord Theme Fallback:** For devices that do not support Material You (older Android versions, iOS), the application gracefully falls back to **An arctic, north-bluish color palette.** [Nord color palette](https://www.nordtheme.com/).

### 2. Unconventional Bottom-Up User Experience Design

An intentional design choice (slight departure from the material 3 guidelines) was made to adopt a bottom-up interaction model for **True One Handed Use**.
*   **Main List Controls:** Filter chips and the search bar are strategically positioned at the bottom of the `AlumniListScreen`, making them easily accessible.
*   **Bottom-Anchored Lists:** Both the main alumni list and the search results list are anchored to the bottom of the screen. Items appear from the bottom and scroll upwards, aligning with the natural movement of one-handed interaction.
*   **Intuitive Search Dismissal:** The search screen can be dismissed by a natural swipe-down gesture, allowing for quick return to the main list without reaching for a top-mounted back button.

### 3. Firebase Firestore as Backend

The application integrates with Firebase Firestore for data management and retrieval:
*   **Centralized Data:** Alumni profiles are stored and managed in Firestore, allowing for dynamic updates without requiring app redeployments.
*   **Separate Profile Details:** Basic alumni information (name, batch, company, role) is stored in an `alumni` collection for efficient list loading. Comprehensive details (description, social links) are stored in a separate `alumni_details` collection, linked by a common ID.
*   **Client-Side Caching:** Alumni detail pages implement a basic client-side caching mechanism to reduce redundant network requests and improve load times for frequently accessed profiles.

### 4. Polished UI/UX

*   **Blended Profile Header:** The alumni profile page features a seamlessly blended hero image header. The profile picture is integrated directly into the background, with a subtle blur and gradient overlay, creating a modern and immersive visual effect.
*   **Consistent Card Design:** Both the list items and the profile page header maintain a consistent visual style.
*   **Animated List Entry:** Alumni cards animate gracefully into view as the user scrolls, adding a dynamic and engaging feel to the lists.
*   **Prominent LinkedIn Integration:** LinkedIn URLs are given dedicated, prominent buttons on the profile page, reflecting their importance in professional networking. Other social links are clearly presented and left-aligned.

## Images

### Light Mode & App Features
<div align="center">
  
| Home Screen | Profile Page | Search Page | App Icon |
|-------------|--------------|-------------|----------|
| <img src="https://github.com/user-attachments/assets/e584c09e-9e90-4f80-934f-08bfdf0bea66" width="180" alt="Light Mode Home Screen"> | <img src="https://github.com/user-attachments/assets/5f0413e9-85da-4e48-8902-254f29a5eeac" width="180" alt="Light Mode Profile Page"> | <img src="https://github.com/user-attachments/assets/0be78dde-43b5-4a4b-91ad-2968fc5dd8ce" width="180" alt="Light Mode Search Page"> | <img src="https://github.com/user-attachments/assets/34c0358d-2a25-4a37-89bf-246463d5cd30" width="180" alt="App Icon"> |
| alumni page with lightmode | Detailed alumni profiles with company information and graduation details | Advanced filtering and search capabilities for finding specific alumni | Modern Material 3 adaptive icon with dynamic theming support |

</div>

### Dark Mode & Activity Features
<div align="center">

| Home Screen | Profile Page | Recent Activity | Search Page |
|-------------|--------------|-----------------|-------------|
| <img src="https://github.com/user-attachments/assets/542f75dd-a392-45f1-b49f-510873aa5331" width="180" alt="Dark Mode Home Screen"> | <img src="https://github.com/user-attachments/assets/ca992b74-a0f1-4606-996a-521ade55ea42" width="180" alt="Dark Mode Profile Page"> | <img src="https://github.com/user-attachments/assets/ede57ab5-d211-4e70-bd2a-47ee334e512c" width="180" alt="Recent Activity"> | <img src="https://github.com/user-attachments/assets/d907fdca-4d49-409a-8637-decf2f4d25df" width="180" alt="Dark Mode Search Page"> |
| Elegant dark theme with improved readability and battery efficiency | Consistent dark theme styling across all profile elements and sections | Stay updated with latest alumni activities, networking events, and announcements | Enhanced search experience with dark mode optimization and intuitive filters |

</div>



## Code Structure and Organization

The project adheres to Flutter best practices for code organization:
*   **Modular Architecture:** Features are separated into distinct directories (e.g., `models`, `pages`, `services`, `widgets`, `theme`).
*   **Reusable Widgets:** Custom widgets like `AlumniCard` and `HighlightedText` promote code reuse and maintain a consistent UI across the application.
  
## Submission Details

This project is submitted as part of the recruitment process for the ARC Tech Team 2025.

**Deadline:** 7th September, 11:59 PM

---

## Technical Information

*   **Framework:** Flutter
*   **Backend:** Google Firebase Firestore
*   **Platforms:** Android (Primary Focus)
*   **Dependencies:** `cloud_firestore`, `url_launcher`, `fuzzy`, `dynamic_color`

## Setup and Run

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/dijith-481/arc-task-flutter-alumni.git
    cd arc-task-flutter-alumni
    ```
2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```
3.  **Firebase Setup (if not already done):**
    *   Create a Firebase project.
    *   Set up Firestore.
    *   install `firebase-cli` and `flutterfire`
    *   run `flutterfire cofigure`
    *   (Optional but Recommended for Admin script) Generate a service account key (`serviceAccountKey.json`) from Firebase Project Settings -> Service Accounts.
    *   **Firestore Rules:** Ensure your Firestore rules allow read access for public data (e.g., `allow read: if true;`) for `alumni` and `alumni_details` collections.
4.  **Upload Initial Data (using Node.js script):**
    *   even though it is possible to upload data from firebase console directly it is recomended to do this via a script.
    *   Navigate to the directory containing your `upload_data.js`, `alumni_data.json`, `alumni_details_data.json`, and `serviceAccountKey.json`.
    *   Run `npm install firebase-admin`.
    *   Execute `node upload_data.js` to populate your Firestore.
7.  **Run the app:**
    ```bash
    flutter run
    ```

## Direct APK Access (Android)

A release APK for direct installation can be found after running:
```bash
flutter build apk --release
```
The APK will be located at `build/app/outputs/flutter-apk/app-release.apk`.


> [!NOTE]
> All data, including alumni names, batch years, branches, companies, roles, descriptions, and social media links, are **fictional and generated for demonstration purposes only**. They do not represent real individuals or entities.
>
> Profile pictures used throughout the application are fetched from [Pravatar](https://pravatar.cc/).

## Credit

*   **Google Gemini:** Contributed approximately 60% of the codebase, created appicon via nanobanana.
*   **Nord Theme:** Aesthetic inspiration and color palette provided by [Nord (Arctic Ice Studio)](https://www.nordtheme.com/).

## License

This project is licensed under the [MIT License](LICENSE). You are free to use, modify, and distribute this software, provided the original copyright and license notice are included.

Made with Flutter and ❤️ by [dijith-481](https://github.com/dijith-481).
