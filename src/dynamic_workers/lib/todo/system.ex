#---
# Course Name:	Distributed Systems and Parallel Computing		Course ID:	COMP S363F
# Student Name:	Au Chi Chung	Student ID:	12017765
# Remark:		Exam Assignment
#---

defmodule Todo.System do
	def start_link do
		Supervisor.start_link(
			[
				Todo.ProcessRegistry,
				Todo.Database,
				Todo.Cache
			],
			strategy: :one_for_one
		)
	end
end
