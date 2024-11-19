package com.example.remotewinery.Adapter
import android.annotation.SuppressLint
import android.app.Activity
import android.content.Intent
import android.os.Build
import com.example.remotewinery.Data.Wine

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.activity.result.contract.ActivityResultContracts
import androidx.annotation.RequiresApi
import com.example.remotewinery.ViewModel.WineViewModel
import androidx.recyclerview.widget.RecyclerView
import coil.load
import com.example.remotewinery.Activity.WineDetailActivity
import com.example.remotewinery.databinding.ItemWineBinding

class WineAdapter(
    var _wines: List<Wine>,
    private val clickListener: (Wine) -> Unit,
    private val longClickListener: (Wine) -> Unit
) : RecyclerView.Adapter<WineAdapter.WineViewHolder>(){

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): WineViewHolder {
        val binding = ItemWineBinding.inflate(LayoutInflater.from(parent.context), parent, false)
        return WineViewHolder(binding)
    }

    override fun onBindViewHolder(holder: WineViewHolder, position: Int) {
        val wine = _wines[position]
        holder.bind(wine)
//        holder.itemView.setOnClickListener {
//            onClickListener(wine)
//        }
//        holder.itemView.setOnLongClickListener {
//            onLongClickListener(wine)
//            true
//        }
    }

    override fun getItemCount(): Int = _wines.size

    inner class WineViewHolder(private val binding: ItemWineBinding) : RecyclerView.ViewHolder(binding.root) {
        @SuppressLint("SetTextI18n")
        fun bind(wine: Wine) {
            binding.apply {
                wineImage.load(wine.photoURL)
                wineName.text = wine.name
                wineType.text = wine.type
                wineYear.text = wine.year.toString()
                wineCalories.text = wine.numberOfCalories.toString()
                wineIngredients.text = wine.listOfIngredients
                root.setOnClickListener {
                    clickListener(wine)
                }
                root.setOnLongClickListener{
                    longClickListener(wine)
                    true
                }
            }
        }
    }
}