#---
# Course Name:	Distributed Systems and Parallel Computing		Course ID:	COMP S363F
# Student Name:	Au Chi Chung	Student ID:	12017765
# Remark:		Exam Assignment
#---

defmodule TodoCacheTest do
	use ExUnit.Case
	
	setup_all do
		{:ok, todo_system_pid} = Todo.System.start_link()
		{:ok, todo_system_pid: todo_system_pid}
	end
	
	test "server_process" do
		bob = Todo.Cache.server_process("bob")
		
		assert bob != Todo.Cache.server_process("alice")
		assert bob == Todo.Cache.server_process("bob")
	end
	
	test "entries_correct_operations" do
		jane = Todo.Cache.server_process("jane")
		Todo.Server.add_entry(jane, %{date: ~D[2020-05-22], start_time: ~T[12:00:00], end_time: ~T[13:00:00], title: "Dentist"})
		entries = Todo.Server.entries_date(jane, ~D[2020-05-22])
		
		assert entries !== [%{id: 1, date: ~D[2020-05-22], start_time: ~T[12:00:00], end_time: ~T[13:00:00], title: "Shopping"}]
		assert entries == [%{id: 1, date: ~D[2020-05-22], start_time: ~T[12:00:00], end_time: ~T[13:00:00], title: "Dentist"}]
	end
	
	test "entries" do
		alvin = Todo.Cache.server_process("alvin")
		mandy = Todo.Cache.server_process("mandy")
		Todo.Server.add_entry(alvin, %{date: ~D[2020-05-22], start_time: ~T[11:30:00], end_time: ~T[14:00:00], title: "Testing 1 for alvin"})
		Todo.Server.add_entry(alvin, %{date: ~D[2020-05-22], start_time: ~T[13:30:00], end_time: ~T[14:00:00], title: "Testing 2 for alvin"})
		Todo.Server.add_entry(mandy, %{date: ~D[2020-05-22], start_time: ~T[13:30:00], end_time: ~T[14:00:00], title: "Testing 2 for mandy"})
		Todo.Server.add_entry(alvin, %{date: ~D[2020-05-23], start_time: ~T[20:00:00], end_time: ~T[21:00:00], title: "Testing 3 for alvin"})
		Todo.Server.add_entry(alvin, %{date: ~D[2020-05-24], start_time: ~T[13:30:00], end_time: ~T[14:00:00], title: "Testing 4 for alvin"})
		
		entries = Todo.Server.entries(mandy)
		assert entries == [%{id: 1, date: ~D[2020-05-22], start_time: ~T[13:30:00], end_time: ~T[14:00:00], title: "Testing 2 for mandy"}]
		
		entriesTitle = Todo.Server.entries_title(alvin, "Testing 1 for alvin")
		assert entriesTitle == [%{id: 1, date: ~D[2020-05-22], start_time: ~T[11:30:00], end_time: ~T[14:00:00], title: "Testing 1 for alvin"}]
		
		entriesDate = Todo.Server.entries_date(alvin, ~D[2020-05-23])
		assert entriesDate == [%{id: 3, date: ~D[2020-05-23], start_time: ~T[20:00:00], end_time: ~T[21:00:00], title: "Testing 3 for alvin"}]
		
		entriesTime = Todo.Server.entries_time(alvin, ~T[13:30:00])
		assert entriesTime == [%{id: 2, date: ~D[2020-05-22], start_time: ~T[13:30:00], end_time: ~T[14:00:00], title: "Testing 2 for alvin"}, %{id: 4, date: ~D[2020-05-24], start_time: ~T[13:30:00], end_time: ~T[14:00:00], title: "Testing 4 for alvin"}]
		
		entriesDateTime = Todo.Server.entries_dateTime(alvin, ~D[2020-05-22], ~T[13:30:00])
		assert entriesDateTime == [%{id: 2, date: ~D[2020-05-22], start_time: ~T[13:30:00], end_time: ~T[14:00:00], title: "Testing 2 for alvin"}]
	end
	
	test "persistence", context do
		john = Todo.Cache.server_process("john")
		Todo.Server.add_entry(john, %{date: ~D[2020-05-22], start_time: ~T[12:00:00], end_time: ~T[13:00:00], title: "Shopping"})
		assert length(Todo.Server.entries_date(john, ~D[2020-05-22])) == 1
		
		peter = Todo.Cache.server_process("peter")
		Todo.Server.add_entry(peter, %{date: ~D[2020-05-22], start_time: ~T[12:00:00], end_time: ~T[13:00:00], title: "Shopping"})
		assert length(Todo.Server.entries_date(peter, ~D[2020-05-22])) == 1
		
		mary = Todo.Cache.server_process("mary")
		Todo.Server.add_entry(mary, %{date: ~D[2020-05-22], start_time: ~T[12:00:00], end_time: ~T[13:00:00], title: "Shopping"})
		assert length(Todo.Server.entries_date(mary, ~D[2020-05-22])) == 1
		
		jason = Todo.Cache.server_process("jason")
		Todo.Server.add_entry(jason, %{date: ~D[2020-05-22], start_time: ~T[12:00:00], end_time: ~T[13:00:00], title: "Shopping"})
		assert length(Todo.Server.entries_date(jason, ~D[2020-05-22])) == 1
		
		Process.exit(john, :kill)
		Process.exit(peter, :kill)
		Process.exit(mary, :kill)
		Process.exit(jason, :kill)
		
		entries =
			"john"
			|> Todo.Cache.server_process()
			|> Todo.Server.entries_date(~D[2020-05-22])
			
		assert entries == [%{id: 1, date: ~D[2020-05-22], start_time: ~T[12:00:00], end_time: ~T[13:00:00], title: "Shopping"}]
	end
end
