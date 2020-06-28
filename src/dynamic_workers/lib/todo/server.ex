#---
# Course Name:	Distributed Systems and Parallel Computing		Course ID:	COMP S363F
# Student Name:	Au Chi Chung	Student ID:	12017765
# Remark:		Exam Assignment
#---

defmodule Todo.Server do
	use GenServer, restart: :temporary
	
	def start_link(name) do
		GenServer.start_link(Todo.Server, name, name: via_tuple(name))
	end
	
	def count_entries(todo_server) do
		GenServer.call(todo_server, {:count_entries})
	end
	
	def count_entries(todo_server, date) do
		GenServer.call(todo_server, {:count_entries, date})
	end
	
	def add_entry(todo_server, new_entry) do
		GenServer.cast(todo_server, {:add_entry, new_entry})
	end
	
	def report_summary(todo_server) do
		GenServer.call(todo_server, {:report_summary})
	end
	
	def daily_summary(todo_server, title) do
		GenServer.call(todo_server, {:daily_summary, title})
	end
	
	def entries(todo_server) do
		GenServer.call(todo_server, {:entries})
	end
	
	def entries_title(todo_server, title) do
		GenServer.call(todo_server, {:entries_title, title})
	end
	
	def entries_date(todo_server, date) do
		GenServer.call(todo_server, {:entries_date, date})
	end
	
	def entries_time(todo_server, start_time) do
		GenServer.call(todo_server, {:entries_time, start_time})
	end
	
	def entries_dateTime(todo_server, date, start_time) do
		GenServer.call(todo_server, {:entries_dateTime, date, start_time})
	end
	
	def track_time(todo_server, date) do
		GenServer.call(todo_server, {:track_time, date})
	end
	
	def track_time(todo_server, date, title) do
		GenServer.call(todo_server, {:track_time, date, title})
	end
	
	def track_timeForTitle(todo_server, title) do
		GenServer.call(todo_server, {:track_time, title})
	end
	
	defp via_tuple(name) do
		Todo.ProcessRegistry.via_tuple({__MODULE__, name})
	end
	
	@impl GenServer
	def init(name) do
		IO.puts("Starting to-do server for #{name}")
		{:ok, {name, Todo.Database.get(name) || Todo.List.new()}}
	end
	
	@impl GenServer
	def handle_call({:count_entries}, _, {name, todo_list}) do
		{
			:reply,
			Todo.List.count_entries(todo_list),
			{name, todo_list}
		}
	end
	
	@impl GenServer
	def handle_call({:count_entries, date}, _, {name, todo_list}) do
		{
			:reply,
			Todo.List.count_entries(todo_list, date),
			{name, todo_list}
		}
	end
	
	@impl GenServer
	def handle_cast({:add_entry, new_entry}, {name, todo_list}) do
		new_list = Todo.List.add_entry(todo_list, new_entry)
		Todo.Database.store(name, new_list)
		{:noreply, {name, new_list}}
	end
	
	@impl GenServer
	def handle_call({:report_summary}, _, {name, todo_list}) do
		{
			:reply,
			Todo.List.report_summary(todo_list),
			{name, todo_list}
		}
	end
	
	@impl GenServer
	def handle_call({:daily_summary, date}, _, {name, todo_list}) do
		{
			:reply,
			Todo.List.daily_summary(todo_list, date),
			{name, todo_list}
		}
	end
	
	@impl GenServer
	def handle_call({:entries}, _, {name, todo_list}) do
		{
			:reply,
			Todo.List.entries(todo_list),
			{name, todo_list}
		}
	end
	
	@impl GenServer
	def handle_call({:entries_title, title}, _, {name, todo_list}) do
		{
			:reply,
			Todo.List.entries_title(todo_list, title),
			{name, todo_list}
		}
	end
	
	@impl GenServer
	def handle_call({:entries_date, date}, _, {name, todo_list}) do
		{
			:reply,
			Todo.List.entries_date(todo_list, date),
			{name, todo_list}
		}
	end
	
	@impl GenServer
	def handle_call({:entries_time, start_time}, _, {name, todo_list}) do
		{
			:reply,
			Todo.List.entries_time(todo_list, start_time),
			{name, todo_list}
		}
	end
	
	@impl GenServer
	def handle_call({:entries_dateTime, date, start_time}, _, {name, todo_list}) do
		{
			:reply,
			Todo.List.entries_dateTime(todo_list, date, start_time),
			{name, todo_list}
		}
	end
	
	@impl GenServer
	def handle_call({:track_time, date}, _, {name, todo_list}) do
		{
			:reply,
			Todo.List.track_time(todo_list, date),
			{name, todo_list}
		}
	end
	
	@impl GenServer
	def handle_call({:track_time, date, title}, _, {name, todo_list}) do
		{
			:reply,
			Todo.List.track_time(todo_list, date, title),
			{name, todo_list}
		}
	end
	
	@impl GenServer
	def handle_call({:track_timeForTitle, title}, _, {name, todo_list}) do
		{
			:reply,
			Todo.List.track_timeForTitle(todo_list, title),
			{name, todo_list}
		}
	end
end
