# Safe keep rules for flutter_local_notifications scheduled notifications & Gson serialization
-keep class com.dexterous.flutterlocalnotifications.models.** { *; }
-keep class com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver { *; }
-keep class com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver { *; }
-keep class com.dexterous.flutterlocalnotifications.ActionBroadcastReceiver { *; }
-keepattributes Signature, InnerClasses, EnclosingMethod
-keep,allowshrinking class com.google.gson.reflect.TypeToken
-keep,allowshrinking class * extends com.google.gson.reflect.TypeToken
