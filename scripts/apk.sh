flutter build apk --split-per-abi
flutter build appbundle

keytool -genkey -v -keystore C:\flutter_apps_vs\architecture\coin_with_architecture\upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload