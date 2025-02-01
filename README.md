## For English scroll down

# 🏕️ Campside - ლაშქრობებისა და ბანაკების პლატფორმა

**Campside** არის iOS აპლიკაცია, რომელიც აერთიანებს სხვადასხვა ლაშქრობებს, ბანაკებსა და ტურისტულ ივენთებს.  
აპლიკაცია მომხმარებლებს სთავაზობს ივენთების ძიებას, ფილტრაციას, ფავორიტების მართვას და ბილეთების დაჯავშნას.  
პროექტი შეიქმნა **MVVM** არქიტექტურის დაცვით და იყენებს **Firebase Realtime Database**-ს მონაცემთა მართვისთვის.

---

## 📌 **ძირითადი ფუნქციონალები**  

### ✅ **ავტორიზაცია და რეგისტრაცია**
- მომხმარებლის რეგისტრაცია **ელ-ფოსტითა და პაროლით**
- **Google ავტორიზაცია** Firebase Authentication-ის გამოყენებით
- პროფილიდან გასვლა

### ✅ **პროფილის მართვა**
- **პირადი ინფორმაციის რედაქტირება** (სახელი, ელ. ფოსტა)
- **პროფილის სურათის ატვირთვა და განახლება**
- **პაროლის შეცვლა**
- **ანგარიშის წაშლა**

### ✅ **ძიება და ფილტრაცია**
- **ღონისძიებების ძიება ტექსტის ჩაწერით**
- **ფილტრაცია კატეგორიის, ფასისა და თარიღის მიხედვით**
- **ფასის ზრდადობა/კლებადობა სორტირება**
- **ფილტრაციის ფანჯარა (ფრეზენთი UI)**, რომელიც მოიცავს:
  - "გასუფთავება" ღილაკს, ყველა ფილტრის განულებისთვის
  - **ძიების ღილაკს** (მაჩვენებს ამჟამინდელ ივენთების რაოდენობას)

### ✅ **ბილეთების მართვა**
- **ღონისძიებების დათვალიერება**
- **ბილეთების დაჯავშნა**
- **დაჯავშნილი ბილეთების ნახვა**
- **ღონისძიებების მოწონება/ფავორიტებში დამატება**

### ✅ **თემები და ენები**
- **Dark Mode და Light Mode მხარდაჭერა**
- **მრავალენოვანი ინტერფეისი**
  - ქართული 🇬🇪
  - ინგლისური 🇬🇧
  - უკრაინული 🇺🇦
  - გერმანული 🇩🇪
  - ჩინური 🇨🇳

---

## 🛠 **ტექნოლოგიები და ბიბლიოთეკები**  
✅ **Swift & SwiftUI + UIKit**  
✅ **Firebase Realtime Database** - მონაცემთა მართვისთვის  
✅ **Firebase Authentication** - ავტორიზაციისთვის  
✅ **MVVM არქიტექტურა**  
✅ **UserDefaults** - ენის და თემის შესანახად  
✅ **Combine & Publishers** - რეაქტიული პროგრამირება  
✅ **Apple Maps SDK** - რუკაზე ივენთების ჩვენებისთვის  

---

## 🚀 **დამონტაჟება და გაშვება**  

1️⃣ **პროექტის კლონირება:**  
```bash
git clone https://github.com/andriagv/TbcIosFinalProject.git
```

2️⃣ **Firebase კონფიგურაცია:**  
- გახსენით **Firebase Console**, შექმენით iOS პროექტი  
- გადმოწერეთ `GoogleService-Info.plist` და ჩააგდეთ `Resources/` დირექტორიაში  
- დარწმუნდით, რომ Firebase კონფიგურაცია სწორად არის გაწერილი **AppDelegate.swift**-ში  

---

## 🔥 **მომავალში გასაკეთებელი ფუნქციონალი**  
🔜 **რევიუს სისტემა (შეფასება, კომენტარები)**  
🔜 **Live Chat ორგანიზატორებთან**  
🔜 **მომხმარებლის როლების შექმნა (მომხმარებელი/ორგანიზატორი)**  
🔜 **ონლაინ გადახდის სისტემის დამატება**  

---

## 👨‍💻 **ავტორი**  
👤 **ანდრია გვარამია**  
📧 **gvaramiaandria1@gmail.com**  
🚀 [GitHub პროფილი](https://github.com/andriagv)

---

# 🏕️ Campside - Hiking and Camping Platform

**Campside** is an iOS application that brings together various hiking trips, camps, and tourist events.  
The app offers users event search, filtering, favorites management, and ticket booking capabilities.  
The project was built following the **MVVM** architecture and uses **Firebase Realtime Database** for data management.

---

## 📌 **Key Features**  

### ✅ **Authentication & Registration**
- User registration with **email and password**
- **Google Sign-in** using Firebase Authentication
- Profile logout

### ✅ **Profile Management**
- **Personal information editing** (name, email)
- **Profile picture upload and update**
- **Password change**
- **Account deletion**

### ✅ **Search & Filtering**
- **Event search by text input**
- **Filtering by category, price, and date**
- **Price ascending/descending sorting**
- **Filter sheet (Present UI)** including:
  - "Clear" button to reset all filters
  - **Search button** (shows current event count)

### ✅ **Ticket Management**
- **Event browsing**
- **Ticket booking**
- **Booked tickets viewing**
- **Event liking/adding to favorites**

### ✅ **Themes & Languages**
- **Dark Mode and Light Mode support**
- **Multi-language interface**
  - Georgian 🇬🇪
  - English 🇬🇧
  - Ukrainian 🇺🇦
  - German 🇩🇪
  - Chinese 🇨🇳

---

## 🛠 **Technologies & Libraries**  
✅ **Swift & SwiftUI + UIKit**  
✅ **Firebase Realtime Database** - for data management  
✅ **Firebase Authentication** - for authorization  
✅ **MVVM Architecture**  
✅ **UserDefaults** - for storing language and theme  
✅ **Combine & Publishers** - reactive programming  
✅ **Apple Maps SDK** - for showing events on map  

---

## 🚀 **Installation & Setup**  

1️⃣ **Clone the project:**  
```bash
git clone https://github.com/andriagv/TbcIosFinalProject.git
```

2️⃣ **Firebase Configuration:**  
- Open **Firebase Console**, create an iOS project  
- Download `GoogleService-Info.plist` and place it in the `Resources/` directory  
- Ensure Firebase configuration is properly set up in **AppDelegate.swift**  

---

## 🔥 **Future Features**  
🔜 **Review system (ratings, comments)**  
🔜 **Live Chat with organizers**  
🔜 **User roles creation (user/organizer)**  
🔜 **Online payment system integration**  

---

## Photos:

![cvsd](https://github.com/user-attachments/assets/f281e523-ea4a-44e6-8750-3f7169912803)
![ppp](https://github.com/user-attachments/assets/b739a54c-f9e4-446e-82a9-7904568ac468)

![wda](https://github.com/user-attachments/assets/bacf50b1-1532-4c6c-9537-a490c9b3c8ad)

![123453](https://github.com/user-attachments/assets/91281051-a5db-4c46-a6fd-fb4f208696df)

![3](https://github.com/user-attachments/assets/4332c98a-770a-42a0-9e1a-f7e82eb7624e)

https://github.com/user-attachments/assets/2ea40949-37fb-40c6-9f9f-fed16786100d








## 👨‍💻 **Author**  
👤 **Andria Gvaramia**  
📧 **gvaramiaandria1@gmail.com**  
🚀 [GitHub Profile](https://github.com/andriagv)
