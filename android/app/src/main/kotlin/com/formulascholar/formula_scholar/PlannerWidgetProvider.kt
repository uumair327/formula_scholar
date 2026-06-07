package com.formulascholar.formula_scholar

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider
import org.json.JSONObject
import org.json.JSONArray
import android.view.View
import android.net.Uri
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

class PlannerWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.widget_planner).apply {
                val plannerDataString = widgetData.getString("planner_data", null)
                if (plannerDataString != null) {
                    try {
                        val json = JSONObject(plannerDataString)
                        val isLoggedIn = json.optBoolean("isLoggedIn", false)

                        if (isLoggedIn) {
                            val tasks = json.optJSONArray("tasks") ?: JSONArray()
                            if (tasks.length() > 0) {
                                setViewVisibility(R.id.tv_message, View.GONE)
                                setViewVisibility(R.id.ll_tasks, View.VISIBLE)
                                
                                val format = SimpleDateFormat("MMM dd, HH:mm", Locale.getDefault())
                                
                                // Reset visibilities
                                setViewVisibility(R.id.tv_task_1, View.GONE)
                                setViewVisibility(R.id.tv_task_2, View.GONE)
                                setViewVisibility(R.id.tv_task_3, View.GONE)

                                for (i in 0 until minOf(tasks.length(), 3)) {
                                    val task = tasks.getJSONObject(i)
                                    val title = task.optString("title", "Task")
                                    val timestamp = task.optLong("timestamp", 0)
                                    val dateStr = if (timestamp > 0) format.format(Date(timestamp)) else ""
                                    
                                    val text = "• $title ($dateStr)"
                                    when (i) {
                                        0 -> {
                                            setViewVisibility(R.id.tv_task_1, View.VISIBLE)
                                            setTextViewText(R.id.tv_task_1, text)
                                        }
                                        1 -> {
                                            setViewVisibility(R.id.tv_task_2, View.VISIBLE)
                                            setTextViewText(R.id.tv_task_2, text)
                                        }
                                        2 -> {
                                            setViewVisibility(R.id.tv_task_3, View.VISIBLE)
                                            setTextViewText(R.id.tv_task_3, text)
                                        }
                                    }
                                }
                            } else {
                                setViewVisibility(R.id.tv_message, View.VISIBLE)
                                setViewVisibility(R.id.ll_tasks, View.GONE)
                                setTextViewText(R.id.tv_message, "No upcoming tasks! 🎉")
                            }
                        } else {
                            setViewVisibility(R.id.tv_message, View.VISIBLE)
                            setViewVisibility(R.id.ll_tasks, View.GONE)
                            setTextViewText(R.id.tv_message, "Log in to view your planner.")
                        }
                    } catch (e: Exception) {
                        setViewVisibility(R.id.tv_message, View.VISIBLE)
                        setViewVisibility(R.id.ll_tasks, View.GONE)
                        setTextViewText(R.id.tv_message, "Error loading data")
                    }
                } else {
                    setViewVisibility(R.id.tv_message, View.VISIBLE)
                    setViewVisibility(R.id.ll_tasks, View.GONE)
                    setTextViewText(R.id.tv_message, "No data available")
                }

                // Add click listener
                val pendingIntentWithData = es.antonborri.home_widget.HomeWidgetLaunchIntent.getActivity(
                        context,
                        MainActivity::class.java,
                        Uri.parse("homeWidget://planner"))
                setOnClickPendingIntent(R.id.widget_root, pendingIntentWithData)
            }

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
