#---
# Course Name:	Distributed Systems and Parallel Computing		Course ID:	COMP S363F
# Student Name:	Au Chi Chung	Student ID:	12017765
# Remark:		Exam Assignment
#---

defmodule Todo.List do
	defstruct auto_id: 1, entries: %{}
	
	def new(entries \\ []) do
		Enum.reduce(entries, %Todo.List{}, &add_entry(&2, &1))
	end
	
	def size(todo_list) do
		Map.size(todo_list.entries)
	end
	
	def count_entries(todo_list) do
		todo_list.entries
		|> Enum.frequencies_by(fn {_,entry} -> entry.title end)
	end
	
	def count_entries(todo_list, date) do
		todo_list.entries
		|> Stream.filter(fn {_, entry} -> entry.date == date end)
		|> Enum.frequencies_by(fn {_,entry} -> entry.title end)
	end
	
	def add_entry(todo_list, entry) do
		entry = Map.put(entry, :id, todo_list.auto_id)
		new_entries = Map.put(todo_list.entries, todo_list.auto_id, entry)
		%Todo.List{todo_list | entries: new_entries, auto_id: todo_list.auto_id + 1}
	end
	
	def update_entry(todo_list, %{} = new_entry) do
		update_entry(todo_list, new_entry.id, fn _ -> new_entry end)
	end
	
	def update_entry(todo_list, entry_id, updater_fun) do
		case Map.fetch(todo_list.entries, entry_id) do
			:error -> todo_list
			{:ok, old_entry} -> new_entry = updater_fun.(old_entry)
			new_entries = Map.put(todo_list.entries, new_entry.id, new_entry)
			%Todo.List{todo_list | entries: new_entries}
		end
	end
	
	def delete_entry(todo_list, entry_id) do
		%Todo.List{todo_list | entries: Map.delete(todo_list.entries, entry_id)}
	end
	
	def report_summary(todo_list) do
		IO.puts("\n Report Summary : \n")
		
		todo_list.entries
		|> Enum.sort_by(fn {_, entry} -> entry.title end)
		|> Enum.sort_by(fn {_, entry} -> entry.date end)
		|> Enum.sort_by(fn {_, entry} -> entry.start_time end)
		|> Enum.each(fn {_, entry} -> IO.puts(" # " <> entry.title <> "	" <>
			Date.to_string(entry.date) <> "	" <>
			Time.to_string(entry.start_time) <> " - " <> Time.to_string(entry.end_time) <> "	" <>
			"( " <> Float.to_string(Todo.List.track_time(todo_list, entry.date, entry.title)) <> " hour(s) )")
			end)
		
		counter = Enum.into(Todo.List.count_entries(todo_list), %{}, fn {key, val} -> {String.to_atom(key), val} end)
		IO.puts("\n Event Counter : " <> inspect(Map.to_list(counter)))
	end
	
	def daily_summary(todo_list, date) do
		IO.puts("\n Daily Summary for date : #{date} \n")
		
		todo_list.entries
		|> Stream.filter(fn {_, entry} -> entry.date == date end)
		|> Enum.sort_by(fn {_, entry} -> entry.title end)
		|> Enum.sort_by(fn {_, entry} -> entry.start_time end)
		|> Enum.each(fn {_, entry} -> IO.puts(" # " <> entry.title <> "	" <>
			Time.to_string(entry.start_time) <> " - " <> Time.to_string(entry.end_time) <> "	" <>
			"( " <> Float.to_string(Todo.List.track_time(todo_list, entry.date, entry.title)) <> " hour(s) )")
			end)
			
		counter = Enum.into(Todo.List.count_entries(todo_list), %{}, fn {key, val} -> {String.to_atom(key), val} end)
		IO.puts("\n Event Counter : " <> inspect(Map.to_list(counter)))
		IO.puts(" Total time spent in this day planning : " <> Float.to_string(Todo.List.track_time(todo_list, date)) <> " hour(s)")
	end
	
	def entries(todo_list) do
		todo_list.entries
		|> Enum.sort_by(fn {_, entry} -> entry.title end)
		|> Enum.sort_by(fn {_, entry} -> entry.date end)
		|> Enum.sort_by(fn {_, entry} -> entry.start_time end)
		|> Enum.map(fn {_, entry} -> entry end)
	end
	
	def entries_title(todo_list, title) do
		todo_list.entries
		|> Stream.filter(fn {_, entry} -> entry.title == title end)
		|> Enum.sort_by(fn {_, entry} -> entry.date end)
		|> Enum.sort_by(fn {_, entry} -> entry.start_time end)
		|> Enum.map(fn {_, entry} -> entry end)
	end
	
	def entries_date(todo_list, date) do
		todo_list.entries
		|> Stream.filter(fn {_, entry} -> entry.date == date end)
		|> Enum.sort_by(fn {_, entry} -> entry.title end)
		|> Enum.sort_by(fn {_, entry} -> entry.start_time end)
		|> Enum.map(fn {_, entry} -> entry end)
	end
	
	def entries_time(todo_list, start_time) do
		todo_list.entries
		|> Stream.filter(fn {_, entry} -> entry.start_time == start_time end)
		|> Enum.sort_by(fn {_, entry} -> entry.title end)
		|> Enum.sort_by(fn {_, entry} -> entry.date end)
		|> Enum.map(fn {_, entry} -> entry end)
	end
	
	def entries_dateTime(todo_list, date, start_time) do
		todo_list.entries
		|> Stream.filter(fn {_, entry} -> entry.date == date end)
		|> Stream.filter(fn {_, entry} -> entry.start_time == start_time end)
		|> Enum.sort_by(fn {_, entry} -> entry.title end)
		|> Enum.map(fn {_, entry} -> entry end)
	end
	
	def track_time(todo_list, date) do
		todo_list.entries
		|> Stream.filter(fn {_, entry} -> entry.date == date end)
		|> Enum.map(fn {_, entry} -> entry end)
		|> Enum.reduce(0, fn entry, accumulator -> (Time.diff(entry.end_time, entry.start_time, :second) / (60 * 60)) + accumulator end)
	end
	
	def track_time(todo_list, date, title) do
		todo_list.entries
		|> Stream.filter(fn {_, entry} -> entry.date == date end)
		|> Stream.filter(fn {_, entry} -> entry.title == title end)
		|> Enum.map(fn {_, entry} -> entry end)
		|> Enum.reduce(0, fn entry, accumulator -> (Time.diff(entry.end_time, entry.start_time, :second) / (60 * 60)) + accumulator end)
	end
	
	def track_timeForTitle(todo_list, title) do
		todo_list.entries
		|> Stream.filter(fn {_, entry} -> entry.title == title end)
		|> Enum.map(fn {_, entry} -> entry end)
		|> Enum.reduce(0, fn entry, accumulator -> (Time.diff(entry.end_time, entry.start_time, :second) / (60 * 60)) + accumulator end)
	end
end
