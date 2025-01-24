# RemoteWinery
A native Android app built with Kotlin, allowing users to manage their wine collection through a user-friendly interface.

## Frontend
- **CRUD Operations**: Create, edit, delete, and view wines in a dynamic list.
- **Input Validation**: Ensures that wine details are accurately entered and displayed.
- 
### Non-Native Language - Flutter
- **System themes** : Implemented functionality for system-based, light, and dark themes, with English language support.
- **ListView Optimization**: Utilized an efficient approach to prevent unnecessary list rebuilds, ensuring smooth performance.
- **Reusable Widgets**: Developed custom form and confirmation widgets used across add, edit and delete pages to streamline user input handling.
- **UI Components**: Incorporated Material Design elements to enhance user experience.
- **Architecture**: Implemented Model-Repository-Service architecture to structure and manage the app’s data flow effectively.
- **Stateless and Stateful Widgets**: Designed UI components using both Stateless and Stateful Widgets, optimizing app performance by ensuring that only necessary parts of the UI are updated with state changes.

## Backend - Flutter
- **Local database** : The app uses SQLite db to enable offline functionality, allowing users to interact with the app even without an internet connection. All changes stored locally can be synced when the app reconnects to the internet or the server.
- **Server** : A central data store that ensures consistency and persistence of all application data.
- **WebSocket** : Implements real-time monitoring of the server connection to manage online and offline states efficiently.
- **Log queue** : Captures and stores every action performed while the app is offline. This ensures that all offline operations are accounted for and synchronized with the server upon reconnection.
- **Synchronization** : On reestablishing a connection to the server:
-- Updates are fetched to ensure the local database reflects the latest server-side data.
-- Offline actions from the log queue are executed on the server to maintain consistency.
- **Dynamic ID's** : Temporarily generates local IDs for entities created offline. When reconnected, the local database replaces these with server-generated IDs, ensuring there are no conflicts or data overwrites.

## Server - Node.js
- **WebSocket Integration**: Implements WebSocket for real-time communication, enabling efficient monitoring of client-server connectivity and seamless data synchronization.
- **PostgreSQL DB**: Utilizes PostgreSQL as the primary database, ensuring reliable and consistent data storage. The pg and pg-format libraries are used for database queries and dynamic SQL formatting to prevent SQL injection vulnerabilities.
- **Database Helper Module**: Includes a custom DatabaseHelper module to abstract database operations, providing an organized and reusable interface for managing queries and connections.
- **Data Consistency**: Ensures all data changes made during offline operations are processed and synchronized with the PostgreSQL database when reconnected.
- **Secure Data Handling**: The server retrieves entities and executes queries without using raw SQL strings, relying on parameterized queries to prevent SQL injection vulnerabilities.
- **Environment Variables**: Sensitive server data, such as database credentials and configuration, is securely stored in a .env file, ensuring privacy and security.

### Native Language - Kotlin
#### I developed a Kotlin prototype of the Flutter app as a learning project to explore and understand this new language.
- **SDK Android 13 Tiramisu**: Built with Android 13 SDK, ensuring support for modern Android features.
- **Activity/Fragment Logic**: Utilizes Activities and Fragments for managing app navigation and displaying wine details.
- **ModelView/Adapter**: Implemented using the MVVM architecture with a WineViewModel, which interacts with the WineAdapter to display data.
- **RecyclerView**: Efficiently displays a list of wines using RecyclerView, allowing smooth scrolling and dynamic data updates.
- **XML layouts**: Views are created using XML layouts for consistent and responsive design. It incorporates modern **Jetpack Compose** elements.
 
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
