package com.example.remotewinery

import android.content.Intent
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.example.remotewinery.Activity.WineListActivity

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        if (savedInstanceState == null) {
            val intent = Intent(this, WineListActivity::class.java)
            startActivity(intent)
/*
            supportFragmentManager.beginTransaction()
                .replace(R.id.fragment_container, WineListFragment())
                .commit()
*/
        }
    }
}