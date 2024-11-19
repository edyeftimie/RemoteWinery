package com.example.remotewinery.Activity

import android.app.Activity
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.webkit.URLUtil
import androidx.annotation.RequiresApi
import androidx.appcompat.app.AppCompatActivity
import com.example.remotewinery.Data.Wine
import com.example.remotewinery.databinding.ActivityWineDetailBinding

class WineDetailActivity : AppCompatActivity() {
    private lateinit var binding: ActivityWineDetailBinding
    private var wine: Wine? = null

    @RequiresApi(Build.VERSION_CODES.TIRAMISU)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityWineDetailBinding.inflate(layoutInflater)
        setContentView(binding.root)

        val wine = intent.getParcelableExtra("editedWine", Wine::class.java)

        wine?.let {
            binding.apply {
                wineNameEdit.setText(it.name)
                wineTypeEdit.setText(it.type)
                wineYearEdit.setText(it.year.toString())
                wineIngredientsEdit.setText(it.listOfIngredients)
                wineCaloriesEdit.setText(it.numberOfCalories.toString())
                winePhotoURLEdit.setText(it.photoURL)
            }
        }

        binding.saveButton.setOnClickListener {
            val name = binding.wineNameEdit.text.toString()
            val type = binding.wineTypeEdit.text.toString()
            val yearString = binding.wineYearEdit.text.toString()
            var year = 0
            if (yearString.isNotBlank()) {
                year = yearString.toInt()
            }
            val ingredients = binding.wineIngredientsEdit.text.toString()
            val caloriesString = binding.wineCaloriesEdit.text.toString()
            var calories = 0
            if (caloriesString.isNotBlank()) {
                calories = caloriesString.toInt()
            }
            val photoURL = binding.winePhotoURLEdit.text.toString()

            var isValid = true
            if (name.isBlank()) {
                binding.wineNameEdit.error = "Name is required"
                isValid = false
            }
            if (year == 0) {
                binding.wineYearEdit.error = "Year is required"
                isValid = false
            }
            if (ingredients.isBlank()) {
                binding.wineIngredientsEdit.error = "Ingredients are required"
                isValid = false
            }
            if (calories == 0) {
                binding.wineCaloriesEdit.error = "Calories are required"
                isValid = false
            }
            if (type.isBlank()) {
                binding.wineTypeEdit.error = "Type is required"
                isValid = false
            }
            if (photoURL.isBlank()) {
                binding.winePhotoURLEdit.error = "Photo URL is required"
                isValid = false
            }
            //test if the url is a valid one
            if (!URLUtil.isValidUrl(photoURL) || !photoURL.endsWith(".jpg") && !photoURL.endsWith(".png")) {
                binding.winePhotoURLEdit.error = "Photo URL is not valid"
                isValid = false
            }
            if (year < 1900 || year > 2024) {
                binding.wineYearEdit.error = "Year must be between 1900 and 2024"
                isValid = false
            }
            if (calories <= 0) {
                binding.wineCaloriesEdit.error = "Calories must be a positive number"
                isValid = false
            }

            if (isValid) {

                val updatedWine = wine?.copy(
                    name = name,
                    type = type,
                    year = year,
                    listOfIngredients = ingredients,
                    numberOfCalories = calories,
                    photoURL = photoURL
                ) ?: Wine(
                    id = 0,
                    name = name,
                    type = type,
                    year = year,
                    listOfIngredients = ingredients,
                    numberOfCalories = calories,
                    photoURL = photoURL
                )

                val resultIntent = Intent().apply {
                    if (wine != null) {
                        putExtra("editedWine", updatedWine)
                    } else {
                        putExtra("newWine", updatedWine)
                    }
                }
                setResult(RESULT_OK, resultIntent)
                finish()
            }
        }
    }
}