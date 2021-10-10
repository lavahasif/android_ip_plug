package com.shersoft.android_ip


import android.app.Activity
import android.content.Context
import android.net.ConnectivityManager
import androidx.annotation.NonNull
import com.shersoft.android_ip.util.ConnectedDevice
import com.shersoft.android_ip.util.EnableDevice
import com.shersoft.android_ip.util.MyIp
import com.shersoft.android_ip.util.ShareFile
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel


/** AndroidIpPlugin */
class AndroidIpPlugin : FlutterPlugin, ActivityAware {


    interface mybroadcastList {
        fun onChange(typeevent: String)
    }

    interface IDeviceConnected {
        fun DeviceConnected(ip: String)
    }

    interface IPortScan {
        fun onSuccess(appSettingsOpenedSuccessfully: Map<String, String>)
        fun onError(portScan: Map<String, String>)
    }

    interface IShare {
        fun onFileShared(status: String)
    }

    interface IPermissions {
        fun onSendPermission(name: String, status: Boolean)
        fun onError(name: String, status: Boolean, errorCode: String?)
    }

    interface OpenAppSettingsSuccessCallback {
        fun onSuccess(appSettingsOpenedSuccessfully: Boolean)
    }

    interface ErrorCallback {
        fun onError(errorCode: String?, errorDescription: String?)
    }

    lateinit var myIp: MyIp
    lateinit var iDeviceConnected: IDeviceConnected
    lateinit var connecteddevice: ConnectedDevice
    lateinit var menableDevice: EnableDevice
    lateinit var sharefile: ShareFile
    lateinit var context: Context
    override fun onDetachedFromActivity() {
        if (permissionmanger != null) {
            mbinding.addRequestPermissionsResultListener(permissionmanger)
            mbinding.addActivityResultListener(permissionmanger)
        }
        methodCallHandler = null
        mPermissionlistnerImp?.permissionmanger = null;
    }


    private lateinit var channel: MethodChannel
    private lateinit var echannel: EventChannel
    private lateinit var ipScanlist: EventChannel
    private lateinit var echannellist: EventChannel
    private lateinit var Permissionchannel: EventChannel
    private lateinit var sharechannel: EventChannel
    private lateinit var portbyIpchannel: EventChannel
    private lateinit var portbyCurrentchannel: EventChannel
    private lateinit var connManager: ConnectivityManager
    var methodCallHandler: MethodCallImpl? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {

        context = flutterPluginBinding.applicationContext

        myIp = MyIp(context)

        connecteddevice = ConnectedDevice(context)
        menableDevice = EnableDevice(context)
        sharefile = ShareFile(context)
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "android_ip")
        methodCallHandler = MethodCallImpl(
            context,
            connecteddevice,
            menableDevice,
            sharefile,
            myIp
        )


        echannel = EventChannel(flutterPluginBinding.binaryMessenger, "networklistner")
        ipScanlist = EventChannel(flutterPluginBinding.binaryMessenger, "ipscanlist")
        echannellist = EventChannel(flutterPluginBinding.binaryMessenger, "echannellist")
        sharechannel = EventChannel(flutterPluginBinding.binaryMessenger, "sharelistner")
        Permissionchannel = EventChannel(flutterPluginBinding.binaryMessenger, "permissionlistner")
        portbyCurrentchannel =
            EventChannel(flutterPluginBinding.binaryMessenger, "portbyCurrentchannel")
        portbyIpchannel =
            EventChannel(flutterPluginBinding.binaryMessenger, "portbyIpchannel")

        mNetworkListnerImp = NetworkListnerImp(context)
        mPermissionlistnerImp = PermissionlistnerImp(context)
        mSharelistnerImp = SharelistnerImp(context, sharefile)
        mConnectedDevicelist = ConnectedDevicelistimp(context, connecteddevice, myIp)
        mipDevicelistimp = ipDevicelistimp(context, connecteddevice, myIp)

        channel.setMethodCallHandler(methodCallHandler)
        setEventChannel()

    }

    var mNetworkListnerImp: NetworkListnerImp? = null
    var mPermissionlistnerImp: PermissionlistnerImp? = null
    var mSharelistnerImp: SharelistnerImp? = null
    var mConnectedDevicelist: ConnectedDevicelistimp? = null
    var mipDevicelistimp: ipDevicelistimp? = null
    var mPortScannerDevicelistimp: PortScannerDevicelistimp? = null
    private fun setEventChannel() {


        Permissionchannel.setStreamHandler(mPermissionlistnerImp)



        echannel.setStreamHandler(mNetworkListnerImp)
        ipScanlist.setStreamHandler(mipDevicelistimp)
        echannellist.setStreamHandler(mConnectedDevicelist)

        sharechannel.setStreamHandler(mSharelistnerImp)
        mPortScannerDevicelistimp = PortScannerDevicelistimp(
            portbyCurrentchannel,
            portbyIpchannel,
            context,
            connecteddevice,
            myIp
        )
        mPortScannerDevicelistimp?.getportbbyIp()
        mPortScannerDevicelistimp?.portbbyIpCurrent()


    }


    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        if (mNetworkListnerImp?.receiver != null)
            context.unregisterReceiver(mNetworkListnerImp?.receiver)
        channel.setMethodCallHandler(null)
        echannel.setStreamHandler(null)
        ipScanlist.setStreamHandler(null)
        echannellist.setStreamHandler(null)
        portbyCurrentchannel.setStreamHandler(null)
        portbyIpchannel.setStreamHandler(null)

        mNetworkListnerImp = null;

    }


    lateinit var mactivity: Activity
    lateinit var permissionmanger: PermissionManger
    lateinit var mbinding: ActivityPluginBinding
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        mactivity = binding.activity
        mbinding = binding;
        methodCallHandler?.mactivity = mactivity
        permissionmanger = PermissionManger(mactivity)
        mPermissionlistnerImp?.permissionmanger = permissionmanger;
        methodCallHandler?.permissionmanger = permissionmanger
        if (permissionmanger != null) {
            binding.addRequestPermissionsResultListener(permissionmanger)
            binding.addActivityResultListener(permissionmanger)
        }
    }

    override fun onDetachedFromActivityForConfigChanges() {
        if (permissionmanger != null) {
            mbinding.addRequestPermissionsResultListener(permissionmanger)
            mbinding.addActivityResultListener(permissionmanger)
        }
        methodCallHandler = null
        mPermissionlistnerImp?.permissionmanger = null;

    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        mactivity = binding.activity
        mbinding = binding;
        methodCallHandler?.mactivity = mactivity
        permissionmanger = PermissionManger(mactivity)
        if (permissionmanger != null) {
            binding.addRequestPermissionsResultListener(permissionmanger)
            binding.addActivityResultListener(permissionmanger)
        }
    }
}






