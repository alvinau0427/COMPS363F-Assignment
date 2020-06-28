# COMPS363F-Assignment
> OUHK 2019/20 Distributed Systems and Parallel Computing (COMPS363F) Assignment

> Elixir Program: Schedule Database Server

[![Build Status](https://travis-ci.com/alvinau0427/COMPS363F-Assignment.svg?branch=master)](https://travis-ci.org/alvinau0427/COMPS363F-Assignment)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

## Getting Started
- Function including `Create a report summary (daily or weekly)`, `Add time in addition to date`, `Track time spenty as well as planning`.
- Efficiency or Capacity
- Fault Tolerance
- Automated Testing

## Installation

### Setup
- Program source code: `src/dynamic_workers/lib/todo`
- Automated testing code: `src/dynamic_workers/test`

```
$ cd ../src/dynamic_workers
$ mix compile

// for the automated testing with different test case in ../dynamic_workers/tests
$ mix test
```

### Run the program
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
