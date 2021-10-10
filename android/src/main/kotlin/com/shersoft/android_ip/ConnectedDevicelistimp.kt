package com.shersoft.android_ip

import android.content.Context
import com.shersoft.android_ip.util.ConnectedDevice
import com.shersoft.android_ip.util.MyIp
import io.flutter.plugin.common.EventChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.launch
import java.util.*

class ConnectedDevicelistimp(
    val context: Context,
    val connecteddevice: ConnectedDevice,
    val myIp: MyIp
) : EventChannel.StreamHandler {

    val scope = CoroutineScope(Dispatchers.Main + SupervisorJob())
    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {

        connecteddevice.gethostData(myIp.getDeviceIpAddress(), object :
            AndroidIpPlugin.IDeviceConnected {
            override fun DeviceConnected(ip: String) {
//                        println("Event============>$ip")
                scope.launch {
                    events?.success(ip);
                }

            }
        })
    }

    override fun onCancel(arguments: Any?) {
        println(arguments.toString())
    }


}

class ipDevicelistimp(
    val context: Context,
    val connecteddevice: ConnectedDevice,
    val myIp: MyIp
) : EventChannel.StreamHandler {

    val scope = CoroutineScope(Dispatchers.Main + SupervisorJob())
    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {

        val hashMap = arguments as HashMap<String, String>

        var ip: String = hashMap["ip"].toString();

        if (ip != "")
            connecteddevice.gethostData(ip, object :
                AndroidIpPlugin.IDeviceConnected {
                override fun DeviceConnected(ip: String) {
//                        println("Event============>$ip")
                    scope.launch {
                        events?.success(ip);
                    }

                }
            })
    }

    override fun onCancel(arguments: Any?) {
        println(arguments.toString())
    }


}