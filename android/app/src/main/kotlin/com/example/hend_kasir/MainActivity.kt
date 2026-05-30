package com.example.hend_kasir

import android.bluetooth.BluetoothManager
import android.content.Context
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {
    private val CHANNEL = "hend_kasir/bluetooth"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getBondedDevices") {
                val bluetoothManager = getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
                val adapter = bluetoothManager.adapter
                val devices = adapter?.bondedDevices?.map {
                    mapOf("name" to (it.name ?: ""), "address" to (it.address ?: ""))
                } ?: emptyList()
                result.success(devices)
            } else {
                result.notImplemented()
            }
        }
    }
}
