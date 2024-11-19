package com.example.remotewinery.ViewModel
import com.example.remotewinery.Data.Wine

import androidx.lifecycle.LiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.MutableLiveData
import com.example.remotewinery.Data.Repository

class WineViewModel : ViewModel() {
    private val repository = Repository
    private val _wines = MutableLiveData<List<Wine>>()
    val wines: LiveData<List<Wine>> = _wines

    init {
        loadWines()
    }

    private fun loadWines() {
        _wines.value = repository.getWinesList()
    }

    fun editWine(updatedWine: Wine) {
        repository.editWine(updatedWine)
        loadWines()
    }

    fun addWine(newWine: Wine) {
        repository.createWine(newWine.name, newWine.type, newWine.year, newWine.listOfIngredients, newWine.numberOfCalories, newWine.photoURL)
        loadWines()
    }

    fun deleteWine(wine: Wine) {
        repository.deleteWine(wine.id)
        loadWines()
    }
}