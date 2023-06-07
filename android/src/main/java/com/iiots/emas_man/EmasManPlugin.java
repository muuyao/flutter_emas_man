package com.iiots.emas_man;

import androidx.annotation.NonNull;
import android.app.Application;
import android.content.Context;

import com.alibaba.sdk.android.man.MANHitBuilders;
import com.alibaba.sdk.android.man.MANPageHitBuilder;
import com.alibaba.sdk.android.man.MANService;
import com.alibaba.sdk.android.man.MANServiceProvider;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** EmasManPlugin */
public class EmasManPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native
  /// Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine
  /// and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;

  private MANService manService;

  private Context context;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "emas_man");
    channel.setMethodCallHandler(this);
    context = flutterPluginBinding.getApplicationContext();

    MANService manService = MANServiceProvider.getService();
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {

    switch (call.method) {
      case "init":
        init(call, result);
        break;
      case "getPlatformVersion":
        result.success("Android " + android.os.Build.VERSION.RELEASE);
        break;
      case "turnOffAutoPageTrack":
        turnOffAutoPageTrack(call, result);
        break;

      case "userRegister":
        userRegister(call, result);
        break;

      case "updateUserAccount":
        updateUserAccount(call, result);
        break;

      case "trackPage":
        trackPage(call, result);
        break;

      case "trackEvent":
        trackEvent(call, result);
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  private void init(MethodCall call, Result result) {

    if (context instanceof Application) {
      Application application = (Application) context;
      manService.getMANAnalytics().init(application, application.getApplicationContext());
      // 打开调试日志，线上版本建议关闭
      manService.getMANAnalytics().turnOnDebug();
      result.success(true);
    } else {
      result.error("EMAS_MAN", "Invalid application context", null);
    }
  }

  private void userRegister(MethodCall call, final Result result) {
    String userId = call.argument("userId");
    manService.getMANAnalytics().userRegister(userId);
    result.success(true);
  }

  private void updateUserAccount(MethodCall call, final Result result) {
    String username = call.argument("username");
    String userId = call.argument("userId");
    manService.getMANAnalytics().updateUserAccount(username, userId);
    result.success(true);
  }

  private void turnOffAutoPageTrack(MethodCall call, final Result result) {
    manService.getMANAnalytics().turnOffAutoPageTrack();
    result.success(true);
  }

  private void trackPage(MethodCall call, final Result result) {
    String pageName = call.argument("pageName");
    String referrer = call.argument("referPageName");
    Map<String, String> properties = call.argument("properties");

    if (manService != null) {
      MANPageHitBuilder builder = new MANPageHitBuilder(pageName);
      builder.setReferPage(referrer);
      if (call.argument("duration") != null) {
        Long duration = call.argument("duration");
        builder.setDurationOnPage(duration);
      }
      builder.setProperties(properties);

      manService.getMANAnalytics().getDefaultTracker().send(builder.build());

      result.success(true);
    } else {
      result.error("uninitialized", "manservice未初始化", null);
    }
  }

  private void trackEvent(MethodCall call, final Result result) {
    String pageName = call.argument("pageName");
    String eventName = call.argument("eventName");
    Map<String, String> properties = call.argument("properties");

    if (manService != null) {
      MANHitBuilders.MANCustomHitBuilder builder = new MANHitBuilders.MANCustomHitBuilder(eventName);
      if (call.argument("duration") != null) {
        Long duration = call.argument("duration");
        builder.setDurationOnEvent(duration);
      }

      builder.setEventPage(pageName);
      builder.setProperties(properties);

      manService.getMANAnalytics().getDefaultTracker().send(builder.build());
      result.success(true);
    } else {
      result.error("uninitialized", "manservice未初始化", null);
    }
  }
}
