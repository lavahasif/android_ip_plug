package com.shersoft.android_ip

import android.content.Context
import com.shersoft.android_ip.util.ConnectedDevice
import com.shersoft.android_ip.util.MyIp
import io.flutter.plugin.common.EventChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.launch
import org.json.JSONObject
import java.util.*

class PortScannerDevicelistimp(
    val portbycurrentchannel: EventChannel,
    val portbyipchannel: EventChannel,
    val context: Context,
    val connecteddevice: ConnectedDevice,
    val myIp: MyIp
) {
    val scope = CoroutineScope(Dispatchers.Main + SupervisorJob())
    fun getportbbyIp() {

        portbyipchannel.setStreamHandler(object : EventChannel.StreamHandler {

            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                val hashMap = arguments as HashMap<String, String>
                val port = hashMap["port"]
                val ip = hashMap["ip"]
                val timeout = hashMap["timeout"] as Int
                val arrayList = hashMap["porta"] as ArrayList<String>
                val from = arrayList.get(0) as Int
                val to = arrayList.get(1) as Int

                if (ip != null) {
                    port?.toInt()?.let {
                        if (timeout != null) {
                            connecteddevice.portbbyIp(ip,
                                it,
                                timeout.toInt(),
                                arrayListOf(from, to),
                                object : AndroidIpPlugin.IPortScan {
                                    override fun onSuccess(data: Map<String, String>) {
                                        scope.launch { events?.success(data) }

                                    }

                                    override fun onError(data: Map<String, String>) {
                                        scope.launch { events?.success(data) }
                                    }

                                })
                        }
                    }
                }
            }

            override fun onCancel(arguments: Any?) {
//                print("=========>$arguments")
            }

        })
    }

    fun portbbyIpCurrent() {
        portbycurrentchannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                val hashMap = arguments as HashMap<String, String>
                val port = hashMap["port"]
                val ip = hashMap["ip"]
                val timeout = hashMap["timeout"]
                val arrayList = hashMap["porta"] as ArrayList<String>
                val from = arrayList.get(0) as Int
                val to = arrayList.get(1) as Int

                if (ip != null) {
                    port?.toInt()?.let {
                        if (timeout != null) {
                            connecteddevice.portbbyIp(ip,
                                it,
                                timeout.toInt(),
                                arrayListOf(from, to),
                                object : AndroidIpPlugin.IPortScan {
                                    override fun onSuccess(data: Map<String, String>) {

                                        scope.launch { events?.success(JSONObject(data)) }
                                    }

                                    override fun onError(data: Map<String, String>) {
                                        scope.launch { events?.success(JSONObject(data)) }
                                    }

                                })
                        }
                    }
                }

            }

            override fun onCancel(arguments: Any?) {
//                TODO("Not yet implemented")
            }

        })

    }


}
