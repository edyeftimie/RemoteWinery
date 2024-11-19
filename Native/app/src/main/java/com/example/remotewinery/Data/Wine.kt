package com.example.remotewinery.Data

import android.os.Parcelable
import kotlinx.parcelize.Parcelize

@Parcelize
data class Wine(val id: Int, val name: String, val type: String, val year: Int, val listOfIngredients: String, val numberOfCalories: Int, val photoURL: String) :
    Parcelable {
    override fun toString(): String = name
}