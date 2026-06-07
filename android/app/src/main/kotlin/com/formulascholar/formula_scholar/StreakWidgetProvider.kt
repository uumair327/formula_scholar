package com.formulascholar.formula_scholar

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider
import org.json.JSONObject
import android.view.View
import android.net.Uri
import android.content.Intent
import android.app.PendingIntent

class StreakWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.widget_streak).apply {
                val streakDataString = widgetData.getString("streak_data", null)
                if (streakDataString != null) {
                    try {
                        val json = JSONObject(streakDataString)
                        val isLoggedIn = json.optBoolean("isLoggedIn", false)

                        if (isLoggedIn) {
                            setViewVisibility(R.id.tv_message, View.GONE)
                            setViewVisibility(R.id.ll_streak_info, View.VISIBLE)
                            
                            val currentStreak = json.optInt("currentStreak", 0)
                            val maxStreak = json.optInt("maxStreak", 0)
                            
                            setTextViewText(R.id.tv_streak_count, "$currentStreak Days")
                            setTextViewText(R.id.tv_max_streak, "Best: $maxStreak")
                        } else {
                            setViewVisibility(R.id.tv_message, View.VISIBLE)
                            setViewVisibility(R.id.ll_streak_info, View.GONE)
                            setTextViewText(R.id.tv_message, "Log in to see your streak!")
                        }
                    } catch (e: Exception) {
                        setViewVisibility(R.id.tv_message, View.VISIBLE)
                        setViewVisibility(R.id.ll_streak_info, View.GONE)
                        setTextViewText(R.id.tv_message, "Error loading data")
                    }
                } else {
                    setViewVisibility(R.id.tv_message, View.VISIBLE)
                    setViewVisibility(R.id.ll_streak_info, View.GONE)
                    setTextViewText(R.id.tv_message, "No data available")
                }

                // Add click listener
                val pendingIntentWithData = es.antonborri.home_widget.HomeWidgetLaunchIntent.getActivity(
                        context,
                        MainActivity::class.java,
                        Uri.parse("homeWidget://streak"))
                setOnClickPendingIntent(R.id.widget_root, pendingIntentWithData)
            }

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
