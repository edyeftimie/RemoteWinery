package com.example.remotewinery.Fragment

import android.app.Activity
import android.os.Build
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.annotation.RequiresApi
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentContainerView
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.RecyclerView
import androidx.fragment.app.viewModels
import com.example.remotewinery.Activity.WineListActivity
import com.example.remotewinery.Adapter.WineAdapter
import com.example.remotewinery.R
import com.example.remotewinery.ViewModel.WineViewModel
import com.example.remotewinery.databinding.FragmentWineListBinding

class WineListFragment : Fragment() {
    private lateinit var wineViewModel: WineViewModel
    private lateinit var wineAdapter: WineAdapter

    @RequiresApi(Build.VERSION_CODES.TIRAMISU)
    override fun onCreateView(

        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val view = inflater.inflate(R.layout.fragment_wine_list, container,false)
//        val recyclerView = view.findViewById<RecyclerView>(R.id.wine_recyclerview)
        val binding = FragmentWineListBinding.inflate(inflater, container, false)

        wineViewModel = ViewModelProvider(requireActivity())[WineViewModel::class.java]
        wineAdapter = WineAdapter(
            emptyList(),
            clickListener = { wine ->
                (activity as? WineListActivity)?.onClickListener(wine)
            },
            longClickListener = { wine ->
                (activity as? WineListActivity)?.onLongClickListener(wine)
            }
//            onLongClickListener = { wine ->
//                (activity as? WineListActivity)?.onLongClickListener(wine)
//            }
        )

        wineViewModel.wines.observe(viewLifecycleOwner) {wines ->
            wineAdapter._wines = wines
            wineAdapter.notifyDataSetChanged()
        }
//        recyclerView.adapter = wineAdapter
        binding.wineRecyclerview.adapter = wineAdapter

        return binding.root
        return view
    }

}