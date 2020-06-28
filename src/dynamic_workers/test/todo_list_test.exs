#---
# Course Name:	Distributed Systems and Parallel Computing		Course ID:	COMP S363F
# Student Name:	Au Chi Chung	Student ID:	12017765
# Remark:		Exam Assignment
#---

defmodule TodoListTest do
	use ExUnit.Case, async: true
	
	test "empty_list" do
		assert Todo.List.size(Todo.List.new()) == 0
	end
	
	test "add_entry" do
		todo_list =
			Todo.List.new()
			|> Todo.List.add_entry(%{date: ~D[2020-05-22], start_time: ~T[12:00:00], end_time: ~T[13:00:00], title: "Dentist"})
			|> Todo.List.add_entry(%{date: ~D[2020-05-23], start_time: ~T[13:00:00], end_time: ~T[14:00:00], title: "Shopping"})
			|> Todo.List.add_entry(%{date: ~D[2020-05-22], start_time: ~T[13:00:00], end_time: ~T[14:00:00], title: "Movies"})
			
		assert Todo.List.size(todo_list) == 3
		assert todo_list |> Todo.List.entries_date(~D[2020-05-22]) |> length() == 2
		assert todo_list |> Todo.List.entries_date(~D[2020-05-23]) |> length() == 1
		assert todo_list |> Todo.List.entries_date(~D[2020-05-24]) |> length() == 0
		
		entries = todo_list |> Todo.List.entries_date(~D[2020-05-22]) |> Enum.map(& &1.title)
		assert entries == ["Dentist", "Movies"] 
	end
	
	test "update_entry" do
		todo_list =
			Todo.List.new()
			|> Todo.List.add_entry(%{date: ~D[2020-05-22], start_time: ~T[12:00:00], end_time: ~T[13:00:00], title: "Dentist"})
			|> Todo.List.add_entry(%{date: ~D[2020-05-23], start_time: ~T[13:00:00], end_time: ~T[14:00:00], title: "Shopping"})
			|> Todo.List.add_entry(%{date: ~D[2020-05-22], start_time: ~T[13:00:00], end_time: ~T[14:00:00], title: "Movies"})
			|> Todo.List.update_entry(2, &Map.put(&1, :title, "Updated shopping"))
			
		assert Todo.List.size(todo_list) == 3
		assert Todo.List.entries_date(todo_list, ~D[2020-05-23]) == [%{id: 2, date: ~D[2020-05-23], start_time: ~T[13:00:00], end_time: ~T[14:00:00], title: "Updated shopping"}]
	end
	
	test "delete_entry" do
		todo_list =
			Todo.List.new()
			|> Todo.List.add_entry(%{date: ~D[2020-05-22], start_time: ~T[12:00:00], end_time: ~T[13:00:00], title: "Dentist"})
			|> Todo.List.add_entry(%{date: ~D[2020-05-23], start_time: ~T[13:00:00], end_time: ~T[14:00:00], title: "Shopping"})
			|> Todo.List.add_entry(%{date: ~D[2020-05-22], start_time: ~T[13:00:00], end_time: ~T[14:00:00], title: "Movies"})
			|> Todo.List.delete_entry(2)
		
		assert Todo.List.size(todo_list) == 2
		assert Todo.List.entries_date(todo_list, ~D[2020-05-23]) == []
	end
	
	test "count_entries" do
		todo_list =
			Todo.List.new([
				%{date: ~D[2020-05-22], start_time: ~T[12:00:00], end_time: ~T[13:00:00], title: "Movie"},
				%{date: ~D[2020-05-22], start_time: ~T[12:00:00], end_time: ~T[13:00:00], title: "Dentist"},
				%{date: ~D[2020-05-22], start_time: ~T[11:00:00], end_time: ~T[12:00:00], title: "Shopping"},
				%{date: ~D[2020-05-23], start_time: ~T[11:00:00], end_time: ~T[12:00:00], title: "Shopping"}
			])
			
		count = Todo.List.count_entries(todo_list)
		assert count == %{"Dentist" => 1, "Movie" => 1, "Shopping" => 2}
		
		countByDate = Todo.List.count_entries(todo_list, ~D[2020-05-22])
		assert countByDate == %{"Dentist" => 1, "Movie" => 1, "Shopping" => 1}
	end
	
	test "entries" do
		todo_list =
			Todo.List.new([
				%{date: ~D[2020-05-22], start_time: ~T[12:00:00], end_time: ~T[13:00:00], title: "Dentist"},
				%{date: ~D[2020-05-23], start_time: ~T[13:00:00], end_time: ~T[14:00:00], title: "Shopping"},
				%{date: ~D[2020-05-22], start_time: ~T[13:00:00], end_time: ~T[14:00:00], title: "Movies"}
			])
			
		assert Todo.List.size(todo_list) == 3
		assert todo_list |> Todo.List.entries_date(~D[2020-05-22]) |> length() == 2
		assert todo_list |> Todo.List.entries_date(~D[2020-05-23]) |> length() == 1
		assert todo_list |> Todo.List.entries_date(~D[2020-05-24]) |> length() == 0
		
		entries = Todo.List.entries(todo_list)
		assert entries == [
			%{id: 1, date: ~D[2020-05-22], start_time: ~T[12:00:00], end_time: ~T[13:00:00], title: "Dentist"},
			%{id: 3, date: ~D[2020-05-22], start_time: ~T[13:00:00], end_time: ~T[14:00:00], title: "Movies"},
			%{id: 2, date: ~D[2020-05-23], start_time: ~T[13:00:00], end_time: ~T[14:00:00], title: "Shopping"}
		]
		
		entriesTitle = todo_list |> Todo.List.entries_title("Movies")
		assert entriesTitle == [%{title: "Movies", id: 3, date: ~D[2020-05-22], start_time: ~T[13:00:00], end_time: ~T[14:00:00]}]
		
		entriesDate = todo_list |> Todo.List.entries_date(~D[2020-05-22]) |> Enum.map(& &1.title)
		assert entriesDate == ["Dentist", "Movies"]
		
		entriesTime = todo_list |> Todo.List.entries_time(~T[13:00:00]) |> Enum.map(& &1.title)
		assert entriesTime == ["Movies", "Shopping"]
		
		entriesDateTime = todo_list |> Todo.List.entries_dateTime(~D[2020-05-23], ~T[13:00:00]) |> Enum.map(& &1.title)
		assert entriesDateTime == ["Shopping"]
	end
	
	test "track_time" do
		todo_list =
			Todo.List.new()
			|> Todo.List.add_entry(%{date: ~D[2020-05-22], start_time: ~T[12:00:00], end_time: ~T[13:00:00], title: "Dentist"})
			|> Todo.List.add_entry(%{date: ~D[2020-05-23], start_time: ~T[13:00:00], end_time: ~T[14:00:00], title: "Shopping"})
			|> Todo.List.add_entry(%{date: ~D[2020-05-23], start_time: ~T[16:00:00], end_time: ~T[17:30:00], title: "Shopping"})
			|> Todo.List.add_entry(%{date: ~D[2020-05-22], start_time: ~T[13:00:00], end_time: ~T[14:00:00], title: "Movies"})
			|> Todo.List.add_entry(%{date: ~D[2020-05-24], start_time: ~T[13:00:00], end_time: ~T[14:00:00], title: "Shopping"})
			
		assert Todo.List.size(todo_list) == 5
		assert Todo.List.track_time(todo_list, ~D[2020-05-30], "Shopping") == 0
		assert Todo.List.track_time(todo_list, ~D[2020-05-24], "Shopping") == 1
		assert Todo.List.track_time(todo_list, ~D[2020-05-23], "Shopping") == 2.5
		
		assert Todo.List.track_time(todo_list, ~D[2020-05-22]) == 2
		assert Todo.List.track_timeForTitle(todo_list, "Shopping") == 3.5
	end
end
