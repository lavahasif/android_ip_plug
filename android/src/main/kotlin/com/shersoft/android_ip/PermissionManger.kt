package com.shersoft.android_ip

import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build.VERSION.SDK_INT
import android.os.Environment
import android.provider.Settings


class PermissionManger(val activity: Activity) :
    io.flutter.plugin.common.PluginRegistry.ActivityResultListener,
    io.flutter.plugin.common.PluginRegistry.RequestPermissionsResultListener {
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode == ACCESS_FINE_LOCATION_CODE) {
        }
        return false;
    }

    companion object {
        val ACCESS_FINE_LOCATION_CODE = 100
        val ACCESS_FINE_STORAGE_CODE = 102
        val ACCESS_FINE_LOCATION = 103
    }


    fun setManageExternal() {
        if (SDK_INT >= 30) {
            if (!Environment.isExternalStorageManager()) {
                try {
                    val uri = Uri.parse("package:${activity.getPackageName()}")
                    val intent = Intent(
                        Settings.ACTION_MANAGE_APP_ALL_FILES_ACCESS_PERMISSION,
                        uri
                    );
                    activity.startActivity(intent);
                } catch (e: Exception) {
                    val intent = Intent();
                    intent.setAction(Settings.ACTION_MANAGE_ALL_FILES_ACCESS_PERMISSION);
                    activity.startActivity(intent);
                };
            }
        }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>?,
        grantResults: IntArray?
    ): Boolean {
        if (requestCode == ACCESS_FINE_LOCATION_CODE) {
            if (grantResults?.isNotEmpty() == true && grantResults?.get(0) ?: null == PackageManager.PERMISSION_GRANTED) {
//                if (::iPermissions.isLateinit)
                iPermissions.let {
                    it?.onSendPermission(
                        "ACCESS_FINE_LOCATION_CODE",
                        true
                    )
                }


            } else {

                iPermissions.let {
                    it?.onSendPermission(
                        "ACCESS_FINE_LOCATION_CODE".toString(),
                        false
                    )
                }

            }
        } else if (requestCode == ACCESS_FINE_STORAGE_CODE) {
            setManageExternal();
        }
        return true;
    }

    var iPermissions: AndroidIpPlugin.IPermissions? = null;
    fun setListner(iPermissions: AndroidIpPlugin.IPermissions) {
        this.iPermissions = iPermissions;
    }
}
