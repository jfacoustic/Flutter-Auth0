package com.jfacoustic.flutter_auth0_client

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.os.Parcel
import android.os.Parcelable
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

import com.auth0.android.Auth0
import com.auth0.android.authentication.AuthenticationException
import com.auth0.android.provider.WebAuthProvider
import com.auth0.android.result.Credentials
import com.auth0.android.callback.Callback
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.PluginRegistry
import java.lang.Exception
import kotlin.math.log
import com.google.gson.Gson;
/** FlutterAuth0ClientPlugin */
class FlutterAuth0ClientPlugin() : FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var context: Context;
  private var activity: Activity? = null;

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_auth0_client")
    channel.setMethodCallHandler(this)
    this.context = flutterPluginBinding.applicationContext
  }
  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else if(call.method == "login") {
      login(AuthParams(
        clientId = call.argument<String>("clientId")!!,
        domain = call.argument<String>("domain")!!,
        scheme = call.argument<String>("scheme")!!,
        scope = call.argument<String>("scope"),
        audience = call.argument<String>("audience"),
      ), result)
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  fun login(params: AuthParams, @NonNull result: Result) {
    val auth0 = Auth0(params.clientId, params.domain);
    var loginMethod = WebAuthProvider.login(account = auth0).withScheme(params.scheme)
    if(params.scope != null) {
      loginMethod = loginMethod.withScope(params.scope);
    }
    if(params.audience != null) {
      loginMethod = loginMethod.withAudience(params.audience);
    }
    print("About to log in")
    try {
      loginMethod.start(this.activity!!, object : Callback<Credentials, AuthenticationException> {
        // Called when there is an authentication failure
        override fun onFailure(exception: AuthenticationException) {
          result.error("AuthenticationException", exception.message, activity)
        }

        // Called when authentication completed successfully
        override fun onSuccess(credentials: Credentials) {
          val gson = Gson()
          val data = gson.toJson(credentials)
          result.success(data)
//          result.success(
////            mapOf(
////              "accessToken" to credentials.accessToken,
////              "idToken" to credentials.idToken,
////              "scope" to credentials.scope,
////              "recoveryCode" to credentials.recoveryCode,
////              "refreshToken" to credentials.refreshToken,
////              "tokenType" to credentials.type
////            )
//          )
        }
      })
    } catch (e: Exception) {
      result.error("AuthenticationException", e.message, activity)
    }
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
      this.activity = binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {
    this.activity = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    this.activity = binding.activity
  }

  override fun onDetachedFromActivity() {
    this.activity = null
  }
}
