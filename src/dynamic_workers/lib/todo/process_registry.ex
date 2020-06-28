#---
# Course Name:	Distributed Systems and Parallel Computing		Course ID:	COMP S363F
# Student Name:	Au Chi Chung	Student ID:	12017765
# Remark:		Exam Assignment
#---

defmodule Todo.ProcessRegistry do
	def start_link do
		Registry.start_link(keys: :unique, name: __MODULE__)
	end
	
	def via_tuple(key) do
		{:via, Registry, {__MODULE__, key}}
	end
	
	def child_spec(_) do
		Supervisor.child_spec(
			Registry,
			id: __MODULE__,
			start: {__MODULE__, :start_link, []}
		)
	end
end
