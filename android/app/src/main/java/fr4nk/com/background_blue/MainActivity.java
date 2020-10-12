package fr4nk.com.background_blue;

import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
   private static final String CHANNEL = "fr4nk.com/background-location";

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

      new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
                (call, result) -> {
                    switch (call.method) {
                        case "start":
                            start();
                            break;
                        case "stop":
                            stop();
                            break;
                        default:
                            result.notImplemented();
                    }
                });
  }



   void start() {
        Intent intent = new Intent(this, BackgroundBtService.class);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(intent);
        } else {
            startService(intent);
        }
    }

    void stop() {
        Intent intent = new Intent(this, BackgroundBtService.class);        
        stopService(intent);        
    }

    @Override
    protected void onDestroy() {
        stop();
        super.onDestroy();
    }
}
