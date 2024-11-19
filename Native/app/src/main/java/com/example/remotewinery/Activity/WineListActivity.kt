package com.example.remotewinery.Activity

import android.app.Activity
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.widget.Toast
import androidx.activity.result.contract.ActivityResultContracts
import androidx.activity.viewModels
import androidx.annotation.RequiresApi
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import com.example.remotewinery.Data.Wine
import com.example.remotewinery.Fragment.WineListFragment
import com.example.remotewinery.R
import com.example.remotewinery.databinding.ActivityWineListBinding
import com.example.remotewinery.ViewModel.WineViewModel

class WineListActivity : AppCompatActivity(
    R.layout.activity_wine_list
) {
    private lateinit var binding: ActivityWineListBinding
    private val wineViewModel: WineViewModel by viewModels()

    @RequiresApi(Build.VERSION_CODES.TIRAMISU)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_wine_list)

        binding = ActivityWineListBinding.inflate(layoutInflater)
        setContentView(binding.root)

        if (savedInstanceState == null) {
            supportFragmentManager.beginTransaction()
                .replace(R.id.fragment_container, WineListFragment())
                .commit()
        }

        binding.floatingActionButton.setOnClickListener {
            val intent = Intent(this, WineDetailActivity::class.java)
            resultLauncherButton.launch(intent)
        }
    }

    @RequiresApi(Build.VERSION_CODES.TIRAMISU)
    var resultLauncherButton = registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
        if (result.resultCode == Activity.RESULT_OK) {
            val newWine = result.data?.getParcelableExtra("newWine", Wine::class.java)
            newWine?.let {
                wineViewModel.addWine(it)
            }
        }
    }

    @RequiresApi(Build.VERSION_CODES.TIRAMISU)
    fun onClickListener(wine: Wine) {
        val intent = Intent(this, WineDetailActivity::class.java).apply {
            putExtra("editedWine", wine)
        }
        resultLauncherEdit.launch(intent)
    }

    @RequiresApi(Build.VERSION_CODES.TIRAMISU)
    fun onLongClickListener(wine: Wine) {
//        Toast.makeText(this, "Long click on ${wine.name}", Toast.LENGTH_SHORT).show()
//
//        wineViewModel.deleteWine(wine)
//        Toast.makeText(this, "Wine ${wine.name} deleted", Toast.LENGTH_SHORT).show()
        val dialog = AlertDialog.Builder(this)
            .setTitle("Delete Wine")
            .setMessage("Are you sure you want to delete ${wine.name}?")
            .setPositiveButton("Yes") { _, _ ->
                // User clicked "Yes", proceed with deletion
                wineViewModel.deleteWine(wine)
                Toast.makeText(this, "Wine ${wine.name} deleted", Toast.LENGTH_SHORT).show()
            }
            .setNegativeButton("No") { dialog, _ ->
                // User clicked "No", dismiss the dialog
                dialog.dismiss()
            }
            .create()

        dialog.show() // Show the dialog
    }

    @RequiresApi(Build.VERSION_CODES.TIRAMISU)
    var resultLauncherEdit = registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
        if (result.resultCode == Activity.RESULT_OK) {
            val editedWine = result.data?.getParcelableExtra("editedWine", Wine::class.java)
            editedWine?.let {
                wineViewModel.editWine(it)
            }
        }
    }
}
    

