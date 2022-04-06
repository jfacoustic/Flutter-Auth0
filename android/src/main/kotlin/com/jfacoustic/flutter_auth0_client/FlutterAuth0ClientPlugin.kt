package com.jfacoustic.flutter_auth0_client

import android.app.Activity
import android.content.Context
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
import kotlin.math.log

/** FlutterAuth0ClientPlugin */
class FlutterAuth0ClientPlugin() : FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var context: Context;
  private lateinit var activity: Activity;

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_auth0_client")
    channel.setMethodCallHandler(this)
    this.context = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  fun login(params: AuthParams, @NonNull result: Result) {
    val auth0 = Auth0(params.clientId, params.domain);
    var loginMethod = WebAuthProvider.login(account = auth0)
    if(params.scope != null) {
      loginMethod = loginMethod.withScope(params.scope);
    }
    if(params.audience != null) {
      loginMethod = loginMethod.withAudience(params.audience);
    }
    loginMethod.start(context, object : Callback<Credentials, AuthenticationException> {
      // Called when there is an authentication failure
      override fun onFailure(exception: AuthenticationException) {
        // Something went wrong!
          result.error("AuthenticationException", exception.message, null)
      }

      // Called when authentication completed successfully
      override fun onSuccess(credentials: Credentials) {
        // Get the access token from the credentials object.
        // This can be used to call APIs
        result.success(mapOf(
          "accessToken" to credentials.accessToken,
          "idToken" to credentials.idToken,
          "scope" to credentials.scope,
          "recoveryCode" to credentials.recoveryCode,
          "refreshToken" to credentials.refreshToken,
          "tokenType" to credentials.type
        ))
      }
    })
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
  }

  override fun onDetachedFromActivityForConfigChanges() {
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
  }

  override fun onDetachedFromActivity() {
  }
}
