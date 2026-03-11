# COMPS363F-Assignment
> **OUHK 2019/20 Distributed Systems and Parallel Computing (COMPS363F) Assignment**
>
> A high-concurrency schedule management server built with **Elixir** and **OTP**, leveraging dynamic workers to handle schedule persistence, report generation, and time-tracking logic.

[![Elixir](https://img.shields.io/badge/Elixir-%234B275F.svg?&logo=elixir&logoColor=white)](#) &nbsp;
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE) &nbsp;

The system is architected to demonstrate core distributed computing principles:
* **Concurrency & Scalability:** Utilizes Elixir's lightweight processes to manage multiple schedules simultaneously.
* **Fault Tolerance:** Implements supervisor trees to ensure the database server remains resilient under failure.
* **Automated Verification:** Comprehensive test suite covering process lifecycle and data integrity.

## Key Features
* **Advanced Reporting:** Generate granular daily or weekly summary reports with event counters.
* **Precise Scheduling:** Support for date-time mapping, enabling planning down to the second.
* **Analytical Time Tracking:** Calculate actual time spent versus planned durations.
* **Dynamic Entry Management:** Full CRUD operations (Create, Read, Update, Delete) for schedule entries.
* **Multi-Dimensional Querying:** Filter and search entries by title, date, time, or specific date-time combinations.

## Installation & Testing

### Compilation
Navigate to the project root and compile the Mix project:
```
cd src/dynamic_workers
mix compile
```

### Automated Testing
Execute the test suite to verify fault tolerance and logic:
```
mix test
```

### Usage Guide
Launch the interactive Elixir shell (IEx) with the project modules loaded:
- The user guide is provided in `doc/report.pdf` or you can see the usage in `src/dynamic_workers/test/todo_list_test.exs`
- Execute the program and the data need to setup by yourself

```
$ iex -S mix

// example of create daily report summary
iex> todo_list =
	Todo.List.new([
		%{date: ~D[2020-05-22], start_time: ~T[12:00:00], end_time: ~T[13:00:00], title: "Movie"},
		%{date: ~D[2020-05-22], start_time: ~T[12:00:00], end_time: ~T[13:00:00], title: "Dentist"},
		%{date: ~D[2020-05-22], start_time: ~T[11:00:00], end_time: ~T[12:00:00], title: "Shopping"}
	])

iex> Todo.List.daily_summary(todo_list, ~D[2020-05-22])
 Daily Summary for date : 2020-05-22

 # Shopping     11:00:00 - 12:00:00     ( 1.0 hour(s) )
 # Dentist      12:00:00 - 13:00:00     ( 1.0 hour(s) )
 # Movie        12:00:00 - 13:00:00     ( 1.0 hour(s) )

 Event Counter : [Dentist: 1, Movie: 1, Shopping: 1]
 Total time spent in this day planning : 3.0 hour(s)
:ok

// example of create to-do list report
iex> todo_list =
	Todo.List.new([
		%{date: ~D[2020-05-22], start_time: ~T[12:00:00], end_time: ~T[13:00:00], title: "Movie"},
		%{date: ~D[2020-05-22], start_time: ~T[12:00:00], end_time: ~T[13:00:00], title: "Dentist"},
		%{date: ~D[2020-05-22], start_time: ~T[11:00:00], end_time: ~T[12:00:00], title: "Shopping"},
		%{date: ~D[2020-05-23], start_time: ~T[14:00:00], end_time: ~T[17:00:00], title: "Shopping"},
		%{date: ~D[2020-05-25], start_time: ~T[16:00:00], end_time: ~T[19:00:00], title: "Shopping"},
		%{date: ~D[2020-05-24], start_time: ~T[15:00:00], end_time: ~T[18:00:00], title: "Shopping"}
	])

iex> Todo.List.report_summary(todo_list)
 Report Summary :

 # Shopping     2020-05-22      11:00:00 - 12:00:00     ( 1.0 hour(s) )
 # Dentist      2020-05-22      12:00:00 - 13:00:00     ( 1.0 hour(s) )
 # Movie        2020-05-22      12:00:00 - 13:00:00     ( 1.0 hour(s) )
 # Shopping     2020-05-23      14:00:00 - 17:00:00     ( 3.0 hour(s) )
 # Shopping     2020-05-24      15:00:00 - 18:00:00     ( 3.0 hour(s) )
 # Shopping     2020-05-25      16:00:00 - 19:00:00     ( 3.0 hour(s) )

 Event Counter : [Dentist: 1, Movie: 1, Shopping: 4]
:ok

// example of add entry
iex> Todo.List.add_entry(%{date: ~D[2020-05-22], start_time: ~T[12:00:00], end_time: ~T[13:00:00], title: "Dentist"})

// example of update entry
iex> Todo.List.update_entry(2, &Map.put(&1, :title, "Updated shopping"))

// example of delete entry
iex> Todo.List.delete_entry(2)

// exmaple of count entries
iex> Todo.List.count_entries(todo_list)
iex> Todo.List.count_entries(todo_list, ~D[2020-05-22])

// example of entries
iex> Todo.List.entries(todo_list)
iex> Todo.List.entries_title("Movies")
iex> Todo.List.entries_date(~D[2020-05-22])
iex> Todo.List.entries_time(~T[13:00:00])
iex> Todo.List.entries_dateTime(~D[2020-05-23], ~T[13:00:00])

// example of track time
iex> Todo.List.track_time(todo_list, ~D[2020-05-30], "Shopping")
iex> Todo.List.track_time(todo_list, ~D[2020-05-22])
iex> Todo.List.track_timeForTitle(todo_list, "Shopping")
```

## Screenshots
![Image](https://github.com/alvinau0427/COMPS363F-Assignment/blob/master/doc/demo.png)

## License
- COMPS363F-Assignment is released under the [MIT License](https://opensource.org/licenses/MIT).
```
Copyright (c) 2020 alvinau0427

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
