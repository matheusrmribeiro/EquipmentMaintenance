# EquipmentMaintenance
 Maintenance controller
 
**What I learned?**
* BLoC pattern
* Basic Firebase authentication
* Share images

[This project still alive, soon new improvements will be made]

**Tested on**
- [X] Android
- [ ] iOS

## How to begin (User register it's not available yet on the application)
1. Create a new Firebase project.
1. Create a cloud firestore database.
    1. Create a collection "users"
    1. Insert a new document with the same fields like the class Users ([lib\classes\users.dart](https://github.com/matheusrmribeiro/EquipmentMaintenance/blob/master/lib/classes/user.dart))
    1. Fill the new document with your default user data.
1. Go to Authentication section (Left menu)
1. Go to Login Method tab.
1. Active the E-mail/password method.
1. Go to User tab.
1. Create a new User with the same Email that you used in the step 2.3
1. Go to Project Overview section (Left menu)
1. Click to add an android app.
    1. Company name: com.rema.qrcode
    1. Choose a nickname to your project.
1. Download the .JSON file that firebase provided.
1. Put the .JSON file inside the folder ([android\app](https://github.com/matheusrmribeiro/EquipmentMaintenance/tree/master/android/app))
