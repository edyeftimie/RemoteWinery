# RemoteWinery
A native Android app built with Kotlin, allowing users to manage their wine collection through a user-friendly interface.

## Frontend
- **CRUD Operations**: Create, edit, delete, and view wines in a dynamic list.
- **Input Validation**: Ensures that wine details are accurately entered and displayed.
### Non-Native Language - Flutter
- **Local database** : The app uses SQLite db to enable offline functionality, allowing users to interact with the app even without an internet connection. All changes stored locally can be synced when the app reconnects to the internet or the server.
- **System themes** : Implemented functionality for system-based, light, and dark themes, with English language support.
- **ListView Optimization**: Utilized an efficient approach to prevent unnecessary list rebuilds, ensuring smooth performance.
- **Reusable Widgets**: Developed custom form and confirmation widgets used across add, edit and delete pages to streamline user input handling.
- **UI Components**: Incorporated Material Design elements, such as automaticallyImplyLeading, IconButton, FloatingActionButton, and ElevatedButton to enhance user experience.
- **Architecture**: Implemented Model-Repository-Service architecture to structure and manage the app’s data flow effectively.
- **Stateless and Stateful Widgets**: Designed UI components using both Stateless and Stateful Widgets, optimizing app performance by ensuring that only necessary parts of the UI are updated with state changes.

### Native Language - Kotlin
- **SDK Android 13 Tiramisu**: Built with Android 13 SDK, ensuring support for modern Android features.
- **Activity/Fragment Logic**: Utilizes Activities and Fragments for managing app navigation and displaying wine details.
- **ModelView/Adapter**: Implemented using the MVVM architecture with a WineViewModel, which interacts with the WineAdapter to display data.
- **RecyclerView**: Efficiently displays a list of wines using RecyclerView, allowing smooth scrolling and dynamic data updates.
- **XML layouts**: Views are created using XML layouts for consistent and responsive design. It incorporates modern **Jetpack Compose** elements.
 
## Backend - TODO
## Server - Online Database - TODO
## Features - TODO

### In app photos
|  **Home page - list of wines**  |  **Edit a wine**  |
|---------------------------------|--------------------|
|  ![Home page - list of wines](https://github.com/edyeftimie/RemoteWinery/blob/main/InAppPhotos/List%20view.jpeg)  |  ![Edit a wine](https://github.com/edyeftimie/RemoteWinery/blob/main/InAppPhotos/Edit%20wine.jpeg)  |

|  **Delete a wine**  |  **Wine deleted**  |
|---------------------|--------------------|
|  ![Delete a wine](https://github.com/edyeftimie/RemoteWinery/blob/main/InAppPhotos/Delete%20wine.jpeg)  |  ![Wine deleted](https://github.com/edyeftimie/RemoteWinery/blob/main/InAppPhotos/Delete%20confirmed.jpeg)  |

|  **Add wine form - Data validation example**  |  **Add wine form - Data validation example 2**  |
|-----------------------------------------------|-----------------------------------------------|
|  ![Add wine form - Data validation example](https://github.com/edyeftimie/RemoteWinery/blob/main/InAppPhotos/Add%20data%20validation.jpeg)  |  ![Add wine form - Data validation example 2](https://github.com/edyeftimie/RemoteWinery/blob/main/InAppPhotos/Add%20data%20validation%202.jpeg)  |
