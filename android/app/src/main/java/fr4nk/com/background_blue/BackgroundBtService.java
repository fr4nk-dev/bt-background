package fr4nk.com.background_blue;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Intent;
import android.os.Binder;
import android.os.Build;
import android.os.IBinder;

import androidx.annotation.Nullable;

import static androidx.core.app.NotificationCompat.PRIORITY_HIGH;

public class BackgroundBtService extends Service {
    private static final String CHANNEL = "fr4nk.com/background-location";

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return new Binder();
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        Intent notificationIntent = new Intent(this, MainActivity.class);
        PendingIntent pendingIntent =
                PendingIntent.getActivity(this, 0, notificationIntent, 0);

        Notification.Builder notificationBuilder;

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            notificationBuilder = new Notification.Builder(this, "Bluetooth Service");
            NotificationManager manager = getSystemService(NotificationManager.class);

            NotificationChannel notificationChannel = new NotificationChannel(CHANNEL,
                    "BackgroundBt",
                    NotificationManager.IMPORTANCE_DEFAULT);

            manager.createNotificationChannel(notificationChannel);

            notificationBuilder.setChannelId(CHANNEL);
        } else {
            notificationBuilder = new Notification.Builder(this);
        }

        notificationBuilder.setContentTitle("APLICACION ACTIVA");
        notificationBuilder.setContentText("Escaneando activo");
         notificationBuilder.setContentIntent(pendingIntent);
        Notification notification = notificationBuilder.build();

        startForeground(PRIORITY_HIGH, notification);
        return START_STICKY;
    }
}
