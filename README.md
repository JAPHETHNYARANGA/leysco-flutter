# leysco

This Flutter application allows users to manage tasks with different statuses (pending, in-progress, completed) using a backend Laravel API. Users can log in, view tasks, add new tasks, update task statuses, and log out.

## Getting Started
To run the project locally, follow these steps:

## Prerequisites
* Flutter SDK installed (version used: 2.x)
* Android/iOS emulator or device connected

## Backend Setup
### Clone Laravel Backend:
* Clone the Laravel backend repository from GitHub.`https://github.com/JAPHETHNYARANGA/leysco-todo-api.git`
* Follow the README instructions to set up and run the Laravel backend.
* Ensure the backend is running locally and accessible via its local URL (e.g., http://localhost:8000).

### Expose Backend with ngrok:
* Install ngrok and run it to expose your local server to a public URL.
* Replace the baseUrl in lib/services/ApiService.dart with your ngrok URL. Example:`static const String baseUrl = 'https://your-ngrok-url.ngrok.io/api'`;

## Flutter Project Setup
* Clone this Flutter project from GitHub. `https://github.com/JAPHETHNYARANGA/leysco-flutter.git`
* Run flutter pub get to install dependencies.
* Run flutter run in the project directory to build and launch the app.

